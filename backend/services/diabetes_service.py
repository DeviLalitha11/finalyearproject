# services/diabetes_service.py

from services.model_loader import load_model

model = load_model("diabetes")


def analyze_diabetes(data):
    sugar = float(data.get("bloodSugar", 100))
    bmi = float(data.get("bmi", 22))
    age = int(data.get("age", 35))
    bp_str = str(data.get("bloodPressure", "120/80"))

    try:
        systolic = int(bp_str.split("/")[0])
    except Exception:
        systolic = 120

    # ML Prediction
    try:
        ml_prob = float(model.predict_proba([[sugar, bmi, age, systolic]])[0][1])
    except Exception as e:
        print(f"Diabetes ML error: {e}")
        ml_prob = 0.3

    # Rule-based probability
    rule_prob = 0.0
    if sugar >= 200:
        rule_prob += 0.50
    elif sugar >= 140:
        rule_prob += 0.30
    elif sugar >= 126:
        rule_prob += 0.20
    elif sugar >= 100:
        rule_prob += 0.08

    if bmi >= 30:
        rule_prob += 0.20
    elif bmi >= 25:
        rule_prob += 0.10

    if age >= 45:
        rule_prob += 0.10

    symptoms = data.get("symptoms", [])
    diabetes_symptoms = ["Fatigue", "Frequent Urination", "Excessive Thirst", "Blurred Vision"]
    symptom_count = sum(1 for s in symptoms if s in diabetes_symptoms)
    rule_prob += symptom_count * 0.05
    rule_prob = min(rule_prob, 1.0)

    final_prob = float(0.6 * ml_prob + 0.4 * rule_prob)

    reasons = []
    if sugar > 140:
        reasons.append(f"Elevated blood sugar ({sugar} mg/dL)")
    if bmi > 25:
        reasons.append(f"BMI above normal ({bmi:.1f})")
    if age >= 45:
        reasons.append("Age factor (45+)")
    if symptom_count > 0:
        reasons.append("Symptoms suggestive of diabetes")

    # ✅ FIX: Convert all numpy types to Python native types
    return {
        "disease": "Diabetes",
        "probability": round(float(final_prob), 3),
        "percentage": round(float(final_prob) * 100, 1),
        "detected": bool(final_prob >= 0.50),
        "reasons": reasons,
        "severity": _severity(final_prob)
    }


def _severity(p):
    p = float(p)
    if p >= 0.75:
        return "High"
    elif p >= 0.50:
        return "Moderate"
    elif p >= 0.30:
        return "Low"
    return "Very Low"
