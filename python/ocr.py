import sys
import pytesseract
import cv2
import boto3
import numpy as np

s3_resource = boto3.resource('s3')

key = sys.argv[1]
bucket = s3_resource.Bucket('hackduke2021-receipts')
img = bucket.Object(key).get().get('Body').read()
nparray = cv2.imdecode(np.asarray(bytearray(img)), cv2.IMREAD_COLOR)
string = pytesseract.image_to_string(nparray)
# print it
print(string)
