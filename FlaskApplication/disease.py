from flask import Flask, request, jsonify
import cv2
import pickle

app = Flask(__name__)
# model = pickle.load(open('agri_disease.pkl','rb'))
from keras.models import load_model
from PIL import Image
import numpy as np

model = load_model('model2.h5')

@app.route('/upload', methods=["POST"])
def upload():
    if request.method == "POST":
        imagefile = request.files['image']

        filename = imagefile.filename
        print("\nReceived image File name : " + filename)
        imagefile.save("./uploadedimages/" + filename)
        # img = Image.open('uploadedimages/' + filename)
        #
        # img = img.resize((128, 128))
        img = cv2.imread('uploadedimages/' + filename)
        img = cv2.resize(img.copy(), (128, 128), interpolation=cv2.INTER_AREA)

        x = np.array(img, 'float32')
        x = np.expand_dims(x, axis=0)
        x /= 255.0
        # x = np.array(img)
        # x = np.expand_dims(x, axis=0)
        # x = x.astype('float32') / 255.0  # normalize pixel values and change the data type to float32
        # x = x.astype('uint8')  # convert back to uint8 for further processing

        disease_class = ['Pepper__bell___Bacterial_spot', 'Pepper__bell___healthy', 'Potato___Early_blight',
                         'Potato___Late_blight', 'Potato___healthy', 'Tomato_Bacterial_spot', 'Tomato_Early_blight',
                         'Tomato_Late_blight', 'Tomato_Leaf_Mold', 'Tomato_Septoria_leaf_spot',
                         'Tomato_Spider_mites_Two_spotted_spider_mite', 'Tomato__Target_Spot',
                         'Tomato__Tomato_YellowLeaf__Curl_Virus', 'Tomato__Tomato_mosaic_virus', 'Tomato_healthy']

        prediction = model.predict(x)
        predicted_class_index = np.argmax(prediction)
        predicted_class = disease_class[predicted_class_index]
        print(f"The predicted class is {predicted_class}")

        return jsonify({
            "message": predicted_class,
        })


if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=9000)
