#!/bin/sh

echo "Starting uwsgi"
uwsgi --emperor --thunder-lock --ini /packages/app.ini &

