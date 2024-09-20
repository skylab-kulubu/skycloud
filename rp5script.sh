sudo apt update -y
sudo apt upgrade -y
sudo apt install tmux vim git ufw -y
sudo curl https://get.docker.com|bash
sudo mkdir /var/www/
sudo chown ubuntu:ubuntu -R /var/www
cd /var/www

# DOCKER
git clone https://github.com/skylab-kulubu/skycloud -b site-to-site
cd skycloud
sudo docker compose pull
sudo docker compose up -d

# UFW
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow in on tun0 to any port 80
sudo ufw allow in on tun0 to any port 8080
echo 'sudo ufw enable'
