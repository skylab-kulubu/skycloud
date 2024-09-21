echo 'Updating pkgs' 
sudo apt update -y -qq
sudo apt upgrade -y -qq

echo 'Installing Docker Engine'
sudo apt install tmux vim git ufw -y -qq
sudo curl https://get.docker.com -o /tmp/install_docker.sh
bash /tmp/install_docker.sh > /dev/null 2>&1
rm /tmp/install_docker.sh

sudo mkdir /var/www/
sudo chown ubuntu:ubuntu -R /var/www
cd /var/www

# DOCKER
echo 'Cloning skylab-kulubu/skycloud'
git clone https://github.com/skylab-kulubu/skycloud -b site-to-site > /dev/null 2>&1
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
