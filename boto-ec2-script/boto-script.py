import boto3, argparse
from botocore.config import Config

args = argparse.Namespace()

for argname in ['region', 'ami', 'instance_type', 'subnet_id']:
    argval = input(f'>>> enter {argname}: ')
    setattr(args, argname, argval)

print(args.region)
print(args.ami)
print(args.instance_type)
print(args.subnet_id)


my_config = Config(
    region_name = args.region,
    signature_version = 'v4',
    retries = {
        'max_attempts': 10,
        'mode': 'standard'
    }
)

ec2 = boto3.client('ec2', config=my_config)

response = ec2.run_instances(
    BlockDeviceMappings=[
        {
            'DeviceName': '/dev/sdh',
            'Ebs': {
                'VolumeSize': 100,
            },
        },
    ],
    ImageId=args.ami,
    InstanceType=args.instance_type,
    SubnetId=args.subnet_id,
    #KeyName='my-key-pair',
    MaxCount=1,
    MinCount=1,
    #SecurityGroupIds=['sg-1a2b3c4d',],

    TagSpecifications=[
        {
            'ResourceType': 'instance',
            'Tags': [
                {
                    'Key': 'Purpose',
                    'Value': 'test',
                },
            ],
        },
    ],
)

print(response)
