# from flask import Flask, request, jsonify
# import pickle
# import numpy as np

# app = Flask(__name__)

# # Load heart disease model
# with open("models/heart_model.pkl", "rb") as f:
#     heart_model = pickle.load(f)
#     diabetes_model = pickle.load(open("models/diabetes_model.pkl", "rb"))
#     kidney_model = pickle.load(open("models/kidney_model.pkl", "rb"))
#     thyroid_model = pickle.load(open("models/thyroid_model.pkl", "rb"))


# @app.route("/", methods=["GET"])
# def home():
#     return "AI Healthcare Backend is running"

# @app.route("/predict/heart", methods=["POST"])
# def predict_heart():
#     data = request.json
#     features = np.array(data["features"]).reshape(1, -1)

#     prediction = heart_model.predict(features)[0]

#     result = "High Risk" if prediction == 1 else "Low Risk"

#     return jsonify({
#         "disease": "Heart Disease",
#         "prediction": int(prediction),
#         "result": result
#     })

# @app.route("/predict/diabetes", methods=["POST"])
# def predict_diabetes():
#     data = request.json
#     features = np.array(data["features"]).reshape(1, -1)
#     pred = diabetes_model.predict(features)[0]
#     return jsonify({"disease": "Diabetes", "result": "High Risk" if pred == 1 else "Low Risk"})

# @app.route("/predict/kidney", methods=["POST"])
# def predict_kidney():
#     data = request.json
#     features = np.array(data["features"]).reshape(1, -1)
#     pred = kidney_model.predict(features)[0]
#     return jsonify({"disease": "Kidney Disease", "result": "High Risk" if pred == 1 else "Low Risk"})

# @app.route("/predict/thyroid", methods=["POST"])
# def predict_thyroid():
#     data = request.json
#     features = np.array(data["features"]).reshape(1, -1)
#     pred = thyroid_model.predict(features)[0]
#     return jsonify({"disease": "Thyroid Disease", "result": "High Risk" if pred == 1 else "Low Risk"})

# if __name__ == "__main__":
#     app.run(debug=True)
# from fastapi import FastAPI
# from pydantic import BaseModel
# import pickle

# app = FastAPI()

# # Load the model
# with open("model.pkl", "rb") as f:
#     model = pickle.load(f)

# class InputData(BaseModel):
#     features: list[float]

# @app.post("/predict")
# def predict(data: InputData):
#     prediction = model.predict([data.features])
#     return {"result": int(prediction[0])}

from fastapi import FastAPI
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
import pickle
import numpy as np

app = FastAPI(title="AI Healthcare Backend")

# Allow requests from Flutter / browser
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Change "*" to your frontend URL in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load models
with open("models/heart_model.pkl", "rb") as f:
    heart_model = pickle.load(f)

with open("models/diabetes_model.pkl", "rb") as f:
    diabetes_model = pickle.load(f)

with open("models/kidney_model.pkl", "rb") as f:
    kidney_model = pickle.load(f)

with open("models/thyroid_model.pkl", "rb") as f:
    thyroid_model = pickle.load(f)


class InputData(BaseModel):
    features: list[float]


@app.get("/")
def home():
    return {"message": "AI Healthcare Backend is running"}


@app.post("/predict/heart")
def predict_heart(data: InputData):
    features = np.array(data.features).reshape(1, -1)
    prediction = heart_model.predict(features)[0]
    result = "High Risk" if prediction == 1 else "Low Risk"
    return {"disease": "Heart Disease", "prediction": int(prediction), "result": result}


@app.post("/predict/diabetes")
def predict_diabetes(data: InputData):
    features = np.array(data.features).reshape(1, -1)
    prediction = diabetes_model.predict(features)[0]
    result = "High Risk" if prediction == 1 else "Low Risk"
    return {"disease": "Diabetes", "prediction": int(prediction), "result": result}


@app.post("/predict/kidney")
def predict_kidney(data: InputData):
    features = np.array(data.features).reshape(1, -1)
    prediction = kidney_model.predict(features)[0]
    result = "High Risk" if prediction == 1 else "Low Risk"
    return {"disease": "Kidney Disease", "prediction": int(prediction), "result": result}


@app.post("/predict/thyroid")
def predict_thyroid(data: InputData):
    features = np.array(data.features).reshape(1, -1)
    prediction = thyroid_model.predict(features)[0]
    result = "High Risk" if prediction == 1 else "Low Risk"
    return {"disease": "Thyroid Disease", "prediction": int(prediction), "result": result}
