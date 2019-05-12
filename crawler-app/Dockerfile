FROM ubuntu:16.04

WORKDIR /crawler-app
COPY . /crawler-app
RUN apt-get update && apt-get install -y python3-pip
RUN pip3 install -r requirements.txt
ENV MONGO mongo_db
ENV MONGO_PORT 27017
ENV RMQ_HOST=rabbitmq
ENV RMQ_QUEUE=rabbitmq
ENV RMQ_USERNAME=guest
ENV RMQ_PASSWORD=guest
ENV CHECK_INTERVAL=10
ENV EXCLUDE_URLS='.*github.com'
ENV URL='https://vitkhab.github.io/search_engine_test_site/'
ENTRYPOINT python3 -u crawler/crawler.py $URL
