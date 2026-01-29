import pandas as pd
import joblib
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier

# ---------- DIABETES ----------
df = pd.read_csv("data/diabetes.csv")
X = df[["Glucose", "BMI"]]
y = df["Outcome"]

model = RandomForestClassifier()
model.fit(X, y)
joblib.dump(model, "models/diabetes.pkl")

# ---------- HEART ----------
df = pd.read_csv("data/heart.csv")
X = df[["age", "trestbps", "chol", "thalach"]]
y = df["target"]

model = RandomForestClassifier()
model.fit(X, y)
joblib.dump(model, "models/heart.pkl")

# ---------- KIDNEY ----------
df = pd.read_csv("data/kidney.csv")
df = df.dropna()
X = df[["bp", "sg", "al", "su"]]
y = df["classification"]

model = RandomForestClassifier()
model.fit(X, y)
joblib.dump(model, "models/kidney.pkl")

# ---------- THYROID ----------
df = pd.read_csv("data/thyroid.csv")
X = df[["age", "on thyroxine", "query hypothyroid"]]
y = df["binaryClass"]

model = RandomForestClassifier()
model.fit(X, y)
joblib.dump(model, "models/thyroid.pkl")

print("✅ All models trained successfully")
