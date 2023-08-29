import easyocr
import cv2 as cv

def get_text_from_image(img_path, cut=7):
    text = ''
    image = cv.imread(img_path)


    reader = easyocr.Reader(['en'])
    ocr_result = reader.readtext((image), paragraph="True", min_size=120, #180 for rgb
                             allowlist='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ')
    try:
        text=ocr_result[0][1].replace(' ', '')[:cut] # cut to 7 symbols
    except:
        print('too few symbols')

    return text
