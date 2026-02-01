def bmi_category(bmi):
    """Classify BMI into categories"""
    if bmi < 18.5:
        return "Underweight"
    if bmi < 25:
        return "Normal"
    if bmi < 30:
        return "Overweight"
    return "Obese"


def generate_suggestions(health_data: dict, risks: list):
    """
    Generate prioritized health suggestions based on detected risks.
    Returns top priority suggestions only (max 5-8).
    """

    suggestions = []
    priority_suggestions = []  # Most important ones

    sugar = health_data.get("bloodSugar")
    bmi = health_data.get("bmi")
    bp = health_data.get("bloodPressure")
    oxygen = health_data.get("oxygen")
    heart_rate = health_data.get("heartRate")

    # Extract systolic and diastolic
    systolic = None
    diastolic = None
    if bp and "/" in str(bp):
        try:
            parts = str(bp).split("/")
            systolic = int(parts[0])
            diastolic = int(parts[1])
        except (ValueError, IndexError):
            pass

    # ---------------- PRIORITY SUGGESTIONS FOR DISEASES ----------------
    if "Diabetes" in risks:
        priority_suggestions.extend([
            "Monitor blood glucose levels regularly and maintain a log",
            "Consult an endocrinologist for proper diabetes management",
        ])
        suggestions.extend([
            "Reduce sugar and refined carbohydrate intake",
            "Engage in 30 minutes of physical activity daily",
        ])

    if "Heart Disease" in risks:
        priority_suggestions.extend([
            "Schedule a checkup with a cardiologist as soon as possible",
            "Monitor blood pressure daily and keep a record",
        ])
        suggestions.extend([
            "Reduce salt and saturated fat in your diet",
            "Practice stress management through meditation",
        ])

    if "Hypertension" in risks or (systolic and systolic > 140):
        priority_suggestions.extend([
            "Limit sodium intake to less than 2,300mg per day",
            "Monitor blood pressure at home twice daily",
        ])
        suggestions.extend([
            "Maintain a healthy weight through diet and exercise",
        ])

    if "Kidney Disease" in risks:
        priority_suggestions.extend([
            "Get kidney function tests done immediately",
            "Control blood pressure and blood sugar levels",
        ])
        suggestions.extend([
            "Stay well hydrated with adequate water intake",
        ])

    if "Thyroid Disorder" in risks or "Thyroid Disease" in risks:
        priority_suggestions.extend([
            "Get thyroid function tests (TSH, T3, T4) done",
        ])
        suggestions.extend([
            "Consult an endocrinologist for evaluation",
        ])

    # ---------------- SPECIFIC VALUE-BASED SUGGESTIONS ----------------
    if bmi and bmi > 30:
        priority_suggestions.append("Consult a nutritionist for a weight management plan")
    elif bmi and bmi > 25:
        suggestions.append("Follow a balanced diet with portion control")

    if oxygen and oxygen < 93:
        priority_suggestions.append("Seek medical attention for low oxygen levels")
    elif oxygen and oxygen < 95:
        suggestions.append("Practice deep breathing exercises daily")

    if heart_rate and heart_rate > 100:
        suggestions.append("Limit caffeine and get adequate sleep (7-9 hours)")
    elif heart_rate and heart_rate < 50:
        priority_suggestions.append("Consult a cardiologist about low heart rate")

    # ---------------- NO RISK CASE ----------------
    if not risks:
        suggestions = [
            "Continue your healthy lifestyle habits",
            "Get annual health checkups",
            "Stay physically active with 150 minutes of exercise weekly",
            "Maintain a balanced diet with fruits and vegetables",
            "Stay well-hydrated throughout the day"
        ]
        return suggestions[:5]  # Return only 5 for low risk

    # Combine priority and regular suggestions
    all_suggestions = priority_suggestions + suggestions

    # Remove duplicates while preserving order
    seen = set()
    unique_suggestions = []
    for suggestion in all_suggestions:
        if suggestion not in seen:
            seen.add(suggestion)
            unique_suggestions.append(suggestion)

    # Return top 6-8 suggestions max
    return unique_suggestions[:8]