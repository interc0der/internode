#!/bin/bash

echo "Enter Your SSL DOMAIN NAME (ie. test.example.com): "
read domain
echo "Your SSL domain name is set to $domain. Check DNS to make endpoint to ready for for SSL"

echo "Enter Your EMAIL (required for Let's Encrypt): "
read email_arg
echo "Your email is set to $email_arg!"

echo "Does everything look correct? 

    DOMAIN: $domain
    EMAIL: $email_arg

To proceed, indicate Y/N "
read x
if [ $x = 'N' ]; then  
    echo "Exiting. Please try again with correct information."
    exit 1
elif [ $x = 'Y' ]; then
    echo "Initializing containers..."

    echo 'Starting node container'
    docker-compose up -d node

data_path=./nginx-ssl/ssl
mkdir -p $data_path/conf
curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf > $data_path/conf/options-ssl-nginx.conf
curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem > $data_path/conf/ssl-dhparams.pem

path=./nginx-ssl/ssl/conf/live/$domain
echo 'Create the live folder that will hold the temporary certificates'
mkdir -p ./nginx-ssl/ssl/conf/live/$domain

openssl req -x509 -nodes -newkey rsa:1024 -days 1 -keyout $path/privkey.pem -out $path/fullchain.pem  

echo 'Starting certbot container'
docker-compose up -d certbot 
echo 'Starting nginx container'
docker-compose up -d nginx-ssl

tar -chvzf temp_certs.tar.gz $data_path/conf/archive/$domain $data_path/conf/renewal/$domain.conf

rm -rf $data_path/conf/live/$domain
rm -rf $data_path/conf/archive/$domain
rm -rf $data_path/conf/renewal/$domain.conf

docker-compose restart certbot

docker-compose exec certbot certbot certonly --webroot -w /var/www/certbot \
    --email $email_arg \
    -d $domain
    --rsa-key-size 4096 \
    --agree-tos \
    --force-renewal


echo 'Bringing containers down'
docker-compose down

echo 'Bringing containers up'
echo 'Starting certbot container'
docker-compose up -d certbot 
echo 'Starting node container'
docker-compose up -d node
echo 'Starting nginx container'
docker-compose up -d nginx-ssl


else
    echo 'Not a valid response. Try again.'
    exit 1
fi