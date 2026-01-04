from fastapi import FastAPI
import pickle

app = FastAPI()

model = pickle.load(open("model.pkl", "rb"))

@app.post("/predict")
def predict(data: dict):
    features = data["features"]
    prediction = model.predict([features])
    return {"result": int(prediction[0])}
