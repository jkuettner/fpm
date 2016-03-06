FROM debian:jessie

ENV TERM xterm

EXPOSE 9000

RUN apt-get update \
    && apt-get install -y wget

RUN cd /tmp \
    && wget https://www.dotdeb.org/dotdeb.gpg \
    && apt-key add dotdeb.gpg \
    && rm dotdeb.gpg \
    && apt-get purge -y wget

RUN echo "deb http://packages.dotdeb.org jessie all" > /etc/apt/sources.list.d/dotdeb.list \
    && echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list.d/dotdeb.list

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        php7.0-fpm \
        php7.0-apcu \
        php7.0-apcu-bc \
        php7.0-gd \
        php7.0-curl \
        php7.0-mysql \
        php7.0-mcrypt \
        php7.0-imap \
        php7.0-imagick \
        php7.0-json \
        php7.0-mongodb \
        php7.0-pgsql \
        php7.0-xmlrpc \
    && apt-get clean all

VOLUME ["/www"]

ADD fpm.conf /fpm/
ADD pools/*.conf /fpm/pools/
ADD php/*.ini /tmp/php_settings/

RUN grep -hEv "^;|^$" \
    /etc/php/7.0/fpm/php.ini \
    /etc/php/7.0/fpm/conf.d/*.ini \
    /tmp/php_settings/*.ini \
    | awk '!a[$0]++' \
    > /fpm/php.ini

RUN rm -r /tmp/php_settings /etc/php/7.0/fpm/conf.d/*.ini

RUN useradd -d /fpm -b /fpm -u 10000 -g nogroup -s /bin/bash fpm \
    && chown fpm:nogroup -R /fpm

USER fpm

CMD ["/usr/sbin/php-fpm7.0", "--nodaemonize", "--force-stderr", "--fpm-config", "/fpm/fpm.conf", "-c", "/fpm/php.ini"]
