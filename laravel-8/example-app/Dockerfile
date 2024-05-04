FROM vuongtlt13/nginx-php-fpm:8.0

# change to your timezone
ENV TZ=Asia/Saigon
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /var/www

COPY . .

RUN chmod +x -R ./scripts
RUN composer install --no-dev --no-interaction

RUN chown -R www-data:www-data /var/www


ENTRYPOINT [ "/var/www/scripts/entrypoint.sh" ]
