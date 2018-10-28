FROM debian:latest

RUN apt-get update && \
    apt-get -y install wget curl rsync openssh-client zip mysql-client cron
    
# owncloud related stuff
# https://doc.owncloud.org/server/8.1/admin_manual/installation/source_installation.html#prerequisites
RUN set -ex; \
	docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr; \
	debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)"; \
	docker-php-ext-configure ldap --with-libdir="lib/$debMultiarch"; \
	docker-php-ext-install -j "$(nproc)" \
		exif \
		gd \
		intl \
		ldap \
		mbstring \
		mcrypt \
		opcache \
		pcntl \
		pdo_mysql \
		pdo_pgsql \
		pgsql \
		zip

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# PECL extensions
RUN set -ex; \
	pecl install APCu-5.1.11; \
	pecl install memcached-3.0.4; \
	pecl install redis-3.1.6; \
	docker-php-ext-enable \
		apcu \
		memcached \
		redis

RUN rm -rf /var/lib/apt/lists/*

ADD startup.sh /startup.sh
RUN chmod +x /startup.sh

RUN mkdir /data

WORKDIR /data

CMD /startup.sh
