# utils/suggestion_engine.py

def bmi_category(bmi):
    if bmi < 18.5:
        return "Underweight"
    if bmi < 25:
        return "Normal"
    if bmi < 30:
        return "Overweight"
    return "Obese"


def generate_suggestions(health_data: dict, risks: list):
    suggestions = []
    priority = []

    sugar = health_data.get("bloodSugar")
    bmi = health_data.get("bmi")
    bp = health_data.get("bloodPressure")
    oxygen = health_data.get("oxygen")
    heart_rate = health_data.get("heartRate")

    systolic = diastolic = None
    if bp and "/" in str(bp):
        try:
            parts = str(bp).split("/")
            systolic = int(parts[0])
            diastolic = int(parts[1])
        except Exception:
            pass

    if "Diabetes" in risks:
        priority += [
            "Monitor blood glucose regularly and maintain a log",
            "Consult an endocrinologist for diabetes management"
        ]
        suggestions += [
            "Reduce sugar and refined carbs",
            "Get 30 minutes of daily physical activity"
        ]

    if "Heart Disease" in risks:
        priority += [
            "Schedule a checkup with a cardiologist soon",
            "Monitor blood pressure daily"
        ]
        suggestions += [
            "Reduce salt and saturated fat intake",
            "Practice stress management (meditation/yoga)"
        ]

    if "Hypertension" in risks:
        priority += [
            "Limit sodium to <2,300mg/day",
            "Monitor BP at home twice daily"
        ]
        suggestions += ["Maintain a healthy weight"]

    if "Kidney Disease" in risks:
        priority += [
            "Get kidney function tests (creatinine, eGFR)",
            "Control blood pressure and sugar strictly"
        ]
        suggestions += ["Stay well hydrated"]

    if "Thyroid Disorder" in risks:
        priority += ["Get thyroid function tests (TSH, T3, T4)"]
        suggestions += ["Consult an endocrinologist for evaluation"]

    # Value-based
    if bmi and bmi > 30:
        priority.append("Consult a nutritionist for weight management")
    elif bmi and bmi > 25:
        suggestions.append("Follow balanced diet with portion control")

    if oxygen and oxygen < 93:
        priority.append("Seek medical attention — low oxygen level")
    elif oxygen and oxygen < 95:
        suggestions.append("Practice deep breathing exercises")

    if heart_rate and heart_rate > 100:
        suggestions.append("Limit caffeine; ensure 7-9 hours sleep")
    elif heart_rate and heart_rate < 50:
        priority.append("Consult cardiologist about low heart rate")

    if not risks:
        return [
            "Continue your healthy lifestyle habits",
            "Schedule annual health checkups",
            "150 minutes of moderate exercise weekly",
            "Balanced diet with fruits and vegetables",
            "Stay hydrated throughout the day"
        ]

    # Dedupe preserving order
    seen = set()
    final = []
    for s in priority + suggestions:
        if s not in seen:
            seen.add(s)
            final.append(s)

    return final[:8]
