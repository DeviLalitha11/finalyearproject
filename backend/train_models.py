# train_models.py

import os
import numpy as np
import pandas as pd
import joblib
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier, VotingClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score

MODEL_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "models")
DATA_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "data")
os.makedirs(MODEL_DIR, exist_ok=True)

np.random.seed(42)


# ------------------ SYNTHETIC DATA GENERATORS ------------------
def generate_diabetes_data(n=2000):
    """Generate realistic diabetes dataset."""
    data = []
    for _ in range(n):
        # Positive cases (diabetic)
        if np.random.random() < 0.4:
            glucose = np.random.normal(170, 30)
            bmi = np.random.normal(32, 5)
            age = np.random.randint(35, 75)
            bp = np.random.normal(135, 15)
            outcome = 1
        else:
            glucose = np.random.normal(95, 15)
            bmi = np.random.normal(24, 3)
            age = np.random.randint(20, 60)
            bp = np.random.normal(118, 10)
            outcome = 0
        data.append([max(50, glucose), max(15, bmi), age, max(80, bp), outcome])
    return pd.DataFrame(data, columns=["Glucose", "BMI", "Age", "BP", "Outcome"])


def generate_heart_data(n=2000):
    """Generate realistic heart disease dataset."""
    data = []
    for _ in range(n):
        if np.random.random() < 0.45:
            age = np.random.randint(50, 80)
            bp = np.random.normal(150, 20)
            chol = np.random.normal(260, 40)
            hr = np.random.normal(110, 15)
            target = 1
        else:
            age = np.random.randint(25, 60)
            bp = np.random.normal(120, 10)
            chol = np.random.normal(190, 30)
            hr = np.random.normal(75, 10)
            target = 0
        data.append([age, max(80, bp), max(120, chol), max(50, hr), target])
    return pd.DataFrame(data, columns=["age", "trestbps", "chol", "thalach", "target"])


def generate_kidney_data(n=2000):
    """Generate kidney disease dataset."""
    data = []
    for _ in range(n):
        if np.random.random() < 0.4:
            bp = np.random.normal(150, 15)
            sugar = np.random.normal(160, 30)
            bmi = np.random.normal(29, 4)
            age = np.random.randint(45, 75)
            classification = 1
        else:
            bp = np.random.normal(118, 10)
            sugar = np.random.normal(95, 15)
            bmi = np.random.normal(23, 3)
            age = np.random.randint(20, 55)
            classification = 0
        data.append([max(80, bp), max(50, sugar), max(15, bmi), age, classification])
    return pd.DataFrame(data, columns=["bp", "sugar", "bmi", "age", "classification"])


def generate_thyroid_data(n=2000):
    """Generate thyroid dataset."""
    data = []
    for _ in range(n):
        if np.random.random() < 0.35:
            age = np.random.randint(35, 70)
            bmi = np.random.choice([np.random.normal(30, 4), np.random.normal(17, 2)])
            hr = np.random.choice([np.random.normal(55, 8), np.random.normal(105, 10)])
            gender = np.random.choice([0, 1], p=[0.3, 0.7])
            binary_class = 1
        else:
            age = np.random.randint(20, 60)
            bmi = np.random.normal(23, 3)
            hr = np.random.normal(75, 10)
            gender = np.random.choice([0, 1])
            binary_class = 0
        data.append([age, max(15, bmi), max(40, hr), gender, binary_class])
    return pd.DataFrame(data, columns=["age", "bmi", "hr", "gender", "binaryClass"])


def generate_hypertension_data(n=2000):
    """Generate hypertension dataset."""
    data = []
    for _ in range(n):
        if np.random.random() < 0.45:
            sys_bp = np.random.normal(150, 15)
            dia_bp = np.random.normal(95, 8)
            age = np.random.randint(40, 75)
            bmi = np.random.normal(29, 4)
            target = 1
        else:
            sys_bp = np.random.normal(118, 8)
            dia_bp = np.random.normal(76, 6)
            age = np.random.randint(20, 55)
            bmi = np.random.normal(23, 3)
            target = 0
        data.append([max(90, sys_bp), max(60, dia_bp), age, max(15, bmi), target])
    return pd.DataFrame(data, columns=["systolic", "diastolic", "age", "bmi", "target"])


# ------------------ MODEL BUILDER ------------------
def build_ensemble_model():
    """Voting classifier with RF + GB + LR for better accuracy."""
    rf = RandomForestClassifier(n_estimators=200, max_depth=10, random_state=42, n_jobs=-1)
    gb = GradientBoostingClassifier(n_estimators=150, max_depth=5, learning_rate=0.1, random_state=42)
    lr = LogisticRegression(max_iter=1000, random_state=42)

    ensemble = VotingClassifier(
        estimators=[('rf', rf), ('gb', gb), ('lr', lr)],
        voting='soft'
    )

    pipeline = Pipeline([
        ('scaler', StandardScaler()),
        ('clf', ensemble)
    ])
    return pipeline


def load_or_generate(name, generator_func, real_path=None):
    """Load real dataset if available; else generate synthetic."""
    if real_path and os.path.exists(real_path):
        try:
            df = pd.read_csv(real_path).dropna()
            print(f"✅ Loaded real dataset for {name}")
            return df
        except Exception as e:
            print(f"⚠️ Could not load {real_path}: {e}. Using synthetic data.")
    print(f"📊 Generating synthetic data for {name}")
    return generator_func()


# ------------------ TRAINING FUNCTIONS ------------------
def train_diabetes():
    print("\n🔵 Training Diabetes model...")
    df = load_or_generate("diabetes", generate_diabetes_data, os.path.join(DATA_DIR, "diabetes.csv"))
    
    # Ensure required columns
    required = ["Glucose", "BMI", "Age", "BP"]
    for col in required:
        if col not in df.columns:
            df = generate_diabetes_data()
            break
    
    X = df[["Glucose", "BMI", "Age", "BP"]]
    y = df["Outcome"]
    
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    model = build_ensemble_model()
    model.fit(X_train, y_train)
    acc = accuracy_score(y_test, model.predict(X_test))
    print(f"   Accuracy: {acc:.4f}")
    joblib.dump(model, os.path.join(MODEL_DIR, "diabetes.pkl"))


def train_heart():
    print("\n❤️ Training Heart Disease model...")
    df = load_or_generate("heart", generate_heart_data, os.path.join(DATA_DIR, "heart.csv"))
    
    required = ["age", "trestbps", "chol", "thalach"]
    for col in required:
        if col not in df.columns:
            df = generate_heart_data()
            break

    X = df[["age", "trestbps", "chol", "thalach"]]
    y = df["target"]

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    model = build_ensemble_model()
    model.fit(X_train, y_train)
    acc = accuracy_score(y_test, model.predict(X_test))
    print(f"   Accuracy: {acc:.4f}")
    joblib.dump(model, os.path.join(MODEL_DIR, "heart.pkl"))


def train_kidney():
    print("\n🫘 Training Kidney Disease model...")
    df = generate_kidney_data()  # Use synthetic for reliability
    X = df[["bp", "sugar", "bmi", "age"]]
    y = df["classification"]

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    model = build_ensemble_model()
    model.fit(X_train, y_train)
    acc = accuracy_score(y_test, model.predict(X_test))
    print(f"   Accuracy: {acc:.4f}")
    joblib.dump(model, os.path.join(MODEL_DIR, "kidney.pkl"))


def train_thyroid():
    print("\n🦋 Training Thyroid model...")
    df = generate_thyroid_data()
    X = df[["age", "bmi", "hr", "gender"]]
    y = df["binaryClass"]

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    model = build_ensemble_model()
    model.fit(X_train, y_train)
    acc = accuracy_score(y_test, model.predict(X_test))
    print(f"   Accuracy: {acc:.4f}")
    joblib.dump(model, os.path.join(MODEL_DIR, "thyroid.pkl"))


def train_hypertension():
    print("\n🩸 Training Hypertension model...")
    df = generate_hypertension_data()
    X = df[["systolic", "diastolic", "age", "bmi"]]
    y = df["target"]

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    model = build_ensemble_model()
    model.fit(X_train, y_train)
    acc = accuracy_score(y_test, model.predict(X_test))
    print(f"   Accuracy: {acc:.4f}")
    joblib.dump(model, os.path.join(MODEL_DIR, "hypertension.pkl"))


def train_all_models():
    print("=" * 60)
    print("🚀 Training All Healthcare ML Models")
    print("=" * 60)
    train_diabetes()
    train_heart()
    train_kidney()
    train_thyroid()
    train_hypertension()
    print("\n" + "=" * 60)
    print("✅ All models trained and saved successfully!")
    print("=" * 60)


if __name__ == "__main__":
    train_all_models()
