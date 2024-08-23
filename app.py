#!/usr/local/bin/python3
from flask import Flask, render_template, jsonify, request
import os, requests, json

app = Flask(__name__)

@app.route('/')
def pods():
    token = open("/var/run/secrets/kubernetes.io/serviceaccount/token").read()
    url = "https://"+os.environ["KUBERNETES_SERVICE_HOST"]+":443/api/v1/namespaces/kube-system/pods"
    headers = {'Authorization': 'Bearer {0}'.format(token)}
    response = requests.get(url, headers=headers, verify="/var/run/secrets/kubernetes.io/serviceaccount/ca.crt")
    data = json.loads(response.text)["items"]
    return render_template('pods.html', data=data, len = len(data))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
  
