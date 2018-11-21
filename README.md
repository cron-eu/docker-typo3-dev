TYPO3-dev Docker Image
====

Abstract
----

TYPO3 Development Docker Image. This will use the official php:apache image
and configure it so TYPO3 runs fine.

Limitations
----

Currently only the TYPO3 Version 6.x is supported.

Usage
----

e.g. using Docker Compose

```
version: '2'

services:
  web:
    image: remuslazar/typo3-dev:6
    ports:
      - "8080:80"
    volumes:
      - /var/www
    links:
      - mysql:db
    environment:
      TYPO3_CONTEXT: Development
  ssh:
    image: remuslazar/typo3-dev-ssh:6
    volumes_from:
      - web
    ports:
      - "1122:22"
    links:
      - mysql:db
      - web:web
  mysql:
    image: mysql:5.5
    environment:
      MYSQL_DATABASE: intranet
      MYSQL_USER: intranet
      MYSQL_PASSWORD: "password"
      MYSQL_ALLOW_EMPTY_PASSWORD: 1
```

After `docker-compose up -d` access the volume inside the container, e.g using

```
docker-compose exec web /bin/bash
```

### Configure SSH

```
chown www-data /var/www
su - www-data
mkdir .ssh
echo "<your SSH pub key here" > .ssh/authorized_keys
chmod 600 .ssh/authorized_keys
exit
exit
```

Then you can access the data volume using SSH:

```
ssh -A -p 1122 www-data@$(docker-machine ip $DOCKER_MACHINE_NAME)
```

Development
----

```
docker build -t remuslazar/typo3-dev:6 .
```

Author
----

Remus Lazar (rl at cron dot eu)
