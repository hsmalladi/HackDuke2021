import sys
from flask import escape
import pytesseract
import cv2
import boto3
import numpy as np
import os
import json

def hello_get(request):
    s3 = boto3.resource(
        service_name='s3',
        region_name='us-east-1',
        aws_access_key_id=os.getenv("ACCESS_KEY"),
        aws_secret_access_key=os.getenv("SECRET_KEY")
    )
    bucket = s3.Bucket('hackduke2021-receipts')
    request_json = request.get_json(silent=True)
    request_args = request.args
    key=""
    if request_json and 'image' in request_json:
        key = request_json['image']
    elif request_args and 'image' in request_args:
        key = request_args['image']
    else:
        key = 'bob.png'

    img = bucket.Object(key).get().get('Body').read()
    nparray = cv2.imdecode(np.asarray(bytearray(img)), cv2.IMREAD_COLOR)
    string = pytesseract.image_to_string(nparray)
    ret = ""
    for k in range(len(string)):
        if (ord(string[k]) >= 20 and ord(string[k]) <= 126):
            if (k == 0 or ord(string[k]) != 20 or ord(string[k-1]) != 20):
                ret += string[k]
        elif ord(string[k]) == 10:
            ret += " "

    # print it
    return json.dumps({"text": ret})

print(hello_get(None))
