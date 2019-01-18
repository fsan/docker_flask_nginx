#!/bin/sh

uwsgi -v --ini /packages/app.ini &
nginx -g 'daemon off;'