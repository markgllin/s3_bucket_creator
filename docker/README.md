# S3 Bucket Creator

Simple application to automatically trigger the creation of an S3 bucket.

# Requirements
- Python3
- AWS CLI keys configured in addition to appropriate IAM permissions
- Docker (optional)
# Usage
## With Docker
```
# Build the image
$ docker build -t s3_bucket_creator .

# Run the image
$ docker run \
  -e AWS_ACCESS_KEY_ID=<aws_access_key_id> \
  -e AWS_SECRET_ACCESS_KEY=<aws_secret_access_key> \
  -e BUCKET_NAME=<bucket_name> \
  s3_bucket_creator

```

## Without Docker
```
# install the necessary dependencies
$ python -m pip install -r requirements.txt

# run the script
$ BUCKET_NAME=<bucket_name> python3 create_bucket.py
```
## Output
In both cases, the output will be similar to the following:
```
Creating bucket with name <bucket_name>!
Created <bucket_name>!
```

# CD
Currently, Github Actions is being used to automatically build and deploy the image to AWS Elastic Container Registry (ECR) on merge to `main`. The workflow is as follows:

1. A branch is merged to `main`.
2. GHA kicks of a workflow to builds the image and tags it with `latest` and the commit `sha`
3. The image is pushed to ECR
4. A new ECS task definition is executed through the `aws` cli on AWS Fargate

It was a deliberate decision to run the container as an ECS task as opposed to a service as the script is not a long running service.

## Manual Deployment
The deployment workflow triggers automatically on changes to `docker/` in `main` or through a manual dispatch. The manual dispatch allows you to specify a custom bucket name. To do so, go to [`Actions > Deploy Image`](https://github.com/markgllin/s3_bucket_creator/actions/workflows/build-and-deploy-img.yml) and then `Run workflow`.

# Problems
Some additional work to be done:

- The application is running as `root` in the container. A new user & group should be created during image creation to limit its permissions.
- The script will not validate if the bucket name adheres to S3's naming rules, in which case the script will throw an exception.