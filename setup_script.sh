curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
docker run -it --rm -d -p 8080:80 --name web nginx