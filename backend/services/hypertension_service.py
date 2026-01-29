def analyze_hypertension(data):
    sys, dia = map(int, data["bloodPressure"].split("/"))

    if sys < 130 and dia < 85:
        return []

    level = "High" if sys >= 140 or dia >= 90 else "Moderate"

    return [{
        "disease": "Hypertension",
        "riskLevel": level,
        "confidence": 0.9,
        "reasons": [
            f"Blood pressure reading {sys}/{dia}"
        ],
        "suggestions": [
            "Reduce salt intake",
            "Exercise regularly",
            "Monitor blood pressure"
        ]
    }]
