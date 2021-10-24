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
        aws_access_key_id=os.environ.get("ACCESS_KEY"),
        aws_secret_access_key=os.environ.get("SECRET_KEY")
    )
    bucket = s3_resource.Bucket('hackduke2021-receipts')
    request_json = request.get_json(silent=True)
    request_args = request.args
    key=''
    if request_json and 'image' in request_json:
        key = request_json['image']
    elif request_args and 'image' in request_args:
        key = request_args['image']
    else:
        key = 'bob.png'

    img = bucket.Object(key).get().get('Body').read()
    cv_image = cv2.imread(img)
    string = pytesseract.image_to_string(cv_image)

    # print it
    return json.dumps({"text": ret})
