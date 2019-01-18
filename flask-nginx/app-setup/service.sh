#!/bin/sh

uwsgi --emperor --thunder-lock --ini /packages/app.ini &
nginx -g 'daemon off;'