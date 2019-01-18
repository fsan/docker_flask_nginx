FROM ubuntu:latest

RUN apt-get update
RUN apt-get install nginx python3 python3-pip -y

#RUN addgroup www
#RUN adduser --disabled-login --disabled-password --system --no-create-home --shell /sbin/nologin --group nginx 
#RUN usermod -a -G www-data nginx

RUN mkdir -p /app-setup
COPY /app-setup /app-setup
RUN pip3 install -r /app-setup/requirements.txt

COPY /wsgi/app.ini /packages/app.ini

COPY /nginx/nginx-app.conf /etc/nginx/sites-available/default
RUN update-rc.d nginx enable

COPY /app-setup/service.sh /service.sh
RUN chmod 550 /service.sh

COPY /packages /packages

EXPOSE 80

WORKDIR /packages


ENTRYPOINT /service.sh

