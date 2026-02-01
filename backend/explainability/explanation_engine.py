# def generate_explanations(health_data: dict, risks: list):
#     """
#     Generate human-readable explanations for detected risks.
#     This is rule-based XAI (Explainable AI).
#     """

#     explanations = []

#     sugar = health_data.get("bloodSugar")
#     bmi = health_data.get("bmi")
#     bp = health_data.get("bloodPressure")
#     oxygen = health_data.get("oxygen")
#     heart_rate = health_data.get("heartRate")

#     if "Diabetes" in risks:
#         reasons = []
#         if sugar and sugar > 140:
#             reasons.append("high blood sugar levels")
#         if bmi and bmi > 25:
#             reasons.append("BMI above the normal range")
#         explanations.append(
#             "Diabetes risk detected mainly due to " + ", ".join(reasons)
#         )

#     if "Heart Disease" in risks:
#         reasons = []
#         if heart_rate and heart_rate > 100:
#             reasons.append("elevated heart rate")
#         if bp:
#             systolic = int(bp.split("/")[0])
#             if systolic > 140:
#                 reasons.append("high blood pressure")
#         explanations.append(
#             "Heart disease risk detected mainly due to " + ", ".join(reasons)
#         )

#     if "Kidney Disease" in risks:
#         explanations.append(
#             "Kidney risk detected due to abnormal blood pressure or sugar levels"
#         )

#     if "Thyroid Disease" in risks:
#         explanations.append(
#             "Thyroid risk detected based on age and symptom patterns"
#         )

#     if not explanations:
#         explanations.append(
#             "No major health risks detected based on your current data."
#         )

#     return explanations





def generate_explanations(health_data: dict, risks: list):
    """
    Generate human-readable explanations for detected risks.
    This is rule-based XAI (Explainable AI).
    """

    explanations = []

    sugar = health_data.get("bloodSugar")
    bmi = health_data.get("bmi")
    bp = health_data.get("bloodPressure")
    oxygen = health_data.get("oxygen")
    heart_rate = health_data.get("heartRate")

    # Extract systolic and diastolic if bp is available
    systolic = None
    diastolic = None
    if bp and "/" in str(bp):
        try:
            parts = str(bp).split("/")
            systolic = int(parts[0])
            diastolic = int(parts[1])
        except (ValueError, IndexError):
            pass

    # ---------------- DIABETES ----------------
    if "Diabetes" in risks:
        reasons = []
        if sugar and sugar > 140:
            reasons.append("high blood sugar levels")
        if bmi and bmi > 25:
            reasons.append("BMI above the normal range")
        
        if reasons:
            explanations.append(
                f"Diabetes risk detected mainly due to {', '.join(reasons)}."
            )
        else:
            explanations.append(
                "Diabetes risk detected based on your health profile."
            )

    # ---------------- HEART DISEASE ----------------
    if "Heart Disease" in risks:
        reasons = []
        if heart_rate and heart_rate > 100:
            reasons.append("elevated heart rate")
        if systolic and systolic > 140:
            reasons.append("high blood pressure")
        if heart_rate and heart_rate < 60:
            reasons.append("low heart rate")
        
        if reasons:
            explanations.append(
                f"Heart disease risk detected mainly due to {', '.join(reasons)}."
            )
        else:
            explanations.append(
                "Heart disease risk detected based on your cardiovascular health indicators."
            )

    # ---------------- HYPERTENSION ----------------
    if "Hypertension" in risks:
        reasons = []
        if systolic and systolic > 140:
            reasons.append(f"systolic pressure of {systolic} mmHg")
        if diastolic and diastolic > 90:
            reasons.append(f"diastolic pressure of {diastolic} mmHg")
        
        if reasons:
            explanations.append(
                f"Hypertension detected due to {', '.join(reasons)}."
            )
        else:
            explanations.append(
                "Hypertension risk detected based on your blood pressure readings."
            )

    # ---------------- KIDNEY DISEASE ----------------
    if "Kidney Disease" in risks:
        reasons = []
        if systolic and systolic > 140:
            reasons.append("high blood pressure")
        if sugar and sugar > 140:
            reasons.append("elevated blood sugar")
        
        if reasons:
            explanations.append(
                f"Kidney risk detected due to {', '.join(reasons)}."
            )
        else:
            explanations.append(
                "Kidney risk detected due to abnormal blood pressure or sugar levels."
            )

    # ---------------- THYROID DISEASE ----------------
    if "Thyroid Disease" in risks or "Thyroid Disorder" in risks:
        explanations.append(
            "Thyroid risk detected based on age and symptom patterns."
        )

    # ---------------- NO RISKS ----------------
    if not explanations:
        explanations.append(
            "No major health risks detected based on your current data. Keep maintaining a healthy lifestyle!"
        )

    return explanations