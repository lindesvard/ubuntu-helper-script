#!/bin/bash

DOMAIN=$1
EMAIL=lindesvard@gmail.com
NGINX_CONF="/etc/nginx/sites-available/$DOMAIN"
SITE_ROOT="/home/web/$DOMAIN"

# https://gist.github.com/cecilemuller/a26737699a7e70a7093d4dc115915de8

sudo apt-get -y install software-properties-common
sudo add-apt-repository -y ppa:certbot/certbot
sudo apt-get update
sudo apt-get -y install certbot

cat > /etc/nginx/snippets/letsencrypt.conf << "EOF"
location ^~ /.well-known/acme-challenge/ {
  default_type "text/plain";
  root /home/web/letsencrypt;
}
EOF

cat > /etc/nginx/snippets/ssl.conf << "EOF"
ssl_session_timeout 1d;
ssl_session_cache shared:SSL:50m;
ssl_session_tickets off;

ssl_protocols TLSv1.2;
ssl_ciphers EECDH+AESGCM:EECDH+AES;
ssl_ecdh_curve secp384r1;
ssl_prefer_server_ciphers on;

ssl_stapling on;
ssl_stapling_verify on;

add_header Strict-Transport-Security "max-age=15768000; includeSubdomains; preload";
add_header X-Frame-Options DENY;
add_header X-Content-Type-Options nosniff;
EOF

mkdir -p /home/web/letsencrypt/.well-known/acme-challenge
mkdir -p $SITE_ROOT
echo "<p>Hello $DOMAIN</p>" >> "$SITE_ROOT/index.html"

sudo chown -R web:web $SITE_ROOT
sudo chmod -R 775 $SITE_ROOT

cat > $NGINX_CONF <<EOF
server {
	listen 80 default_server;
	listen [::]:80 default_server ipv6only=on;
	server_name $DOMAIN;

	include /etc/nginx/snippets/letsencrypt.conf;

	root $SITE_ROOT;
	index index.html;
	location / {
		try_files $uri $uri/ =404;
	}
}
EOF

ln -s "/etc/nginx/sites-available/$DOMAIN" "/etc/nginx/sites-enabled/$DOMAIN"

sudo systemctl reload nginx

certbot certonly --webroot --agree-tos --no-eff-email --email $EMAIL -w /home/web/letsencrypt -d $DOMAIN

cat > $NGINX_CONF <<EOF
## http://$DOMAIN redirects to https://$DOMAIN
server {
	listen 80;
	listen [::]:80;
	server_name $DOMAIN;

	include /etc/nginx/snippets/letsencrypt.conf;

	location / {
		return 302 https://$server_name$request_uri;
	}
}

# # https://www.$DOMAIN redirects to https://$DOMAIN
# server {
# 	listen 443 ssl http2;
# 	listen [::]:443 ssl http2;
# 	server_name www.$DOMAIN;
# 
# 	ssl_certificate /etc/letsencrypt/live/www.$DOMAIN/fullchain.pem;
# 	ssl_certificate_key /etc/letsencrypt/live/www.$DOMAIN/privkey.pem;
# 	ssl_trusted_certificate /etc/letsencrypt/live/www.$DOMAIN/fullchain.pem;
# 	include /etc/nginx/snippets/ssl.conf;
# 
# 	location / {
# 		return 302 https://$DOMAIN$request_uri;
# 	}
# }

## Serves https://www.$DOMAIN
server {
	server_name $DOMAIN;
	listen 443 ssl http2 default_server;
	listen [::]:443 ssl http2 default_server ipv6only=on;

	ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
	include /etc/nginx/snippets/ssl.conf;

	root $SITE_ROOT;
	index index.html;
	location / {
		try_files $uri $uri/ =404;

    #proxy_pass http://127.0.0.1:3000;
    #proxy_http_version 1.1;
    #proxy_set_header Upgrade $http_upgrade;
    #proxy_set_header Connection 'upgrade';
    #proxy_set_header Host $host;
    #proxy_cache_bypass $http_upgrade;
	}
}
EOF

sudo systemctl reload nginx

cat > /home/web/letsencrypt-cron.sh <<EOF
#!/bin/bash
systemctl reload nginx
EOF

chmod +x /home/web/letsencrypt-cron.sh

echo ""
echo ""
echo "Add following to crontab"
#echo new cron into cron file
echo "20 3 * * * certbot renew --noninteractive --renew-hook /home/web/letsencrypt-cron.sh"
