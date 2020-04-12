FROM php:7.4-fpm

RUN apt-get update && apt-get install -y wget gnupg
RUN wget -O - https://packagecloud.io/gpg.key | apt-key add -

RUN apt-get update && apt-get install -y \
    openssl \
    git \
    unzip \
    netcat \
    zlib1g-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libfreetype6-dev \
    libmemcached-dev \
    cron \
    wv \
    libgmp-dev \
    libzip-dev


# install gd
RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
RUN docker-php-ext-install gd

# Install Composer (needed for phpunit)
# TODO remove composer and try to NOT use symfony-phpunit bridge
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

# Type docker-php-ext-install to see available extensions
RUN docker-php-ext-install pdo pdo_mysql zip opcache exif gmp bcmath


# install xdebug
RUN pecl install xdebug
RUN pecl install apcu

RUN docker-php-ext-enable opcache apcu

# install intl
RUN apt-get update && apt-get install -y zlib1g-dev libicu-dev g++
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl

#RUN git clone https://github.com/php-memcached-dev/php-memcached /usr/src/php/ext/memcached \
#  && cd /usr/src/php/ext/memcached && git checkout -b php7 origin/php7 \
#  && docker-php-ext-configure memcached \
#  && docker-php-ext-install memcached

RUN set -ex \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y libmemcached-dev \
    && rm -rf /var/lib/apt/lists/* \
    && MEMCACHED="`mktemp -d`" \
    && curl -skL https://github.com/php-memcached-dev/php-memcached/archive/master.tar.gz | tar zxf - --strip-components 1 -C $MEMCACHED \
    && docker-php-ext-configure $MEMCACHED \
    && docker-php-ext-install $MEMCACHED \
    && rm -rf $MEMCACHED


ADD 98-php.ini /usr/local/etc/php/conf.d/98-php.ini
ADD 99-xdebug.ini /usr/local/etc/php/conf.d/99-xdebug.ini
