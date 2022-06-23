FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=US/Central

RUN apt-get update \
    && apt-get install -y supervisor vim iputils-ping

RUN apt-get -y install software-properties-common \
    && add-apt-repository ppa:ondrej/php \
    && apt-get update \
	&& apt-get -y install php7.4

RUN apt-get install -y php7.4-bcmath php7.4-bz2 php7.4-intl php7.4-gd php7.4-mbstring php7.4-mysql php7.4-zip php7.4-common \
    && apt-get install -y nginx php7.4-fpm

WORKDIR /var/www/siteapp
COPY index.html index.html
COPY info.php info.php

WORKDIR /etc/nginx/sites-enabled
COPY siteapp siteapp
RUN rm default

WORKDIR /root

COPY run_php_fpm.sh .
RUN chmod +x run_php_fpm.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80 443

CMD ["/usr/bin/supervisord"]
