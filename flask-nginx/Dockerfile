FROM ubuntu:latest
MAINTAINER motbus3

RUN apt-get update
RUN apt-get install nginx python3 python3-pip -y

RUN mkdir -p /app-setup
COPY /app-setup /app-setup
RUN pip3 install -r /app-setup/requirements.txt

COPY /wsgi/app.ini /packages/app.ini

COPY /nginx/nginx-app.conf /etc/nginx/sites-available/default
# COPY /nginx/permissions.conf /etc/nginx/sites-available/permissions.conf

RUN update-rc.d nginx enable

COPY /kickstart/service.sh /service.sh
RUN chmod 550 /service.sh

COPY /packages /packages
RUN mkdir -p /var/log/uwsgi/ && touch /var/log/uwsgi/err.log

EXPOSE 80

WORKDIR /packages

ENTRYPOINT /service.sh

