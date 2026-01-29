import joblib

model = joblib.load("models/diabetes.pkl")

def analyze_diabetes(data):
    prob = model.predict_proba([[data["bloodSugar"], data["bmi"]]])[0][1]

    if prob < 0.4:
        return []

    reasons = []
    if data["bloodSugar"] > 140:
        reasons.append("High blood sugar level")
    if data["bmi"] > 25:
        reasons.append("BMI above normal")
    if "Fatigue" in data["symptoms"]:
        reasons.append("Reported fatigue")

    return [{
        "disease": "Diabetes",
        "riskLevel": "High" if prob > 0.7 else "Moderate",
        "confidence": round(prob, 2),
        "reasons": reasons,
        "suggestions": [
            "Reduce sugar intake",
            "Exercise daily",
            "Monitor glucose levels"
        ]
    }]
