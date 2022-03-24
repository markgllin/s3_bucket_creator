import os
import boto3
import botocore

def bucket_exists(s3_client, bucket_name):
    exists = True
    try:
        s3_client.meta.client.head_bucket(Bucket=bucket_name)
    except botocore.exceptions.ClientError as e:
        error_code = e.response['Error']['Code']
        if error_code == '404':
            exists = False
    
    return exists

def create_bucket(s3_client, bucket_name):
    print(f"Creating bucket with name {bucket_name}!")

    s3_client.create_bucket(
        Bucket=bucket_name, 
        ACL='private',
        CreateBucketConfiguration={'LocationConstraint': 'us-west-2'}
        )
        
    print(f"Created {bucket_name}!")


# Pass bucket name as an env var through TD to container
bucket_name = os.environ['BUCKET_NAME']
s3 = boto3.resource('s3')

if bucket_exists(s3, bucket_name):
    print(f'Bucket with the name {bucket_name} already exists!')
else:
    create_bucket(s3, bucket_name)