# Skycloud

The project consists of 3 sub-parts, `Nextcloud`, ``Collabora CODE`` and `NGINX` Reverse Proxy.

- nextcloud is the main component for storing, processing and accessing data, all other components provide access to `Nextcloud` or improve the efficiency of `Nextcloud`.
- ``Collabora CODE`` enables collaborative work and editing of various documents to work with `Nextcloud`
- `NGINX` Reverse Proxy allows you to access `Nextcloud` through the domain name and make the necessary redirections

## Nextcloud
`compose.yml`:
```yaml
volumes:
  nextcloud:
  db:

services:
  nextcloud-db:
    image: mariadb:10.6
    restart: always
    command: --transaction-isolation=READ-COMMITTED --log-bin=binlog --binlog-format=ROW
    volumes:
      - db:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=<password>
      - MYSQL_PASSWORD=<password>
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
    networks:
      - nextcloud

  nextcloud-app:
    image: nextcloud
    restart: always
    ports:
      - 8080:80
    links:
      - nextcloud-db
    volumes:
      - /mnt/skycloud:/var/www/html
    environment:
      - MYSQL_PASSWORD=<password>
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
      - MYSQL_HOST=nextcloud-db
    networks:
      - shared
      - nextcloud
networks:
  shared:
    external: true
  nextcloud:
```

### Volumes
```yaml
volumes:
  nextcloud:
  db:
```
- The ``Nextcloud`` storage is where all `Nextcloud` data is stored, including `App` and `Configuration` storage.
- The `db` storage holds all the data for the `MariaDB` database
### Networks

```yaml
networks:
  shared:
    external: true
  nextcloud:
```

- The ``shared`` network is used to communicate with containers in other compose projects and is not a project dependency, it is created manually.
- The ``Nextcloud`` network is used as a private network to mediate communication between containers in the `Skycloud` project.
### Services
#### Nextcloud-db
```yaml
nextcloud-db:
    image: mariadb:10.6
    restart: always
    command: --transaction-isolation=READ-COMMITTED --log-bin=binlog --binlog-format=ROW
    volumes:
      - db:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=<password>
      - MYSQL_PASSWORD=<password>
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
    networks:
      - nextcloud
```

It connects to the ``Nextcloud`` network and allows other containers to access the database and installs it with the following environment variables.
```
MYSQL_ROOT_PASSWORD=<password>
MYSQL_PASSWORD=<password>
MYSQL_DATABASE=nextcloud
MYSQL_USER=nextcloud
```
#### nextcloud-app
```yaml
nextcloud-app:
    image: nextcloud
    restart: always
    ports:
      - 8080:80
    links:
      - nextcloud-db
    volumes:
      - /mnt/skycloud:/var/www/html
    environment:
      - MYSQL_PATABASE=nextcloud
      - MYSQL_USERSSWORD=<password>
      - MYSQL_DA=nextcloud
      - MYSQL_HOST=nextcloud-db
    networks:
      - shared
      - nextcloud
```

It connects to the ``Nextcloud`` network to connect to the database, and connects to the `shared` network to access containers of third party plugins *(for example ``Collabora CODE``)*.
It connects the `/var/www/html` folder in the container to the `/mnt/skycloud` *(in this case external HDD)* folder on the host machine.
It provides the necessary configurations with the following environment variables.
```
MYSQL_PATABASE=nextcloud
MYSQL_USERSSWORD=<password>
MYSQL_DA=nextcloud
MYSQL_HOST=nextcloud-db
```

## Collabora CODE
`compose.yml`
```yaml
services:
  collabora:
    image: collabora/code:24.04.13.1.1
    container_name: 'collabora'
    ports:
      - 9980:9980/tcp
    restart: always
    environment:
      - aliasgroup1=https://cloud.domain.tld:443
      - username=admin
      - password=admin
      - dictionaries=en_US,tr_TR
      - extra_params=
        --o=ssl.enable=false
        --o:ssl.termination=true
        --o:user_interface.mode=compact
        --o:logging.level=warning
    cap_add:
      - MKNOD
```
#### environment
- `aliasgroup1` specifies the URL from which your `Nextcloud` is accessed, in this example it is `https://cloud.domain.tld:443`, details for this URL will be mentioned in ``NGINX`` settings
- `username` and `password` are the credentials you will use to log in to the admin panel for ``Collabora CODE``
- `dictionaries` argument to specify which languages to use when editing documents
- `extra_params` specifies which parameters to use at the start of ``Collabora CODE``.
	- `--o:ssl.enable=false` specifies that ``Collabora CODE`` should not use SSL, it is in your best interest to provide SSL access through `NGINX` with certificates from a certificate provider.
	- `--o:ssl_termination=true` ``NGINX`` specifies that you will use SSL certificates in your reverse proxy settings and that it will work accordingly.
	- `--o:user_interface.mode=compact` specifies that the user interface will run in compact mode.
	- `--logging.level=warning` increases the level of logging to make debugging easier.
#### cap_add
`MKNOD` is a capability you give to `Collabora CODE` to facilitate your authorization management processes by providing access to your file system.
### Nextcloud Integration
You can install the app from Web UI > Apps > Richdocuments or command below:
for `x86`:
```bash
docker compose exec -it nextcloud-app php occ app:install richdocumentscode
docker compose exec -it nextcloud-app php occ app:enable richdocumentscode
```
for `arm64`:
```bash
docker compose exec -it nextcloud-app php occ app:install richdocumentscode_arm64
docker compose exec -it nextcloud-app php occ app:enable richdocumentscode_arm64
```
## NGINX
You can run the docker container for `NGINX` for testing purposes using the following command:
```bash
docker run -d -p 80:80 -p 443:433 -v ./nginx:/etc/nginx/conf.d -v /path/to/certificate.crt:/etc/nginx/ssl/certificate.crt nginx
```
### nextcloud.conf
```
server {
    listen 443 ssl;
    listen [::]:443 ssl;

    server_name cloud.domain.tld;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
    ssl_certificate /etc/ssl/skycloud/fullchain.pem;
    ssl_certificate_key /etc/ssl/skycloud/privkey.pem;
	
    location / {
        proxy_pass http://<Nextcloud IPv4 Address>:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
	#proxy_set_header X-Forwarded-Prefix /;
    }
}


server {
    listen 80;

    server_name cloud.domain.tld;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
	
    location / {
	if ($remote_addr != <Collabora CODE IPv4 Address>){
		return 302 https://$host$request_uri;
	}
        proxy_pass http://<Nextcloud IPv4 Address>:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
	proxy_set_header X-Forwarded-Prefix /;
    }
}
```

### collabora.conf
```
server {
 listen       443 ssl;

 server_name  code.domain.tld;
 ssl_certificate /etc/ssl/code.domain.tld/certificate.crt;
 ssl_certificate_key /etc/ssl/code.domain.tld/private.key;
 
 # static files
 location ^~ /browser {
   proxy_pass http://<Collabora CODE IPv4 Address>:9980;
   proxy_set_header Host $host;
 }

 # WOPI discovery URL
 location ^~ /hosting/discovery {
   proxy_pass http://<Collabora CODE IPv4 Address>:9980;
   proxy_set_header Host $host;
 }

 # Capabilities
 location ^~ /hosting/capabilities {
   proxy_pass http://<Collabora CODE IPv4 Address>:9980;
   proxy_set_header Host $host;
 }

 # main websocket
 location ~ ^/cool/(.*)/ws$ {
   proxy_pass http://<Collabora CODE IPv4 Address>:9980;
   proxy_set_header Upgrade $http_upgrade;
   proxy_set_header Connection "Upgrade";
   proxy_set_header Host $host;
   proxy_read_timeout 36000s;
 }

 # download, presentation and image upload
 location ~ ^/(c|l)ool {
   proxy_pass http://<Collabora CODE IPv4 Address>:9980;
   proxy_set_header Host $host;
 }

 # Admin Console websocket
 location ^~ /cool/adminws {
   proxy_pass http://<Collabora CODE IPv4 Address>:9980;
   proxy_set_header Upgrade $http_upgrade;
   proxy_set_header Connection "Upgrade";
   proxy_set_header Host $host;
   proxy_read_timeout 36000s;
 }
}
```

**Importtant Note:** You can use IPv4 addresses of Collabora CODE and Nextcloud in VPN *(etc Wireguard, OpenVPN)*. 

## Jitsi Meet
### [Offical Installation Guide](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/#quick-start)
```bash
wget $(curl -s https://api.github.com/repos/jitsi/docker-jitsi-meet/releases/latest | grep 'zip' | cut -d\" -f4)
unzip <filename>
cp env.example .env
./gen-passwords.sh
mkdir -p ~/.jitsi-meet-cfg/{web,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}
```
change `PUBLIC_URL` in `.env`
after completing all steps `docker compose up -d` and you can acces the `Jitsi Meet` from `https://public-ip-address:8443`, if you want to use the `Jitsi Meet` with `Nextcloud` check the `.env` header.
### .env
```env
# shellcheck disable=SC2034

################################################################################
################################################################################
# Welcome to the Jitsi Meet Docker setup!
#
# This sample .env file contains some basic options to get you started.
# The full options reference can be found here:
# https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker
################################################################################
################################################################################


#
# Basic configuration options
#

# Directory where all configuration will be stored
CONFIG=~/.jitsi-meet-cfg

# Exposed HTTP port (will redirect to HTTPS port)
HTTP_PORT=80

# Exposed HTTPS port
HTTPS_PORT=443

# System time zone
TZ=UTC

# Public URL for the web service (required)
# Keep in mind that if you use a non-standard HTTPS port, it has to appear in the public URL
PUBLIC_URL=https://meet.domain.tld:${HTTPS_PORT}


# Enable Let's Encrypt certificate generation
ENABLE_LETSENCRYPT=1

# Domain for which to generate the certificate
LETSENCRYPT_DOMAIN=meet.domain.tld

# E-Mail for receiving important account notifications (mandatory)
LETSENCRYPT_EMAIL=info@domain.tld


# Set ACME server. Default is zerossl, you can peek one at https://github.com/acmesh-official/acme.sh/wiki/Server
#LETSENCRYPT_ACME_SERVER="letsencrypt"



#
# Authentication configuration (see handbook for details)
#

# Enable authentication (will ask for login and password to join the meeting)
ENABLE_AUTH=1

# Enable guest access (if authentication is enabled, this allows for users to be held in lobby until registered user lets them in)
ENABLE_GUESTS=1

# Select authentication type: internal, jwt, ldap or matrix
AUTH_TYPE=jwt

# JWT authentication
#

# Application identifier
JWT_APP_ID=skycloud

# Application secret known only to your token generator
JWT_APP_SECRET=jwt-secret-here

# (Optional) Set asap_accepted_issuers as a comma separated list
#JWT_ACCEPTED_ISSUERS=my_web_client,my_app_client

# (Optional) Set asap_accepted_audiences as a comma separated list
#JWT_ACCEPTED_AUDIENCES=my_server1,my_server2


#
# Security
#
# Set these to strong passwords to avoid intruders from impersonating a service account
# The service(s) won't start unless these are specified
# Running ./gen-passwords.sh will update .env with strong passwords
# You may skip the Jigasi and Jibri passwords if you are not using those
# DO NOT reuse passwords
#

# XMPP password for Jicofo client connections
JICOFO_AUTH_PASSWORD=auth-pass

# XMPP password for JVB client connections
JVB_AUTH_PASSWORD=auth-pass

# XMPP password for Jigasi MUC client connections
JIGASI_XMPP_PASSWORD=auth-pass

# XMPP password for Jigasi transcriber client connections
JIGASI_TRANSCRIBER_PASSWORD=auth-pass

# XMPP recorder password for Jibri client connections
JIBRI_RECORDER_PASSWORD=auth-pass

# XMPP password for Jibri client connections
JIBRI_XMPP_PASSWORD=auth-pass

#
# Docker Compose options
#

# Container restart policy
#RESTART_POLICY=unless-stopped

# Jitsi image version (useful for local development)
#JITSI_IMAGE_VERSION=latest
# Every attendant wait in loby until accepted.
ENABLE_LOBBY=1
```

### Nextcloud Integration
To install `Jitsi` app in nextcloud you can use Web UI > Apps > Jitsi Meet or command below
```bash
docker compose exec -it nextcloud-app php occ app:install jitsi
docker compose exec -it nextcloud-app php occ app:enable jitsi
```
