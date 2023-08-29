# python -m pip install flask
# export FLASK_APP=API/api.py
# flask run --without-threads

from flask import Flask, request, jsonify
from yolo import YOLO
import json
import yolo_video
import base64

app = Flask(__name__)
yolo_model = YOLO()


"""API_address/ping/<int:id>"""
@app.route("/ping/<int:id>", methods=["GET"])
def get_ping(id: int):
    print(f'Request for PING {id=} received')
    id = id + 1
    return jsonify(id), 200

@app.route('/getPlatesNumber', methods=['POST'])
def getPlatesNumber():
    res = json.loads(request.data)

    # decoded data
    decoded_data = base64.b64decode(res["imageFile"])
    img_file = open('base64.png', 'wb')
    img_file.write(decoded_data)
    img_file.close()
    image_path = r'base64.png'
    base64_b, texts = yolo_video.detect_license_plate(model=yolo_model, img_path=image_path, i=0)
    res = {'platesNumber': texts}
    return jsonify(res), 200

"""API_address/detectLicense?img="""
@app.route("/detectLicense", methods=['POST'])
def detectLicensePlate():
    res = json.loads(request.data)

    # decoded data
    decoded_data = base64.b64decode(res["imageFile"])
    img_file = open('base64.png', 'wb')
    img_file.write(decoded_data)
    img_file.close()
    image_path = r'base64.png'
    base64_b, texts = yolo_video.detect_license_plate(model=yolo_model, img_path=image_path, i=0)
    return jsonify(str(base64_b)), 200

if __name__ == '__main__':
    app.run(threaded=False, host='0.0.0.0', port=8080)