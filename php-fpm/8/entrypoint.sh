#!/usr/bin/env bash

rm -f /etc/nginx/conf.d/default.conf
echo "Generating nginx conf file...."
/bin/bash -c "/usr/local/bin/generate-nginx-config.sh"

echo Starting php-fpm...
/usr/local/sbin/php-fpm -D -R

echo "Starting nginx..."
/usr/sbin/nginx -g "daemon off;"

exec "$@"
