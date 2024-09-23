# UFW
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow in on tun0 ssh to any port 22
sudo ufw allow in on tun0 to any port 80
sudo ufw allow in on tun0 to any port 8080
sudo ufw enable
