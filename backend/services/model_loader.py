# services/model_loader.py

import os
import joblib

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MODEL_DIR = os.path.join(BASE_DIR, "models")

os.makedirs(MODEL_DIR, exist_ok=True)

_model_cache = {}

def load_model(name: str):
    """Lazy loading with caching. Trains model if missing."""
    if name in _model_cache:
        return _model_cache[name]

    path = os.path.join(MODEL_DIR, f"{name}.pkl")

    if not os.path.exists(path):
        print(f"⚠️ Model {name} not found. Training new model...")
        from train_models import train_all_models
        train_all_models()

    try:
        model = joblib.load(path)
        _model_cache[name] = model
        return model
    except Exception as e:
        print(f"❌ Error loading {name}: {e}")
        return None


def get_model_dir():
    return MODEL_DIR
