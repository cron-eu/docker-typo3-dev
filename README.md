TYPO3-dev Docker Image
====

Abstract
----

TYPO3 Development Docker Image. This will use the official php:apache image
and configure it so TYPO3 runs fine.

Limitations
----

Currently only the TYPO3 Version 6.x is supported.

Conventions
----

* `/var/www` is the data volume (shared by the web and ssh container)
* Web-Root is `/var/www/app/src`

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
  mysql:
    image: mysql:5.5
    environment: &dbenvironment
      MYSQL_HOST: db
      MYSQL_DATABASE: app
      MYSQL_USER: app
      MYSQL_PASSWORD: "my-secure-password-here"
      MYSQL_ALLOW_EMPTY_PASSWORD: 1
  ssh:
    image: remuslazar/typo3-dev-ssh:6
    environment:
      <<: *dbenvironment
      IMPORT_GITHUB_PUB_KEYS: ${IMPORT_GITHUB_PUB_KEYS}
      AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID}
      AWS_SECRET_ACCESS_KEY: ${AWS_SECRET_ACCESS_KEY}
      AWS_DEFAULT_REGION: eu-central-1
    volumes_from:
      - web
    ports:
      - "1122:22"
    links:
      - mysql:db
      - web:web
```

### configure.sh

```
docker-compose exec ssh configure.sh
```

This will configure

* SSH access will be configured for the GitHub User(s) configured in the
`IMPORT_GITHUB_PUB_KEYS` env var (multiple users can be separated by ,).
* AWS cli (using the AWS_* environment vars)
* `/etc/my.cnf` for easy mysql access using e.g. the `mysql` cli.

### SSH access

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
