
import numpy as np
import pandas as pd


# Commented out IPython magic to ensure Python compatibility.
import warnings
warnings.simplefilter(action='ignore', category=FutureWarning)
warnings.simplefilter(action='ignore', category=UserWarning)
import seaborn as sns
import matplotlib.pyplot as plt
# %matplotlib inline

df=pd.read_csv('Crop_recommendation.csv')
df.head()

df.describe()

c=df.label.astype('category')
targets = dict(enumerate(c.cat.categories))
df['target']=c.cat.codes

y=df.target
X=df[['N','P','K','temperature','humidity','ph','rainfall']]



from sklearn.model_selection import train_test_split
from sklearn.preprocessing import MinMaxScaler

X_train, X_test, y_train, y_test = train_test_split(X, y,random_state=1)

scaler = MinMaxScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

from sklearn.neighbors import KNeighborsClassifier
knn = KNeighborsClassifier()
knn.fit(X_train_scaled, y_train)
knn.score(X_test_scaled, y_test)

from sklearn.metrics import confusion_matrix
mat=confusion_matrix(y_test,knn.predict(X_test_scaled))
df_cm = pd.DataFrame(mat, list(targets.values()), list(targets.values()))

k_range = range(1,11)
scores = []

for k in k_range:
    knn = KNeighborsClassifier(n_neighbors = k)
    knn.fit(X_train_scaled, y_train)
    scores.append(knn.score(X_test_scaled, y_test))


plt.scatter(k_range, scores)
plt.vlines(k_range,0, scores, linestyle="dashed")
plt.ylim(0.96,0.99)
plt.xticks([i for i in range(1,11)]);

from sklearn.svm import SVC

svc_linear = SVC(kernel = 'linear').fit(X_train_scaled, y_train)
print("Linear Kernel Accuracy: ",svc_linear.score(X_test_scaled,y_test))

svc_poly = SVC(kernel = 'rbf').fit(X_train_scaled, y_train)
print("Rbf Kernel Accuracy: ", svc_poly.score(X_test_scaled,y_test))

svc_poly = SVC(kernel = 'poly').fit(X_train_scaled, y_train)
print("Poly Kernel Accuracy: ", svc_poly.score(X_test_scaled,y_test))

from sklearn.metrics import accuracy_score
from sklearn.model_selection import GridSearchCV

parameters = {'C': np.logspace(-3, 2, 6).tolist(), 'gamma': np.logspace(-3, 2, 6).tolist()}
model = GridSearchCV(estimator = SVC(kernel="linear"), param_grid=parameters, n_jobs=-1, cv=4)
model.fit(X_train, y_train)

print(model.best_score_ )
print(model.best_params_ )

from sklearn.tree import DecisionTreeClassifier

clf = DecisionTreeClassifier(random_state=42).fit(X_train, y_train)
clf.score(X_test,y_test)

#clf is a claffifier
c_features = len(X_train.columns)
plt.barh(range(c_features), clf.feature_importances_)

plt.yticks(np.arange(c_features), X_train.columns)


from sklearn.ensemble import RandomForestClassifier
clf = RandomForestClassifier(max_depth=4,n_estimators=100,random_state=42).fit(X_train, y_train)

print('RF Accuracy on training set: {:.2f}'.format(clf.score(X_train, y_train)))
print('RF Accuracy on test set: {:.2f}'.format(clf.score(X_test, y_test)))

from yellowbrick.classifier import ClassificationReport
classes=list(targets.values())


from sklearn.ensemble import GradientBoostingClassifier
grad = GradientBoostingClassifier().fit(X_train, y_train)
print('Gradient Boosting accuracy : {}'.format(grad.score(X_test,y_test)))

N = input("Enter Nitrogen Content:")
P = input("Enter Phosphorus Content:")
K = input("Enter Potassium Content:")
Temp = input("Enter Temperature:")
Humid = input("Enter Humidity:")
pH = input("Enter pH of soil:")
Rain = input("Enter Rainfall in mm:")

def predictor(Nitrogen, Phosphorus, Potassium, Temperature, Humidity, pH, Rainfall):
    feature = [Nitrogen, Phosphorus, Potassium, Temperature, Humidity, pH, Rainfall]
    feature= np.array(feature).reshape((1, -1))
    pred=grad.predict(feature)
    #print(tagets)
    if int(pred[0]) == 0:
        res="apple"
        return res
    elif int(pred[0]) == 1.0:
        res="banana"
        return res
    elif int(pred[0]) == 2.0:
        res="blackgram"
        return res
    elif int(pred[0]) == 3.0:
        res="chickpea"
        return res
    elif int(pred[0]) == 4.0:
        res="coconut"
        return res
    elif int(pred[0]) == 5.0:
        res="coffee"
        return res
    elif int(pred[0]) == 6.0:
        res="cotton"
        return res
    elif int(pred[0]) == 7.0:
        res="grapes"
        return res
    elif int(pred[0]) == 8.0:
        res="jute"
        return res
    elif int(pred[0]) == 9.0:
        res="kidneybeans"
        return res
    elif int(pred[0]) == 10.0:
        res="lentil"
        return res
    elif int(pred[0]) == 11.0:
        res="maize"
        return res
    elif int(pred[0]) == 12.0:
        res="mango"
        return res
    elif int(pred[0]) == 13.0:
        res="mothbeans"
        return res
    elif int(pred[0]) == 14.0:
        res="mungbean"
        return res
    elif int(pred[0]) == 15.0:
        res="muskmelon"
        return res
    elif int(pred[0]) == 16.0:
        res="orange"
        return res
    elif int(pred[0]) == 17.0:
        res="papaya"
        return res
    elif int(pred[0]) == 18.0:
        res="pigeonpeas"
        return res
    elif int(pred[0]) == 19.0:
        res="pomegranate"
        return res
    elif int(pred[0]) == 20.0:
        res="rice"
        return res
    elif int(pred[0]) == 21.0:
        res="watermelon"
        return res








print(predictor(N,P,K,Temp,Humid,pH,Rain))

def predictor(Nitrogen, Phosphorus, Potassium, Temperature, Humidity, pH, Rainfall):
    feature = [Nitrogen, Phosphorus, Potassium, Temperature, Humidity, pH, Rainfall]
    feature= np.array(feature).reshape((1, -1))
    pred=grad.predict(feature)
    #print(tagets)
    if int(pred[0]) == 0:
        res="apple"
        return res
    elif int(pred[0]) == 1.0:
        res="banana"
        return res
    elif int(pred[0]) == 2.0:
        res="blackgram"
        return res
    elif int(pred[0]) == 3.0:
        res="chickpea"
        return res
    elif int(pred[0]) == 4.0:
        res="coconut"
        return res
    elif int(pred[0]) == 5.0:
        res="coffee"
        return res
    elif int(pred[0]) == 6.0:
        res="cotton"
        return res
    elif int(pred[0]) == 7.0:
        res="grapes"
        return res
    elif int(pred[0]) == 8.0:
        res="jute"
        return res
    elif int(pred[0]) == 9.0:
        res="kidneybeans"
        return res
    elif int(pred[0]) == 10.0:
        res="lentil"
        return res
    elif int(pred[0]) == 11.0:
        res="maize"
        return res
    elif int(pred[0]) == 12.0:
        res="mango"
        return res
    elif int(pred[0]) == 13.0:
        res="mothbeans"
        return res
    elif int(pred[0]) == 14.0:
        res="mungbean"
        return res
    elif int(pred[0]) == 15.0:
        res="muskmelon"
        return res
    elif int(pred[0]) == 16.0:
        res="orange"
        return res
    elif int(pred[0]) == 17.0:
        res="papaya"
        return res
    elif int(pred[0]) == 18.0:
        res="pigeonpeas"
        return res
    elif int(pred[0]) == 19.0:
        res="pomegranate"
        return res
    elif int(pred[0]) == 20.0:
        res="rice"
        return res
    elif int(pred[0]) == 21.0:
        res="watermelon"
        return res







