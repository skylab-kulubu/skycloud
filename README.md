# Skylab Homeserver

<div align="center">
<img src="https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white"></img> <img src="https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white"></img> <img src="https://img.shields.io/badge/Ghost-000?style=for-the-badge&logo=ghost&logoColor=yellow"></img> <img src="https://img.shields.io/badge/MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white"></img> <img src="https://img.shields.io/badge/Nextcloud-0082C9?style=for-the-badge&logo=Nextcloud&logoColor=white"></img> <img src="https://raw.githubusercontent.com/Stirling-Tools/Stirling-PDF/main/docs/stirling.png" width="30"/>
</div>

30.07.24 Tarihi ile kullanılan servisler:

- [NextCloud](https://nextcloud.com/)
- [MySQL](https://www.mysql.com/)
- [Nginx](https://nginx.org/en/)
- [Stirling-PDF](https://github.com/Stirling-Tools/Stirling-PDF)
- [Ghost CMS](https://ghost.org/)

## Nextcloud
Gerekli ayarları yapmak için [.env](https://github.com/farukerdem34/SkylabHomeServer/blob/master/nextcloud/.env) dosyasını düzenlemelisiniz.
Örnek bir `nextcloud/.env` dosyası
```
MYSQL_DATABASE=nextcloud
MYSQL_USER=nextcloud
MYSQL_PASSWORD=nextcloud
MYSQL_HOST=db
NEXTCLOUD_TRUSTED_DOMAINS=nextcloud.localhost cloud.localhost
NEXTCLOUD_ADMIN_USER=nextcloud
NEXTCLOUD_ADMIN_PASSWORD=nextcloud
```

Nextcloud hakkında daha fazla ortam değişkeni [için](https://hub.docker.com/_/nextcloud#docker-secrets)

## MySQL
Gerekli ayarları yapmak için [.env](https://github.com/farukerdem34/SkylabHomeServer/blob/master/mysql/.env) dosyasını düzenlemelisiniz.
Örnek bir `mysql/.env` dosyası
```
MYSQL_ROOT_PASSWORD=nextcloud
MYSQL_DATABASE=nextcloud
MYSQL_USER=nextcloud
MYSQL_PASSWORD=nextcloud
```
MySQL hakkında daha fazla ortam değişken [için](https://dev.mysql.com/doc/refman/5.7/en/environment-variables.html)

## Nginx
- [ ] HTTPS eklenecek
# Canlıya Almadan Önce!
nginx/nginx.conf dosyasındaki `localhost` değerlerini alan adı ile değiştirin!

# Kurulum
Sisteminizde `Docker` kurulu olmalı, eğer önceden `Docker` kurulu bir sisteminiz varsa ve sisteminizin paket yöneticisi aracılığıyla indirmişseniz `Docker`ı sisteminizden öncelikle silin ve aşağıdaki adımları izleyerek sisteminize `Docker` yükleyin.
Ubuntu
```bash
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; \
do sudo apt-get remove $pkg; \
done
```

RHEL/Fedora
```bash
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine \
                  podman \
                  runc
```
ardından `Docker` yüklemek için
```
curl -fsSL https://get.docker.com -o get-docker.sh && sudo bash get-docker.sh
```
`Docker` kurulumu gerçekleştikten sonra
```bash
git clone https://github.com/farukerdem34/homeserver.git
```
```bash
docker compose up -d
```

