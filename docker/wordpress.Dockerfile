FROM wordpress:latest

# Set php parameters
COPY php.wp.ini /usr/local/etc/php/conf.d/

# Enable xdebug
COPY xdebug.ini /usr/local/etc/php/conf.d/
RUN pecl install "xdebug" && docker-php-ext-enable xdebug

# Set default user
USER www-data
