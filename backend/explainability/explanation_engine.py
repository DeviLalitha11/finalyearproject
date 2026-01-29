def generate_explanations(health_data: dict, risks: list):
    """
    Generate human-readable explanations for detected risks.
    This is rule-based XAI (Explainable AI).
    """

    explanations = []

    sugar = health_data.get("bloodSugar")
    bmi = health_data.get("bmi")
    bp = health_data.get("bloodPressure")
    oxygen = health_data.get("oxygen")
    heart_rate = health_data.get("heartRate")

    if "Diabetes" in risks:
        reasons = []
        if sugar and sugar > 140:
            reasons.append("high blood sugar levels")
        if bmi and bmi > 25:
            reasons.append("BMI above the normal range")
        explanations.append(
            "Diabetes risk detected mainly due to " + ", ".join(reasons)
        )

    if "Heart Disease" in risks:
        reasons = []
        if heart_rate and heart_rate > 100:
            reasons.append("elevated heart rate")
        if bp:
            systolic = int(bp.split("/")[0])
            if systolic > 140:
                reasons.append("high blood pressure")
        explanations.append(
            "Heart disease risk detected mainly due to " + ", ".join(reasons)
        )

    if "Kidney Disease" in risks:
        explanations.append(
            "Kidney risk detected due to abnormal blood pressure or sugar levels"
        )

    if "Thyroid Disease" in risks:
        explanations.append(
            "Thyroid risk detected based on age and symptom patterns"
        )

    if not explanations:
        explanations.append(
            "No major health risks detected based on your current data."
        )

    return explanations
