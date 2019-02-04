FROM nginx:1.15-alpine
MAINTAINER motbus3

RUN apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache

RUN apk add --no-cache --virtual .build-deps \
		gcc \
		libc-dev \
		python3-dev \
		linux-headers ;

RUN apk add --no-cache openrc;

RUN mkdir -p /app-setup
ADD /app-setup /app-setup
RUN pip3 install -r /app-setup/requirements.txt

RUN apk del .build-deps

ADD /wsgi/app.ini /packages/app.ini

ADD /nginx/nginx-app.conf /etc/nginx/sites-available/default
ADD /nginx/nginx-app.conf /etc/nginx/conf.d/default.conf
ADD /nginx/nginx.conf /etc/nginx/nginx.conf

ADD /kickstart/ /

ADD /service/uwsgi /etc/init.d/
RUN chmod 755 /etc/init.d/uwsgi

ADD /service/nginx /etc/init.d/
RUN chmod 755 /etc/init.d/nginx

ADD /packages /packages
RUN mkdir -p /var/log/uwsgi/ && touch /var/log/uwsgi/err.log

#RUN addgroup -S 'www'
#RUN adduser -S -D -H -g 'www' www
RUN adduser -D -H -g 'www' www
RUN addgroup www nginx
RUN openrc -q
RUN rc-update add uwsgi
RUN rc-update add nginx

RUN chown www /*.sh
RUN chmod 550 /*.sh

EXPOSE 80

WORKDIR /packages

CMD /service.sh
