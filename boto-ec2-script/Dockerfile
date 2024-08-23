FROM --platform=linux/amd64 python:alpine
COPY boto-script.py /bin/
RUN chmod 755 /bin/boto-script.py
RUN pip install boto3 botocore
