import pandas as pd
import pickle
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import StandardScaler

# Load dataset
df = pd.read_csv("../data/new_model.csv")

# Assume last column is target
X = df.iloc[:, :-1]
y = df.iloc[:, -1]

# Scale
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# Split
X_train, X_test, y_train, y_test = train_test_split(
    X_scaled, y, test_size=0.2, random_state=42
)

# Train
model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train, y_train)

# Save
with open("../backend/models/kidney_model.pkl", "wb") as f:
    pickle.dump(model, f)

print("Kidney model saved successfully")
