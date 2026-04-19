# explainability/explanation_engine.py

def generate_explanations(health_data: dict, risks: list, predictions: list = None):
    """
    Rule-based Explainable AI (XAI).
    Now also incorporates prediction probabilities if provided.
    """
    explanations = []

    # If predictions available, use their reasons
    if predictions:
        for p in predictions:
            if p.get("detected") or p.get("probability", 0) >= 0.3:
                pct = p.get("percentage", 0)
                reasons_str = ", ".join(p.get("reasons", [])) or "multiple contributing factors"
                explanations.append(
                    f"{p['disease']}: {pct}% probability — {reasons_str}."
                )

    if not explanations:
        explanations.append(
            "Your health indicators appear to be within safe ranges. "
            "Keep maintaining your healthy lifestyle!"
        )

    return explanations
