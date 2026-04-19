# app/main.py

import os
import sys

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from fastapi import FastAPI
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from typing import List, Optional

from services.analysis_service import run_full_analysis

app = FastAPI(
    title="AI Healthcare Backend",
    description="AI Based Healthcare Data Analysis for Early Disease Prediction",
    version="2.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class HealthInput(BaseModel):
    heartRate: int = Field(..., ge=30, le=220)
    bloodPressure: str
    bloodSugar: float = Field(..., ge=40, le=600)
    bmi: float = Field(..., ge=10, le=60)
    temperature: float = Field(..., ge=90, le=110)
    oxygen: int = Field(..., ge=50, le=100)
    symptoms: List[str] = Field(default_factory=list)
    age: Optional[int] = Field(default=35, ge=1, le=120)
    gender: Optional[str] = Field(default="male")
    cholesterol: Optional[float] = Field(default=200.0)


@app.get("/")
def root():
    return {
        "message": "AI Healthcare Backend is running",
        "version": "2.0.0",
        "status": "online"
    }


@app.get("/health")
def health_check():
    return {"status": "healthy"}


@app.post("/analyze")
def analyze_health(data: HealthInput):
    try:
        result = run_full_analysis(data.dict())
        # ✅ Use JSONResponse to bypass FastAPI's auto-encoder
        return JSONResponse(content=result)
    except Exception as e:
        import traceback
        traceback.print_exc()
        return JSONResponse(
            status_code=500,
            content={
                "status": "error",
                "message": str(e),
                "riskLevel": "Low",
                "diseases": [],
                "predictions": [],
                "explanations": [],
                "suggestions": []
            }
        )


if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run("app.main:app", host="0.0.0.0", port=port, reload=False)
