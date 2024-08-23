FROM --platform=linux/amd64 python:alpine
COPY ./app.py /
COPY ./templates /templates
RUN pip install flask
RUN pip install requests
ENTRYPOINT [ "/usr/local/bin/python3", "./app.py" ]
