### This python script creates EC2 instances


#### Usage:
Make sure boto3 and botocore modules are installed:
```sh
pip install boto3 botocore
```
Export aws credentials:
```sh
export AWS_ACCESS_KEY_ID=*****************
export AWS_SECRET_ACCESS_KEY=***********************
```

Run the script. You'll be prompted to provide region, ami, instance type, subnet-id:
```sh
>>> enter region: eu-north-1
>>> enter ami: ami-090abff6ae1141d7d
>>> enter instance_type: t3.micro
>>> enter subnet_id: subnet-072d97d0f56828f8c
```

Alternatively you can build Docker image and run the script from within the container:
```sh
docker build -t boto .
docker run --name boto -e AWS_ACCESS_KEY_ID=*** -e AWS_SECRET_ACCESS_KEY=*** -di boto /bin/sh
docker exec -ti boto /bin/sh

/bin/boto-script.py
```
