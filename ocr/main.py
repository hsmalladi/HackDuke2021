import sys
from flask import escape
import boto3
import numpy as np
import os
import json
from google.cloud import vision


def hello_get(request):
    s3 = boto3.resource(
        service_name='s3',
        region_name='us-east-1',
        aws_access_key_id=os.getenv("ACCESS_KEY"),
        aws_secret_access_key=os.getenv("SECRET_KEY")
    )
    bucket = s3.Bucket('hackduke2021-receipts')


    # print(request)
    request_json = request.get_json(force=True)
    key = request_json["image"]
    print(key)

    img = bucket.Object(key).get().get('Body').read()
    client = vision.ImageAnnotatorClient()
    image = vision.Image(content=img)
    response = client.text_detection(image=image)
    texts = response.text_annotations
    print('Texts:')
    ret = ""

    for text in texts:
        ret = text.description.replace("\n", " ")
        break
    return json.dumps({"text": ret})
