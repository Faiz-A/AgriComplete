import pickle

import numpy as np
from flask import Flask, request, jsonify
import fertilizer
app = Flask(__name__)

model = pickle.load(open('fertmodel.pkl','rb'))

def predictor(Temperature, Humidity, Moisture, SoilType, CropType, Nitrogen, Potassium, Phosphorus):
    feature = [Temperature, Humidity, Moisture, SoilType, CropType, Nitrogen, Potassium, Phosphorus]
    feature= np.array(feature).reshape((1, -1))
    pred= fertilizer.xgb_pred.predict(feature)
    FertData={0: '10-26-26', 1: '14-35-14', 2: '17-17-17', 3: '20-20', 4: '28-28', 5: 'DAP', 6: 'Urea'}
    FertPred = FertData[pred[0]]
    return FertPred

@app.route('/fertpredict', methods=['POST'])
def fertpredict():
    # Parse the request data
    data = request.get_json()
    Temperature = data['Temperature']
    Humidity = data['Humidity']
    Moisture = data['Moisture']
    SoilType = data['Soil Type']
    CropType = data['Crop Type']
    Nitrogen = data['Nitrogen']
    Phosphorus = data['Phosphorus']
    Potassium = data['Potassium']

    CropData = {'Barley': 0, 'Cotton': 1, 'Ground Nuts': 2, 'Maize': 3, 'Millets': 4, 'Oil seeds': 5, 'Paddy': 6,
                'Pulses': 7, 'Sugarcane': 8, 'Tobacco': 9, 'Wheat': 10}
    SoilData = {'Black': 0, 'Clayey': 1, 'Loamy': 2, 'Red': 3, 'Sandy': 4}

    _SoilType = SoilData[SoilType]
    _CropType = CropData[CropType]


    # Make the prediction using the predictor function
    fert = predictor(Temperature, Humidity, Moisture, _SoilType, _CropType, Nitrogen, Phosphorus, Potassium)

    # Return the prediction result
    return jsonify({'result': fert})


if __name__ == '__main__':
    app.run(host='0.0.0.0',port='5001')
