from flask import Flask, request, jsonify
import numpy as np
import pickle
import agricom_crop
app = Flask(__name__)

model = pickle.load(open('model.pkl','rb'))

def predictor(Nitrogen, Phosphorus, Potassium, Temperature, Humidity, pH, Rainfall):
    feature = [Nitrogen, Phosphorus, Potassium, Temperature, Humidity, pH, Rainfall]
    feature = np.array(feature).reshape((1, -1))
    pred = agricom_crop.grad.predict(feature)
    # Map the prediction index to the corresponding crop name
    crops = ["apple", "banana", "blackgram", "chickpea", "coconut", "coffee", "cotton",
             "grapes", "jute", "kidneybeans", "lentil", "maize", "mango", "mothbeans",
             "mungbean", "muskmelon", "orange", "papaya", "pigeonpeas", "pomegranate",
             "rice", "watermelon"]
    return crops[int(pred[0])]



@app.route('/predict', methods=['POST'])
def predict():
    # Parse the request data
    data = request.get_json()
    Nitrogen = data['Nitrogen']
    Phosphorus = data['Phosphorus']
    Potassium = data['Potassium']
    Temperature = data['Temperature']
    Humidity = data['Humidity']
    pH = data['pH']
    Rainfall = data['Rainfall']

    # Make the prediction using the predictor function
    crop = predictor(Nitrogen, Phosphorus, Potassium, Temperature, Humidity, pH, Rainfall)

    # Return the prediction result
    return jsonify({'result': crop})


if __name__ == '__main__':
    app.run(host='0.0.0.0',port='5000')
