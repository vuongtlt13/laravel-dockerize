#!/usr/bin/env bash

echo "server {
    listen 8080 default_server;
    listen [::]:8080 default_server;  
    server_name _;

    # Add index.php to setup Nginx, PHP & PHP-FPM config
    index index.php;
    
    error_log  /var/log/nginx/error.log;
    access_log /var/log/nginx/access.log;
    root $DOCUMENT_ROOT;
    
    charset utf-8;

    add_header X-Frame-Options \"SAMEORIGIN\";
    add_header X-XSS-Protection \"1; mode=block\";
    add_header X-Content-Type-Options \"nosniff\";
    proxy_set_header HTTP_AUTHORIZATION \$http_authorization;
    
    client_max_body_size $CLIENT_MAX_BODY_SIZE;
    server_tokens off;
    
    # Hide PHP headers 
    fastcgi_hide_header X-Powered-By; 
    fastcgi_hide_header X-CF-Powered-By;
    fastcgi_hide_header X-Runtime;

    # pass PHP scripts on Nginx to FastCGI (PHP-FPM) server
    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    location ~ \\.php\$ {
        try_files \$uri =404;
        fastcgi_split_path_info ^(.+\\.php)(/.+)\$;
        # Nginx php-fpm config:
        fastcgi_pass unix:/var/run/php-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param PATH_INFO \$fastcgi_path_info;
        
    }

    location / {
        try_files \$uri \$uri/ /index.php\$is_args\$args;
        gzip_static on;
    }
    
    location ~ \.css {
        add_header  Content-Type    text/css;
    }
    
    location ~ \.js {
        add_header  Content-Type    application/x-javascript;
    }

    # deny access to Apache .htaccess on Nginx with PHP, 
    # if Apache and Nginx document roots concur
    location ~ /\.ht    {deny all;}
    location ~ /\.svn/  {deny all;}
    location ~ /\.git/  {deny all;}
    location ~ /\.hg/   {deny all;}
    location ~ /\.bzr/  {deny all;}
    location ~ /\.(?!well-known).* {deny all;}
}
" > "/etc/nginx/sites-enabled/default";