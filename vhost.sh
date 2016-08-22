#!/bin/bash

URL="$1" # www.pelle.se
BASE="/srv/www/"
WEBROOT="$BASE$URL/"

SITES_AVAILABLE="/nginx/etc/sites-available/"
SITES_ENABLED="/nginx/etc/sites-enabled/"

echo "Virtual Host for $URL"
echo ""

echo "Create nginx conf file at $SITES_AVAILABLE$URL"
echo "server {
        listen       80 default_server;
        server_name  $URL;
        root         $WEBROOT;
 
	client_max_body_size 64M;
 
	# Deny access to any files with a .php extension in the uploads directory
        location ~* /(?:uploads|files)/.*\.php\$ {
                deny all;
        }
 
        location / {
                index index.php index.html index.htm;
                try_files \$uri \$uri/ /index.php?\$args;
        }
 
        location ~* \.(gif|jpg|jpeg|png|css|js)\$ {
                expires max;
        }
 
        location ~ \.php\$ {
                try_files \$uri =404;
                fastcgi_split_path_info ^(.+\.php)(/.+)\$;
                fastcgi_index index.php;
                fastcgi_pass  unix:/var/run/php-fpm/wordpress.sock;
                fastcgi_param   SCRIPT_FILENAME
                                \$document_root\$fastcgi_script_name;
                include       fastcgi_params;
        }
}" >> $SITES_AVAILABLE$URL

echo "Fix permissions"
chown -R web:www-data $WEBROOT
chmod -R 0755 $WEBROOT

echo "Symlink nginx conf file to $SITES_ENABLED$URL"
ln -s $SITES_AVAILABLE$URL $SITES_ENABLED$URL

echo "Restart nginx"
service nginx restart
