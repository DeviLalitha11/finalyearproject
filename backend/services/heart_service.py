# services/heart_service.py

from services.model_loader import load_model

model = load_model("heart")


def analyze_heart(data):
    heart_rate = int(data.get("heartRate", 75))
    bp_str = str(data.get("bloodPressure", "120/80"))
    age = int(data.get("age", 40))
    cholesterol = float(data.get("cholesterol", 200))

    try:
        systolic = int(bp_str.split("/")[0])
    except Exception:
        systolic = 120

    try:
        ml_prob = float(model.predict_proba([[age, systolic, cholesterol, heart_rate]])[0][1])
    except Exception as e:
        print(f"Heart ML error: {e}")
        ml_prob = 0.3

    rule_prob = 0.0
    if systolic >= 160:
        rule_prob += 0.35
    elif systolic >= 140:
        rule_prob += 0.22
    elif systolic >= 130:
        rule_prob += 0.10

    if heart_rate > 110 or heart_rate < 50:
        rule_prob += 0.25
    elif heart_rate > 100 or heart_rate < 60:
        rule_prob += 0.12

    if cholesterol >= 240:
        rule_prob += 0.20
    elif cholesterol >= 200:
        rule_prob += 0.08

    if age >= 55:
        rule_prob += 0.15
    elif age >= 45:
        rule_prob += 0.08

    symptoms = data.get("symptoms", [])
    heart_symptoms = ["Chest Pain", "Shortness of Breath", "Dizziness", "Fatigue"]
    symptom_count = sum(1 for s in symptoms if s in heart_symptoms)
    rule_prob += symptom_count * 0.06

    rule_prob = min(rule_prob, 1.0)
    final_prob = float(0.6 * ml_prob + 0.4 * rule_prob)

    reasons = []
    if systolic > 140:
        reasons.append(f"High blood pressure ({systolic} mmHg systolic)")
    if heart_rate > 100:
        reasons.append(f"Elevated heart rate ({heart_rate} bpm)")
    elif heart_rate < 60:
        reasons.append(f"Low heart rate ({heart_rate} bpm)")
    if cholesterol > 200:
        reasons.append(f"Elevated cholesterol ({cholesterol} mg/dL)")
    if age >= 55:
        reasons.append("Age is a risk factor")

    return {
        "disease": "Heart Disease",
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
