FROM php:7.1-fpm

RUN apt-get update && apt-get install -y libssh-dev

RUN curl http://packages.dns.ad.zopa.com/artifactory/tools-dev-local/ZscalerRootCertificate-2048-SHA256.crt -o /usr/local/share/ca-certificates/ZscalerRootCertificate-2048-SHA256.crt \
&& update-ca-certificates \
&& pecl install xdebug \
&& pecl install mongodb \
&& cd /tmp \
&& curl --insecure -L https://github.com/phalcon/cphalcon/archive/v3.2.3.tar.gz | tar xz \
&& cd cphalcon-3.2.3/build \
&& ./install \
&& docker-php-ext-enable xdebug mongodb phalcon




