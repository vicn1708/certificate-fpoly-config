sudo docker stop $(docker ps -qa)
sudo docker rm $(docker ps -qa)
# sudo docker rmi $(docker images -qa)

sudo docker network prune -f
sudo docker volume prune -f