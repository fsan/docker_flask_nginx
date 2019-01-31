#!/bin/sh

PERM_FILE=/etc/nginx/sites-available/permissions.conf

if [ -z "${ALLOWED}" ]; then
	echo "ALLOWING EVERYONE"
	echo allow all\; > $PERM_FILE;
else
	echo "FILTER ALLOWED: ${ALLOWED}"
	rm -f $PERM_FILE
	touch $PERM_FILE
	IFS=";"; for ip in ${ALLOWED}; do
		if [ ! -z "${ALLOWED}" ]; then
			echo allow $ip\; >> /etc/nginx/sites-available/permissions.conf;
		fi
       	done ;
       	echo deny all\; >> $PERM_FILE;
	chown www-data $PERM_FILE
	chmod 440 $PERM_FILE
fi
uwsgi --emperor --thunder-lock --ini /packages/app.ini &
nginx -g 'daemon off;'
