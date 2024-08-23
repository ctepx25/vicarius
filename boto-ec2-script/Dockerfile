FROM --platform=linux/amd64 python:alpine
COPY ./boto-client.py /bin/
RUN chmod 755 /bin/boto-client.py
RUN pip install boto3 botocore
