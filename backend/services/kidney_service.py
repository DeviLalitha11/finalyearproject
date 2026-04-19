# services/kidney_service.py

from services.model_loader import load_model

model = load_model("kidney")


def analyze_kidney(data):
    bp_str = str(data.get("bloodPressure", "120/80"))
    sugar = float(data.get("bloodSugar", 100))
    bmi = float(data.get("bmi", 22))
    age = int(data.get("age", 35))

    try:
        systolic = int(bp_str.split("/")[0])
    except Exception:
        systolic = 120

    try:
        ml_prob = float(model.predict_proba([[systolic, sugar, bmi, age]])[0][1])
    except Exception as e:
        print(f"Kidney ML error: {e}")
        ml_prob = 0.25

    rule_prob = 0.0
    if systolic >= 160:
        rule_prob += 0.30
    elif systolic >= 140:
        rule_prob += 0.18

    if sugar >= 180:
        rule_prob += 0.25
    elif sugar >= 140:
        rule_prob += 0.12

    if age >= 60:
        rule_prob += 0.15
    elif age >= 50:
        rule_prob += 0.08

    if bmi >= 30:
        rule_prob += 0.10

    rule_prob = min(rule_prob, 1.0)
    final_prob = float(0.6 * ml_prob + 0.4 * rule_prob)

    reasons = []
    if systolic > 140:
        reasons.append("High blood pressure affecting kidney function")
    if sugar > 140:
        reasons.append("Elevated blood sugar stresses kidneys")
    if age >= 60:
        reasons.append("Age-related kidney function decline")

    return {
        "disease": "Kidney Disease",
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
