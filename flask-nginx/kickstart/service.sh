#!/bin/sh

sh /permissions.sh
service uwsgi start
service nginx start

while true; do sleep 1d; done
