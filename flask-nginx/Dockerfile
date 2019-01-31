FROM ubuntu:latest
MAINTAINER motbus3

RUN apt-get update
RUN apt-get install nginx python3 python3-pip -y

RUN mkdir -p /app-setup
ADD /app-setup /app-setup
RUN pip3 install -r /app-setup/requirements.txt

ADD /wsgi/app.ini /packages/app.ini

ADD /nginx/nginx-app.conf /etc/nginx/sites-available/default

RUN update-rc.d nginx enable

ADD /kickstart/ /
RUN chmod 550 /*.sh

# ADD /service/uwsgi.service /packages
# RUN ln -s /packages/uwsgi.service /etc/systemd/system/multi-user.target.wants/uwsgi.service

ADD /service/uwsgi /etc/init.d/
RUN chmod 755 /etc/init.d/uwsgi

ADD /packages /packages
RUN mkdir -p /var/log/uwsgi/ && touch /var/log/uwsgi/err.log

EXPOSE 80

WORKDIR /packages

CMD /service.sh
