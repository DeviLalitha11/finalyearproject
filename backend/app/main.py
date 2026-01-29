# from fastapi import FastAPI
# from pydantic import BaseModel
# from services.analysis_service import run_full_analysis

# app = FastAPI()

# class HealthInput(BaseModel):
#     heartRate: int
#     bloodPressure: str
#     bloodSugar: int
#     bmi: float
#     temperature: float
#     oxygen: int
#     symptoms: list[str]

# @app.post("/analyze")
# def analyze(data: HealthInput):
#     try:
#         return run_full_analysis(data.dict())
#     except Exception as e:
#         import traceback
#         traceback.print_exc()
#         return {
#             "status": "error",
#             "message": str(e)
#         }



from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from services.analysis_service import run_full_analysis
from pydantic import BaseModel
from typing import List

app = FastAPI(title="AI Healthcare Backend")

# ------------------ CORS FIX ------------------
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # allow all (for development)
    allow_credentials=True,
    allow_methods=["*"],  # GET, POST, OPTIONS, etc.
    allow_headers=["*"],
)
# ----------------------------------------------

class HealthInput(BaseModel):
    heartRate: int
    bloodPressure: str
    bloodSugar: float
    bmi: float
    temperature: float
    oxygen: int
    symptoms: List[str] = []

@app.get("/")
def root():
    return {"message": "AI Healthcare Backend is running"}

@app.post("/analyze")
def analyze_health(data: HealthInput):
    try:
        return run_full_analysis(data.dict())
    except Exception as e:
        return {
            "status": "error",
            "message": str(e)
        }
