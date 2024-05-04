#!/usr/bin/env bash
 
set -e
 
role=${CONTAINER_ROLE:-app}

echo "Selected container role $role"
 
if [ "$role" = "app" ]; then
     
    rm -f /etc/nginx/conf.d/default.conf
    echo "Generating nginx conf file...."
    /bin/bash -c "/usr/local/bin/generate-nginx-config.sh"

    echo Starting php-fpm...
    /usr/local/sbin/php-fpm -D -R

    echo "Starting nginx..."
    /usr/sbin/nginx -g "daemon off;"

    php artisan optimize:clear

    exec "$@"
 
elif [ "$role" = "queue" ]; then
    
    php artisan optimize:clear

    php /var/www/artisan queue:work --tries=3 --sleep=3 --timeout=600
 
elif [ "$role" = "scheduler" ]; then
    
    php artisan optimize:clear

    while [ true ]
    do
      php /var/www/artisan schedule:run --verbose --no-interaction &
      sleep 60
    done
 
else
    echo "Could not match the container role \"$role\""
    exit 1
fi
