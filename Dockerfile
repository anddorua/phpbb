# phpBB Dockerfile

FROM php:5.6-apache

MAINTAINER Sebastian Tschan <mail@blueimp.net>

# Do a dist-upgrade and install the required packages:
RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get dist-upgrade -y \
  && apt-get install --no-install-recommends --no-install-suggests -y \
    libpng-dev \
    libjpeg-dev \
    imagemagick \
    jq \
    bzip2 \
  # Install required PHP extensions:
  && docker-php-ext-configure \
    gd --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install \
    gd \
    mysqli \
  # Uninstall obsolete packages:
  && apt-get autoremove -y \
    libpng-dev \
    libjpeg-dev \
  # Remove obsolete files:
  && apt-get clean \
  && rm -rf \
    /tmp/* \
    /usr/share/doc/* \
    /var/cache/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# Enable the Apache Rewrite module:
RUN ln -s /etc/apache2/mods-available/rewrite.load \
  /etc/apache2/mods-enabled/rewrite.load

# Enable the Apache Headers module:
RUN ln -s /etc/apache2/mods-available/headers.load \
  /etc/apache2/mods-enabled/headers.load

# Add a custom Apache config:
COPY apache.conf /etc/apache2/conf-enabled/custom.conf

# Add the PHP config file:
COPY php.ini /usr/local/etc/php/

# Add the custom Apache run script
# and a script to download and extract the latest stable phpBB version:
COPY bin /usr/local/bin

RUN mkdir -p /var/www/html/files /var/www/html/store /var/www/html/images/avatars/upload

# Expose the phpBB upload directories as volumes:
VOLUME /var/www/html

ENV \
  DBHOST=mysql \
  DBPORT= \
  DBNAME=phpbb \
  DBUSER=phpbb \
  DBPASSWD= \
  TABLE_PREFIX=phpbb_

CMD ["phpbb-apache2"]
