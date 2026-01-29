def generate_suggestions(health_data: dict, risks: list):
    """
    Generate personalized health suggestions based on detected risks
    and user health values.
    """

    suggestions = []

    sugar = health_data.get("bloodSugar")
    bmi = health_data.get("bmi")
    bp = health_data.get("bloodPressure")
    oxygen = health_data.get("oxygen")
    heart_rate = health_data.get("heartRate")

    # ---------------- DIABETES ----------------
    if "Diabetes" in risks:
        suggestions.extend([
            "Reduce sugar and refined carbohydrate intake",
            "Engage in regular physical activity",
            "Monitor blood glucose levels regularly",
            "Consult a doctor for proper diabetes management"
        ])

    # ---------------- HEART ----------------
    if "Heart Disease" in risks:
        suggestions.extend([
            "Reduce salt and saturated fat intake",
            "Practice daily cardiovascular exercise",
            "Manage stress through relaxation techniques",
            "Monitor blood pressure regularly"
        ])

    # ---------------- HYPERTENSION ----------------
    if bp:
        systolic = int(bp.split("/")[0])
        if systolic > 140:
            suggestions.extend([
                "Limit sodium intake",
                "Maintain a healthy weight",
                "Avoid smoking and alcohol",
                "Regularly check blood pressure"
            ])

    # ---------------- BMI ----------------
    if bmi and bmi > 25:
        suggestions.extend([
            "Follow a balanced diet plan",
            "Increase daily physical activity",
            "Avoid processed and fast foods"
        ])

    # ---------------- OXYGEN ----------------
    if oxygen and oxygen < 95:
        suggestions.extend([
            "Practice deep breathing exercises",
            "Avoid polluted environments",
            "Seek medical attention if oxygen remains low"
        ])

    # ---------------- NO RISK CASE ----------------
    if not risks:
        suggestions.extend([
            "Maintain a healthy lifestyle",
            "Continue regular health checkups",
            "Stay physically active and hydrated"
        ])

    return suggestions
