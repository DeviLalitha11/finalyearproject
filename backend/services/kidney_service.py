import joblib

model = joblib.load("models/kidney.pkl")

def analyze_kidney(data):
    prob = model.predict_proba([[80, 1.02, 1, 0]])[0][1]

    if prob < 0.4:
        return []

    return [{
        "disease": "Kidney Disease",
        "riskLevel": "Moderate",
        "confidence": round(prob, 2),
        "reasons": [
            "Abnormal blood pressure",
            "Possible protein in urine"
        ],
        "suggestions": [
            "Stay hydrated",
            "Limit protein intake",
            "Consult nephrologist"
        ]
    }]
