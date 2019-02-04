#!/bin/sh

sh /permissions.sh
rc-service uwsgi start
touch /run/openrc/softlevel
rc-service -D nginx start

while true; do sleep 1d; done
