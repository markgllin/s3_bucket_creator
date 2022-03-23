import boto3

s3 = boto3.resource('s3')

bucket_name = "buckety-mcbuckface"
print(f"Creating bucket with name {bucket_name}!")
s3.create_bucket(Bucket=bucket_name, 
    ACL='private',
    CreateBucketConfiguration={'LocationConstraint': 'us-west-2'})
print(f"Created {bucket_name}!")

