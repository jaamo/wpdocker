# Starting point.
FROM php:7.2-fpm
LABEL maintainer="Hotomolo"

# install the PHP extensions we need
# from wordpress:5.1-php7.2-fpm
RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    libjpeg-dev \
    libpng-dev \
    nginx \
    supervisor \
    gnupg \
    subversion \
    git \
    ; \
    \
    docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
    docker-php-ext-install gd mysqli zip; \
    \
    rm -rf /var/lib/apt/lists/*

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# nginx configs
# COPY ./configs/nginx/default.conf /etc/nginx/conf.d/default.conf
# COPY ./configs/nginx/nginx.conf /etc/nginx/nginx.conf
# COPY ./configs/nginx/conf /etc/nginx
COPY ./nginx.conf /etc/nginx/sites-available/default

# supervisor configs
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Custom PHP configurations
# COPY ./configs/php.ini /usr/local/etc/php

WORKDIR /var/www/html/

# Frickin' permissions
# RUN chown -R www-data:www-data /var/www/html/wordpress
# RUN find . -type d -exec chmod 755 {} \;
# RUN find . -type f -exec chmod 644 {} \;

EXPOSE 80 443
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]