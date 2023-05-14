
import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import imblearn
from imblearn.over_sampling import SMOTE
from collections import Counter

from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.pipeline import make_pipeline
from sklearn.model_selection import train_test_split

from sklearn.neighbors import  KNeighborsClassifier

from sklearn.metrics import accuracy_score, confusion_matrix
import pickle

import warnings
warnings.filterwarnings("ignore")

# %matplotlib inline

DATA_PATH = "Fertilizer Prediction.csv"

data = pd.read_csv(DATA_PATH)
data.head()

data["Fertilizer Name"].unique()

data.shape

data["Soil Type"].unique()

data["Crop Type"].unique()

data.columns

labels = data["Fertilizer Name"].unique()
counts = list(data["Fertilizer Name"].value_counts())

continuous_data_cols = ["Temparature", "Humidity ", "Moisture", "Nitrogen", "Phosphorous"]
categorical_data_cols = ["Soil Type", "Crop Type"]

plt.figure(figsize=(21,17))
sns.pairplot(data[continuous_data_cols + ["Fertilizer Name"]], hue = "Fertilizer Name")
#plt.show()

plt.figure(figsize = (13,11))
sns.heatmap(data[continuous_data_cols].corr(), center = 0, annot = True)
#plt.show()

soil_type_label_encoder = LabelEncoder()
data["Soil Type"] = soil_type_label_encoder.fit_transform(data["Soil Type"])

crop_type_label_encoder = LabelEncoder()
data["Crop Type"] = crop_type_label_encoder.fit_transform(data["Crop Type"])

croptype_dict = {}
for i in range(len(data["Crop Type"].unique())):
    croptype_dict[i] = crop_type_label_encoder.inverse_transform([i])[0]
#print(croptype_dict)

soiltype_dict = {}
for i in range(len(data["Soil Type"].unique())):
    soiltype_dict[i] = soil_type_label_encoder.inverse_transform([i])[0]
#print(soiltype_dict)

fertname_label_encoder = LabelEncoder()
data["Fertilizer Name"] = fertname_label_encoder.fit_transform(data["Fertilizer Name"])

fertname_dict = {}
for i in range(len(data["Fertilizer Name"].unique())):
    fertname_dict[i] = fertname_label_encoder.inverse_transform([i])[0]
#print(fertname_dict)

data.head()

X = data[data.columns[:-1]]
y = data[data.columns[-1]]

counter = Counter(y)
counter

upsample = SMOTE()
X, y = upsample.fit_resample(X, y)
counter = Counter(y)
#print(counter)

#print(f"Total Data after Upsampling: {len(X)}")

X_train, X_test, y_train, y_test = train_test_split(X.values, y, test_size = 0.2, random_state = 0)
#print(f"Train Data: {X_train.shape}, {y_train.shape}")
#print(f"Train Data: {X_test.shape}, {y_test.shape}")

error_rate = []
for i in range(1, 50):
    pipeline = make_pipeline(StandardScaler(), KNeighborsClassifier(n_neighbors = i))
    pipeline.fit(X_train, y_train)
    predictions = pipeline.predict(X_test)
    accuracy = accuracy_score(y_test, predictions)
    #print(f"Accuracy at k = {i} is {accuracy}")
    error_rate.append(np.mean(predictions != y_test))


#print("Minimum error:-",min(error_rate),"at K =",error_rate.index(min(error_rate))+1)

from sklearn.ensemble import RandomForestClassifier
from sklearn.svm import SVC
import xgboost
from xgboost import XGBClassifier

svm_pipeline = make_pipeline(StandardScaler(), SVC(probability=True))
svm_pipeline.fit(X_train, y_train)

# Accuray On Test Data
predictions = svm_pipeline.predict(X_test)
accuracy = accuracy_score(y_test, predictions)
#print(f"Accuracy on Test Data: {accuracy*100}%")


#print()

# Accuray On Whole Data
predictions = svm_pipeline.predict(X.values)
accuracy = accuracy_score(y, predictions)
print(f"Accuracy on Whole Data: {accuracy*100}%")

rf_pipeline = make_pipeline(StandardScaler(), RandomForestClassifier(random_state = 18))
rf_pipeline.fit(X_train, y_train)

# Accuray On Test Data
predictions = rf_pipeline.predict(X_test)
accuracy = accuracy_score(y_test, predictions)
#print(f"Accuracy on Test Data: {accuracy*100}%")


#print()

# Accuray On Whole Data
predictions = rf_pipeline.predict(X.values)
accuracy = accuracy_score(y, predictions)
#print(f"Accuracy on Whole Data: {accuracy*100}%")

xgb_pipeline = make_pipeline(StandardScaler(), XGBClassifier(random_state = 18))
xgb_pred = xgb_pipeline.fit(X_train, y_train)

# Accuray On Test Data
predictions_xgb = xgb_pred.predict(X_test)
accuracy = accuracy_score(y_test, predictions_xgb)
#print(f"Accuracy on Test Data: {accuracy*100}%")

import pickle

classifiers = {

    "svm": svm_pipeline,
    "rf": rf_pipeline,
    "xgb": xgb_pipeline
}

with open("fertmodel.pkl", "wb") as file:
    pickle.dump(classifiers, file)