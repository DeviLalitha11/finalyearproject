# from .model_loader import (
#     diabetes_model,
#     heart_model,
#     kidney_model,
#     thyroid_model
# )

# from explainability.explanation_engine import generate_explanations
# from utils.suggestion_engine import generate_suggestions

# def run_full_analysis(health_data: dict) -> dict:
#     """
#     Central AI analysis function
#     """

#     risks = []
#     explanations = []
#     suggestions = []

#     # -----------------------------
#     # Extract inputs
#     # -----------------------------
#     heart_rate = health_data.get("heartRate")
#     blood_pressure = health_data.get("bloodPressure")  # "130/90"
#     blood_sugar = health_data.get("bloodSugar")
#     bmi = health_data.get("bmi")
#     oxygen = health_data.get("oxygen")
#     temperature = health_data.get("temperature")
#     symptoms = health_data.get("symptoms", [])

#     systolic, diastolic = map(int, blood_pressure.split("/"))

#     # -----------------------------
#     # DIABETES
#     # -----------------------------
#     diabetes_risk = diabetes_model.predict([[blood_sugar, bmi]])[0]
#     if diabetes_risk == 1:
#         risks.append("Diabetes")
#         explanations.append(
#             generate_explanations(
#                 "Diabetes", blood_sugar=blood_sugar, bmi=bmi, symptoms=symptoms
#             )
#         )
#         suggestions.extend(generate_suggestions("Diabetes", health_data))

#     # -----------------------------
#     # HEART DISEASE
#     # -----------------------------
#     heart_risk = heart_model.predict([[heart_rate, systolic, bmi, oxygen]])[0]
#     if heart_risk == 1:
#         risks.append("Heart Disease")
#         explanations.append(
#             generate_explanations(
#                 "Heart Disease",
#                 heart_rate=heart_rate,
#                 blood_pressure=blood_pressure,
#                 oxygen=oxygen,
#             )
#         )
#         suggestions.extend(generate_suggestions("Heart Disease", health_data))

#     # -----------------------------
#     # KIDNEY (rule + ML hybrid)
#     # -----------------------------
#     kidney_risk = 1 if blood_pressure and systolic > 140 else 0
#     if kidney_risk == 1:
#         risks.append("Kidney Disease")
#         explanations.append(
#             generate_explanations(
#                 "Kidney Disease", blood_pressure=blood_pressure
#             )
#         )
#         suggestions.extend(generate_suggestions("Kidney Disease", health_data))

#     # -----------------------------
#     # THYROID (rule-based)
#     # -----------------------------
#     if "Fatigue" in symptoms and temperature < 97:
#         risks.append("Thyroid Disorder")
#         explanations.append(
#             generate_explanations(
#                 "Thyroid", symptoms=symptoms, temperature=temperature
#             )
#         )
#         suggestions.extend(generate_suggestions("Thyroid", health_data))

#     # -----------------------------
#     # HYPERTENSION
#     # -----------------------------
#     hypertension_risk = hypertension_model.predict([[systolic, diastolic, bmi]])[0]
#     if hypertension_risk == 1:
#         risks.append("Hypertension")
#         explanations.append(
#             generate_explanations(
#                 "Hypertension", blood_pressure=blood_pressure, bmi=bmi
#             )
#         )
#         suggestions.extend(generate_suggestions("Hypertension", health_data))

#     # -----------------------------
#     # NO DISEASE CASE
#     # -----------------------------
#     if not risks:
#         return {
#             "status": "success",
#             "riskLevel": "Low",
#             "diseases": [],
#             "message": "No major health risks detected based on your current data.",
#             "recommendations": [
#                 "Maintain a balanced diet",
#                 "Exercise regularly",
#                 "Monitor health metrics periodically",
#             ],
#         }

#     # -----------------------------
#     # FINAL RESPONSE
#     # -----------------------------
#     return {
#         "status": "success",
#         "riskLevel": "High" if len(risks) >= 2 else "Moderate",
#         "diseases": list(set(risks)),
#         "explanations": explanations,
#         "suggestions": list(set(suggestions)),
#     }




from services.diabetes_service import analyze_diabetes
from services.heart_service import analyze_heart
from services.kidney_service import analyze_kidney
from services.thyroid_service import analyze_thyroid
from services.hypertension_service import analyze_hypertension

from explainability.explanation_engine import generate_explanations
from utils.suggestion_engine import generate_suggestions


def run_full_analysis(health_data: dict):

    risks = []
    explanations = []
    suggestions = []

    # ---------------- SAFE EXTRACTION ----------------
    heart_rate = health_data.get("heartRate")
    blood_sugar = health_data.get("bloodSugar")
    bmi = health_data.get("bmi")
    bp = health_data.get("bloodPressure")
    oxygen = health_data.get("oxygen")

    systolic = None
    diastolic = None
    if bp and "/" in bp:
        systolic, diastolic = map(int, bp.split("/"))

    # ---------------- DIABETES ----------------
    if blood_sugar and bmi:
        diabetes = analyze_diabetes(health_data)
        if diabetes:
            risks.append("Diabetes")

    # ---------------- HEART ----------------
    if heart_rate and systolic:
        heart = analyze_heart(health_data)
        if heart:
            risks.append("Heart Disease")

    # ---------------- HYPERTENSION ----------------
    if systolic and diastolic:
        hyper = analyze_hypertension(health_data)
        if hyper:
            risks.append("Hypertension")

    # ---------------- KIDNEY ----------------
    if systolic:
        kidney = analyze_kidney(health_data)
        if kidney:
            risks.append("Kidney Disease")

    # ---------------- THYROID ----------------
    if bmi:
        thyroid = analyze_thyroid(health_data)
        if thyroid:
            risks.append("Thyroid Disorder")

    # ---------------- EXPLAINABILITY ----------------
    explanations = generate_explanations(health_data, risks)

    # ---------------- SUGGESTIONS ----------------
    suggestions = generate_suggestions(health_data, risks)

    # ---------------- FINAL RESPONSE ----------------
    if not risks:
        return {
            "status": "success",
            "riskLevel": "Low",
            "diseases": [],
            "message": "No major health risks detected based on your current data.",
            "explanations": [],
            "suggestions": suggestions
        }

    return {
        "status": "success",
        "riskLevel": "High" if len(risks) >= 2 else "Moderate",
        "diseases": list(set(risks)),
        "explanations": explanations,
        "suggestions": list(set(suggestions))
    }
