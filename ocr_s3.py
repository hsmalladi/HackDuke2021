import sys
from flask import escape
import pytesseract
import cv2
import boto3
import numpy as np

def hello_get(request):
    return 'Hello World!'
