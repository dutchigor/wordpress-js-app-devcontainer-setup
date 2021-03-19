FROM wordpress:latest

# Install WP-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp

# Enable xdebug
COPY xdebug.ini /usr/local/etc/php/conf.d/
RUN pecl install "xdebug" && docker-php-ext-enable xdebug

# Prepare installation script
COPY wp-setup.sh /tmp
RUN chmod +x /tmp/wp-setup.sh \
  && mv /tmp/wp-setup.sh /usr/local/bin/wpsetup

USER www-data
