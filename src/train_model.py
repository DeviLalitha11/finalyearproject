from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, classification_report
from preprocessing import load_and_preprocess_heart_data

# Load preprocessed data
X_train, X_test, y_train, y_test = load_and_preprocess_heart_data("../data/heart.csv")

# Train model
model = LogisticRegression(max_iter=1000)
model.fit(X_train, y_train)

# Predictions
y_pred = model.predict(X_test)

# Evaluation
print("Accuracy:", accuracy_score(y_test, y_pred))
print("\nClassification Report:\n", classification_report(y_test, y_pred))



from sklearn.ensemble import RandomForestClassifier

# ---------------- RANDOM FOREST MODEL ---------------- #

rf_model = RandomForestClassifier(
    n_estimators=100,
    random_state=42
)

rf_model.fit(X_train, y_train)

rf_pred = rf_model.predict(X_test)

print("\nRandom Forest Accuracy:", accuracy_score(y_test, rf_pred))
print("\nRandom Forest Classification Report:\n",
      classification_report(y_test, rf_pred))



import pickle

# Save the trained Random Forest model
with open("../backend/models/heart_model.pkl", "wb") as f:
    pickle.dump(rf_model, f)

print("Heart disease model saved successfully!")
