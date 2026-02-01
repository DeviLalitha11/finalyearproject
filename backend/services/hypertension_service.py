# def analyze_hypertension(data):
#     sys, dia = map(int, data["bloodPressure"].split("/"))

#     if sys < 130 and dia < 85:
#         return []

#     level = "High" if sys >= 140 or dia >= 90 else "Moderate"

#     return [{
#         "disease": "Hypertension",
#         "riskLevel": level,
#         "confidence": 0.9,
#         "reasons": [
#             f"Blood pressure reading {sys}/{dia}"
#         ],
#         "suggestions": [
#             "Reduce salt intake",
#             "Exercise regularly",
#             "Monitor blood pressure"
#         ]
#     }]




# def analyze_hypertension(health_data: dict):
#     """
#     Analyze hypertension risk based on blood pressure readings.
    
#     Hypertension Classification (American Heart Association):
#     - Normal: Systolic < 120 AND Diastolic < 80
#     - Elevated: Systolic 120-129 AND Diastolic < 80
#     - Stage 1: Systolic 130-139 OR Diastolic 80-89
#     - Stage 2: Systolic >= 140 OR Diastolic >= 90
#     """
    
#     bp = health_data.get("bloodPressure")
    
#     if not bp or "/" not in str(bp):
#         return False
    
#     try:
#         parts = str(bp).split("/")
#         systolic = int(parts[0])
#         diastolic = int(parts[1])
        
#         # Stage 2 Hypertension (definite risk)
#         if systolic >= 140 or diastolic >= 90:
#             return True
        
#         # Stage 1 Hypertension
#         if systolic >= 130 or diastolic >= 80:
#             return True
        
#         return False
        
#     except (ValueError, IndexError):
#         return False




def analyze_hypertension(health_data: dict):
    """
    Analyze hypertension risk based on blood pressure readings.
    
    Hypertension Classification (American Heart Association):
    - Normal: Systolic < 120 AND Diastolic < 80
    - Elevated: Systolic 120-129 AND Diastolic < 80
    - Stage 1: Systolic 130-139 OR Diastolic 80-89
    - Stage 2: Systolic >= 140 OR Diastolic >= 90
    """
    
    bp = health_data.get("bloodPressure")
    
    if not bp or "/" not in str(bp):
        return False
    
    try:
        parts = str(bp).split("/")
        systolic = int(parts[0])
        diastolic = int(parts[1])
        
        # Stage 2 Hypertension (definite risk)
        if systolic >= 140 or diastolic >= 90:
            return True
        
        # Stage 1 Hypertension
        if systolic >= 130 or diastolic >= 80:
            return True
        
        return False
        
    except (ValueError, IndexError):
        return False