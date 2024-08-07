# Skylab Homeserver Alpine

<div align="center">
<img src="https://img.shields.io/badge/Alpine_Linux-0D597F?style=for-the-badge&logo=alpine-linux&logoColor=white" \> <img src="https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white"></img> <img src="https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white"></img> <img src="https://img.shields.io/badge/Ghost-000?style=for-the-badge&logo=ghost&logoColor=yellow"></img> <img src="https://img.shields.io/badge/MariaDB-003545?style=for-the-badge&logo=mariadb&logoColor=white"></img> <img src="https://img.shields.io/badge/redis-CC0000.svg?&style=for-the-badge&logo=redis&logoColor=white"\> <img src="https://img.shields.io/badge/Nextcloud-0082C9?style=for-the-badge&logo=Nextcloud&logoColor=white"></img> <img src="https://raw.githubusercontent.com/Stirling-Tools/Stirling-PDF/main/docs/stirling.png" width="30"/>
</div>

01.08.24 Tarihi ile kullanılan servisler:

- [NextCloud](https://nextcloud.com/)
- [MariaDB](https://mariadb.org/)
- [Nginx](https://nginx.org/en/)
- [Stirling-PDF](https://github.com/Stirling-Tools/Stirling-PDF)
- [Ghost CMS](https://ghost.org/)
- [Redis](https://hub.docker.com/_/redis)
- [ONLY Office](https://www.onlyoffice.com/)


## Nextcloud
Gerekli ayarları yapmak için [.env](https://github.com/farukerdem34/homeserver/blob/alpine/nextcloud/example.env) dosyasını oluşturmalısınız.
Örnek bir `nextcloud/.env` dosyası
```
MYSQL_DATABASE=nextcloud
MYSQL_USER=nextcloud
MYSQL_PASSWORD=nextcloud
MYSQL_HOST=db
NEXTCLOUD_TRUSTED_DOMAINS=nextcloud.skylab.com cloud.skylab.com
NEXTCLOUD_ADMIN_USER=nextcloud
NEXTCLOUD_ADMIN_PASSWORD=nextcloud
```
### Dosya Yükleme Boyutu Sınırı
[./nextcloud/web/nginx.conf](https://github.com/farukerdem34/homeserver/blob/alpine/nextcloud/web/nginx.conf) 62. satırdaki `client_max_body_size` değişkenini düzenleyerek dosya yükleme boyutun ayarlayabilirisiniz.

Nextcloud hakkında daha fazla ortam değişkeni [için](https://hub.docker.com/_/nextcloud#docker-secrets)

## MySQL
Gerekli ayarları yapmak için [.env](https://github.com/farukerdem34/homeserver/blob/alpine/mysql/example.env) dosyasını oluşturmalısınız.
Örnek bir `mysql/.env` dosyası
```
MARIADB_ROOT_PASSWORD=nextcloud
MYSQL_DATABASE=nextcloud
MYSQL_USER=nextcloud
MYSQL_PASSWORD=nextcloud
```
MySQL hakkında daha fazla ortam değişken [için](https://dev.mysql.com/doc/refman/5.7/en/environment-variables.html)

## Nginx
- [X] HTTPS eklenecek
`HTTPS` kullanımı için `gencert` scriptini çalıştırarak sertifikaları `certs` klasörüne eklemelisiniz.

Bunun için aşağıdaki komutu `gencert` klasörünün içerisinde çalıştırmanız yeterli olacaktır.
```bash
❯ yes NA | bash ../gencert
```
- [ ] SSL Sertifika otomasyonu eklenecek

> Not: bunun için `openssl` paketinin sisteminizde kurulu olması gereklidir.

# Canlıya Almadan Önce!
nginx/nginx.conf dosyasındaki `skylab` değerlerini alan adı ile değiştirin!

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
cd homeserver
```
```bash
docker compose up -d
```
NextCloud uygulamasına erişim sağladıktan sonra `nextcloud` klasörünün içerisinde bulunan `set_configuration.sh` dosyasını aşağıdaki komut ile çalıştırın.
```bash
bash nextcloud/set_configuration.sh
```
