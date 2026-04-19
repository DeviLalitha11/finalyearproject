# services/thyroid_service.py

from services.model_loader import load_model

model = load_model("thyroid")


def analyze_thyroid(data):
    age = int(data.get("age", 35))
    bmi = float(data.get("bmi", 22))
    hr = int(data.get("heartRate", 75))
    gender_str = str(data.get("gender", "male")).lower()
    gender = 1 if gender_str in ("female", "f") else 0

    try:
        ml_prob = float(model.predict_proba([[age, bmi, hr, gender]])[0][1])
    except Exception as e:
        print(f"Thyroid ML error: {e}")
        ml_prob = 0.2

    rule_prob = 0.0

    if bmi >= 30:
        rule_prob += 0.15
    if hr < 60:
        rule_prob += 0.15

    if bmi < 18.5:
        rule_prob += 0.12
    if hr > 100:
        rule_prob += 0.15

    if gender == 1:
        rule_prob += 0.08
    if age >= 50:
        rule_prob += 0.08

    symptoms = data.get("symptoms", [])
    thyroid_symptoms = ["Fatigue", "Weight Gain", "Weight Loss", "Cold Intolerance", "Heat Intolerance"]
    symptom_count = sum(1 for s in symptoms if s in thyroid_symptoms)
    rule_prob += symptom_count * 0.06

    rule_prob = min(rule_prob, 1.0)
    final_prob = float(0.5 * ml_prob + 0.5 * rule_prob)

    reasons = []
    if hr < 60:
        reasons.append("Low heart rate (possible hypothyroid sign)")
    if hr > 100:
        reasons.append("High heart rate (possible hyperthyroid sign)")
    if bmi >= 30 or bmi < 18.5:
        reasons.append("Abnormal BMI may indicate thyroid imbalance")
    if symptom_count > 0:
        reasons.append("Symptoms suggestive of thyroid issue")

    return {
        "disease": "Thyroid Disorder",
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
