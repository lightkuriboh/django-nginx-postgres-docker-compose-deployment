#!/bin/sh

if [ "$DATABASE" = "postgres" ]
then
    echo "Waiting for database to start..."

    while ! nc -z $SQL_HOST $SQL_PORT; do
      sleep 0.1
    done

    echo "Database started"
fi

python manage.py makemigrations
python manage.py migrate
python manage.py collectstatic --no-input --clear
python manage.py initadmin

exec "$@"
