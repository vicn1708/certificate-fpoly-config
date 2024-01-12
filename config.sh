echo "Install Docker..."
bash docker/install.sh

list_domain=(
    ("fpolycheckin.io.vn" "www.fpolycheckin.io.vn")
    ("api.fpolycheckin.io.vn" "www.api.fpolycheckin.io.vn")
)

echo "SSL fpolycheckin.io.vn"
for domains in "${list_domain[@]}"; do
    concat=""

    for domain in "${domains[@]}"; do
        concat+="-d $domain "
    done

    sudo docker compose run --rm  certbot certonly --webroot --webroot-path /var/www/certbot/ --email vicn1708@gmail.com --agree-tos --no-eff-email --staging $concat
done

echo "RUN services"
sudo docker compose up -d
sudo docker compose ps
sudo docker compose logs certbot -f

sudo docker compose exec webserver ls -la /etc/letsencrypt/live

docker-compose up --force-recreate --no-deps certbot

sudo docker compose exec webserver ls -la /etc/letsencrypt/live

echo "Renew SSL fpolycheckin.io.vn"
for domains in "${list_domain[@]}"; do
    concat=""

    for domain in "${domains[@]}"; do
        concat+="-d $domain "
    done

    sudo docker compose run --rm  certbot certonly --webroot --webroot-path /var/www/certbot/ --email vicn1708@gmail.com --agree-tos --no-eff-email --force-renewal $concat
done

echo "Stop NGINX"
sudo docker compose down webserver

echo "Config openSSL"
sudo chmod -R 777 ./nginx/dhparam/
sudo openssl dhparam -out ./nginx/dhparam/dhparam-2048.pem 2048

sudo cp -r ./nginx/conf-ssl/* ./nginx/conf

sudo docker compose up -d --force-recreate --no-deps webserver
sudo docker compose ps