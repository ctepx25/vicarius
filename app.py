#!/usr/local/bin/python3
from flask import Flask, render_template, jsonify, request
from urllib.request import Request, urlopen
from urllib import parse
import json, urllib.error, os


app = Flask(__name__)

@app.route('/')
def root():
    return render_template('index.html')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
  
