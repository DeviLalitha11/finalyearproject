# services/hypertension_service.py

from services.model_loader import load_model

model = load_model("hypertension")


def analyze_hypertension(data):
    bp_str = str(data.get("bloodPressure", "120/80"))
    age = int(data.get("age", 35))
    bmi = float(data.get("bmi", 22))

    try:
        parts = bp_str.split("/")
        systolic = int(parts[0])
        diastolic = int(parts[1])
    except Exception:
        return {
            "disease": "Hypertension",
            "probability": 0.0,
            "percentage": 0.0,
            "detected": False,
            "reasons": [],
            "severity": "Very Low"
        }

    try:
        ml_prob = float(model.predict_proba([[systolic, diastolic, age, bmi]])[0][1])
    except Exception as e:
        print(f"Hypertension ML error: {e}")
        ml_prob = 0.3

    rule_prob = 0.0
    if systolic >= 180 or diastolic >= 120:
        rule_prob = 0.95
    elif systolic >= 140 or diastolic >= 90:
        rule_prob = 0.80
    elif systolic >= 130 or diastolic >= 80:
        rule_prob = 0.60
    elif systolic >= 120:
        rule_prob = 0.30
    else:
        rule_prob = 0.10

    if bmi >= 30:
        rule_prob = min(rule_prob + 0.08, 1.0)
    if age >= 55:
        rule_prob = min(rule_prob + 0.05, 1.0)

    final_prob = float(0.4 * ml_prob + 0.6 * rule_prob)

    reasons = []
    if systolic >= 140 or diastolic >= 90:
        reasons.append(f"Stage 2 Hypertension ({systolic}/{diastolic} mmHg)")
    elif systolic >= 130 or diastolic >= 80:
        reasons.append(f"Stage 1 Hypertension ({systolic}/{diastolic} mmHg)")
    elif systolic >= 120:
        reasons.append(f"Elevated BP ({systolic}/{diastolic} mmHg)")

    return {
        "disease": "Hypertension",
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
