import joblib
import os

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MODEL_DIR = os.path.join(BASE_DIR, "models")

def load_model(name: str):
    path = os.path.join(MODEL_DIR, f"{name}.pkl")
    if not os.path.exists(path):
        raise FileNotFoundError(f"Model not found: {path}")
    return joblib.load(path)

# Lazy-loaded models
diabetes_model = load_model("diabetes")
heart_model = load_model("heart")
kidney_model = load_model("kidney")
thyroid_model = load_model("thyroid")
