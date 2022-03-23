FROM python:alpine3.15

COPY . /app
WORKDIR /app
RUN python3 -m pip install -r requirements.txt

ENTRYPOINT ["python3", "create_bucket.py"]