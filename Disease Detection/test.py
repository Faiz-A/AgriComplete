import pickle
from keras.models import load_model
from PIL import Image
import numpy as np
import cv2

model = load_model('model2.h5')

#img = Image.open('PlantVillage/Tomato_Late_blight/0ab391bd-e5ba-479c-919b-3aa9a94f66db___GHLB2 Leaf 8934.JPG')
#img = img.resize((128, 128))
img=cv2.imread('BBS_Test.jpg')
img=cv2.resize(img.copy(), (128,128), interpolation=cv2.INTER_AREA)

x = np.array(img, 'float32')
x = np.expand_dims(x, axis=0)
x /= 255.0  # normalize pixel values and change the data type to float32
#x = x.astype('uint8')  # convert back to uint8 for further processing

disease_class = ['Pepper__bell___Bacterial_spot', 'Pepper__bell___healthy', 'Potato___Early_blight',
                 'Potato___Late_blight', 'Potato___healthy', 'Tomato_Bacterial_spot', 'Tomato_Early_blight',
                 'Tomato_Late_blight', 'Tomato_Leaf_Mold', 'Tomato_Septoria_leaf_spot',
                 'Tomato_Spider_mites_Two_spotted_spider_mite', 'Tomato__Target_Spot',
                 'Tomato__Tomato_YellowLeaf__Curl_Virus', 'Tomato__Tomato_mosaic_virus', 'Tomato_healthy']

prediction = model.predict(x)
predicted_class_index = np.argmax(prediction)
predicted_class = disease_class[predicted_class_index]

print(f"The predicted class is {predicted_class}")