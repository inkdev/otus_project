FROM ubuntu:16.04
ENV APP_HOME /app
WORKDIR $APP_HOME

COPY ui $APP_HOME
COPY tests $APP_HOME/tests
COPY requirements.txt $APP_HOME/
COPY requirements-test.txt $APP_HOME/

RUN apt-get update && apt-get install -y python-pip gunicorn
RUN pip install -r requirements.txt

ENV FLASK_APP $APP_HOME/ui/ui.py
ENV MONGO mongo_db
ENV MONGO_PORT 27017

EXPOSE 8000
CMD gunicorn -w 4 --log-level=debug ui:app -b 0.0.0.0

#ENTRYPOINT ["gunicorn","ui:app","-b","0.0.0.0"]

