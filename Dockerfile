FROM ubuntu:22.04

#ENV COMPOSER_ALLOW_SUPERUSER=1

RUN apt update && \
    apt install -y nginx curl net-tools wget software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    apt update && \
    apt install -y php8.2-fpm php8.2-xml php8.2-common php8.2-cli php8.2-mysql php8.2-pgsql php8.2-redis && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    chmod +x /usr/local/bin/composer

COPY . /var/www/app

RUN chmod -R 777 /var/www/app

WORKDIR /var/www/app

RUN composer install --ignore-platform-reqs

COPY ./default /etc/nginx/sites-enabled

CMD service php8.2-fpm start && nginx -g "daemon off;"
