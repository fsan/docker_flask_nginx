#!/bin/bash

echo "Starting uwsgi"
uwsgi --emperor --thunder-lock --ini /packages/app.ini &

