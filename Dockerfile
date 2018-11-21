FROM php:5.6-apache-stretch

RUN apt-get update \
 && apt-get -y install curl zip unzip libgd-dev graphicsmagick libxml2-dev libjpeg-dev libpng-dev libmcrypt-dev libfreetype6-dev \
 && docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-freetype-dir=/usr/include/freetype2 \
        --with-png-dir=/usr/include \
        --with-jpeg-dir=/usr/include \
 && docker-php-ext-install gd \
 && docker-php-ext-install mysqli \
 && docker-php-ext-install soap \
 && docker-php-ext-install zip \
 && rm -rf /var/lib/apt/lists/*

# Use the default development configuration
RUN mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini

# Override with custom settings
COPY php-typo3-config.ini $PHP_INI_DIR/conf.d/

ENV TYPO3_CONTEXT Development
