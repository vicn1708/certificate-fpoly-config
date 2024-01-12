sudo docker compose pull certificate-client
sudo docker compose pull certificate-server

sudo docker compose up -d certificate-client
sudo docker compose up -d certificate-server

sudo docker image prune -f
