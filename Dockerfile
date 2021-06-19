# pull official base image
FROM python:3.8.3-alpine

WORKDIR /usr/src/my_project

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN pip install --upgrade pip

RUN apk update && apk add postgresql-dev gcc python3-dev musl-dev libpq
RUN apk add --no-cache --virtual .build-deps build-base linux-headers

COPY ./requirements.txt .
RUN pip install -r requirements.txt

# create directory for the app user
RUN mkdir -p /home/my_project

# create the app user
RUN addgroup -S my_project && adduser -S my_project -G my_project

# create the appropriate directories
ENV HOME=/home/my_project
ENV APP_HOME=/home/my_project/web
RUN mkdir $APP_HOME
RUN mkdir $APP_HOME/staticfiles
RUN mkdir $APP_HOME/mediafiles
WORKDIR $APP_HOME

COPY ./entrypoint.sh $APP_HOME

COPY . $APP_HOME

RUN chown -R my_project:my_project $APP_HOME

USER my_project

RUN chmod +x $APP_HOME/entrypoint.sh
ENTRYPOINT ["/home/my_project/web/entrypoint.sh"]
