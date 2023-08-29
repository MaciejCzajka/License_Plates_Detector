from PIL import Image
import cv2 as cv
from yolo import YOLO
import ocr
import numpy as np
import math
import base64


def grayscale(image):
    return cv.cvtColor(image, cv.COLOR_BGR2GRAY)


def noise_removal(image):
    kernel = np.ones((1, 1), np.uint8)
    image = cv.dilate(image, kernel, iterations=1)
    kernel = np.ones((1, 1), np.uint8)
    image = cv.erode(image, kernel, iterations=1)
    image = cv.morphologyEx(image, cv.MORPH_CLOSE, kernel)
    image = cv.medianBlur(image, 3)
    return (image)


def remove_borders(image):
    contours, heiarchy = cv.findContours(image, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE)
    cntsSorted = sorted(contours, key=lambda x: cv.contourArea(x))
    cnt = cntsSorted[-1]
    x, y, w, h = cv.boundingRect(cnt)
    crop = image[y:y + h, x:x + w]
    return (crop)


def rotate_image(image, angle):
    image_center = tuple(np.array(image.shape[1::-1]) / 2)
    rot_mat = cv.getRotationMatrix2D(image_center, angle, 1.0)
    result = cv.warpAffine(image, rot_mat, image.shape[1::-1], flags=cv.INTER_LINEAR)
    return result


def compute_skew(src_img):
    if len(src_img.shape) == 3:
        h, w, _ = src_img.shape
    elif len(src_img.shape) == 2:
        h, w = src_img.shape
    else:
        print('upsupported image type')

    img = cv.medianBlur(src_img, 3)

    edges = cv.Canny(img, threshold1=30, threshold2=100, apertureSize=3, L2gradient=True)
    lines = cv.HoughLinesP(edges, 1, math.pi / 180, 30, minLineLength=w / 4.0, maxLineGap=h / 4.0)
    angle = 0.0
    cnt = 0
    for x1, y1, x2, y2 in lines[0]:
        ang = np.arctan2(y2 - y1, x2 - x1)
        if math.fabs(ang) <= 30:  # excluding extreme rotations
            angle += ang
            cnt += 1

    if cnt == 0:
        return 0.0
    return (angle / cnt) * 180 / math.pi


def deskew(src_img):
    return rotate_image(src_img, compute_skew(src_img))


def detect_img(yolo, img_path, j):
    try:
        image = Image.open(img_path)
    except:
        print('Image open Error! Try again!')
        return None
    else:
        r_image, pred = yolo.detect_image(image)

        r_image.save('detected.png')
        processed_image = cv.imread(img_path)

        if not pred:
            return None
        i = 0
        texts = []
        for prediction in pred:
            x1 = prediction[1][0]
            x2 = prediction[2][0]
            y1 = prediction[1][1]
            y2 = prediction[2][1]
            w = abs(x1 - x2)
            h = abs(y1 - y2)

            img = processed_image[y1:y1 + h, x1:x1 + w]
            img = deskew(img)

            gray_image = grayscale(img)
            thresh, im_bw = cv.threshold(gray_image, 125, 150,
                                         cv.THRESH_BINARY)  # the best = 120,150; 100, 150;   150, 210
            no_noise = noise_removal(im_bw)
            no_borders = remove_borders(no_noise)

            cv.imwrite(f'img/img{j}{i}.png', no_borders)
            text = ocr.get_text_from_image(f'img/img{j}{i}.png')
            texts.append(text)
            if i > 0:
                processed_image = cv.imread(f'final/final{j}{i - 1}.png')
            res = cv.rectangle(processed_image, (x1, y1), (x1 + w, y1 + h), (0, 0, 255), 15)
            res = cv.putText(res, text, (x1, y1 - 20), cv.FONT_HERSHEY_SIMPLEX, 4, (0, 0, 255), 15, cv.LINE_AA)
            cv.imwrite(f'final/final{j}{i}.png', res)
            i += 1
        with open(f"final/final{j}{i - 1}.png", "rb") as img_file:
            my_string = base64.b64encode(img_file.read())
        return my_string, texts


def detect_license_plate(model, img_path, i):
    str, texts = detect_img(model, img_path, i)
    if not str or not texts:
        return None, [None]

    return str, texts