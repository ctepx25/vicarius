FROM --platform=linux/amd64 python:alpine
COPY ./app.py /
COPY ./templates /templates
RUN pip3 install flask
ENTRYPOINT [ "/usr/local/bin/python3", "./app.py" ]
