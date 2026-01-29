import joblib

model = joblib.load("models/heart.pkl")

def analyze_heart(data):
    prob = model.predict_proba([[50, int(data["bloodPressure"].split("/")[0]), 240, data["heartRate"]]])[0][1]

    if prob < 0.4:
        return []

    return [{
        "disease": "Heart Disease",
        "riskLevel": "High" if prob > 0.7 else "Moderate",
        "confidence": round(prob, 2),
        "reasons": [
            "Elevated blood pressure",
            "High heart rate"
        ],
        "suggestions": [
            "Reduce salt intake",
            "Consult cardiologist",
            "Practice stress management"
        ]
    }]
