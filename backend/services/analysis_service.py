# services/analysis_service.py

import numpy as np
from services.diabetes_service import analyze_diabetes
from services.heart_service import analyze_heart
from services.kidney_service import analyze_kidney
from services.thyroid_service import analyze_thyroid
from services.hypertension_service import analyze_hypertension

from explainability.explanation_engine import generate_explanations
from utils.suggestion_engine import generate_suggestions


def _to_native(obj):
    """
    Recursively convert numpy types to native Python types
    so FastAPI can serialize them to JSON.
    """
    if isinstance(obj, dict):
        return {k: _to_native(v) for k, v in obj.items()}
    if isinstance(obj, (list, tuple)):
        return [_to_native(x) for x in obj]
    if isinstance(obj, np.ndarray):
        return obj.tolist()
    if isinstance(obj, (np.bool_,)):
        return bool(obj)
    if isinstance(obj, (np.integer,)):
        return int(obj)
    if isinstance(obj, (np.floating,)):
        return float(obj)
    return obj


def run_full_analysis(health_data: dict):
    """
    Main orchestrator: runs all 5 predictions and returns safe JSON.
    """

    all_predictions = []
    detected_diseases = []

    analyzers = [
        ("Diabetes", analyze_diabetes),
        ("Heart Disease", analyze_heart),
        ("Hypertension", analyze_hypertension),
        ("Kidney Disease", analyze_kidney),
        ("Thyroid Disorder", analyze_thyroid),
    ]

    for name, func in analyzers:
        try:
            result = func(health_data)
            # ✅ Convert numpy types to native Python
            result = _to_native(result)
            all_predictions.append(result)
            if result.get("detected"):
                detected_diseases.append(result["disease"])
        except Exception as e:
            print(f"❌ Error analyzing {name}: {e}")
            import traceback
            traceback.print_exc()
            all_predictions.append({
                "disease": name,
                "probability": 0.0,
                "percentage": 0.0,
                "detected": False,
                "reasons": [],
                "severity": "Unknown"
            })

    # Overall risk
    probs = [float(p["probability"]) for p in all_predictions]
    max_prob = max(probs, default=0.0)
    avg_prob = sum(probs) / max(len(probs), 1)

    if max_prob >= 0.75 or len(detected_diseases) >= 3:
        overall_risk = "High"
    elif max_prob >= 0.50 or len(detected_diseases) >= 1:
        overall_risk = "Moderate"
    elif max_prob >= 0.30 or avg_prob >= 0.25:
        overall_risk = "Low"
    else:
        overall_risk = "Very Low"

    explanations = generate_explanations(health_data, detected_diseases, all_predictions)
    suggestions = generate_suggestions(health_data, detected_diseases)

    disease_predictions = [
        {
            "disease": str(p["disease"]),
            "percentage": float(p["percentage"]),
            "probability": float(p["probability"]),
            "severity": str(p["severity"]),
            "detected": bool(p["detected"]),
            "reasons": [str(r) for r in p["reasons"]]
        }
        for p in all_predictions
    ]

    if not detected_diseases:
        message = (
            "Good news! No major health risks detected. "
            "However, please review individual disease probabilities and suggestions below."
        )
    elif len(detected_diseases) == 1:
        message = (
            f"Possible early signs of {detected_diseases[0]} detected. "
            "Please don't panic — consult a doctor for confirmation and guidance."
        )
    else:
        message = (
            f"Possible risk indicators for: {', '.join(detected_diseases)}. "
            "These are predictions and NOT medical diagnoses. Please consult a qualified physician."
        )

    # ✅ Final safety conversion on entire response
    response = {
        "status": "success",
        "riskLevel": overall_risk,
        "diseases": [str(d) for d in detected_diseases],
        "predictions": disease_predictions,
        "explanations": [str(e) for e in explanations],
        "suggestions": [str(s) for s in suggestions],
        "message": message,
        "disclaimer": (
            "⚠️ This is an AI-based prediction tool for informational purposes only. "
            "It is not a substitute for professional medical diagnosis or treatment."
        )
    }

    return _to_native(response)
