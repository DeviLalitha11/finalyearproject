import pandas as pd

# Load datasets
heart_df = pd.read_csv("data/heart.csv")
diabetes_df = pd.read_csv("data/diabetes.csv")
thyroid_df = pd.read_csv("data/cleaned_dataset_Thyroid1.csv")

print("Heart Dataset Shape:", heart_df.shape)
print("Diabetes Dataset Shape:", diabetes_df.shape)
print("Thyroid Dataset Shape:", thyroid_df.shape)

print("\nHeart Columns:\n", heart_df.columns)
print("\nDiabetes Columns:\n", diabetes_df.columns)
print("\nThyroid Columns:\n", thyroid_df.columns)
