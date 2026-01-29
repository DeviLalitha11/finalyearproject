import joblib

model = joblib.load("models/thyroid.pkl")

def analyze_thyroid(data):
    prob = model.predict_proba([[40, 0, 1]])[0][1]

    if prob < 0.4:
        return []

    return [{
        "disease": "Thyroid Disorder",
        "riskLevel": "Moderate",
        "confidence": round(prob, 2),
        "reasons": [
            "Reported fatigue",
            "Abnormal metabolic indicators"
        ],
        "suggestions": [
            "Get thyroid function tests",
            "Maintain iodine-balanced diet"
        ]
    }]
