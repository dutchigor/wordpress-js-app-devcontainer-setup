FROM wordpress:latest

# Install WP-cli and grant access to WordPress
RUN chown www-data:www-data /var/www \
  && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp

# Enable xdebug
RUN pecl install "xdebug" && docker-php-ext-enable xdebug

# Prepare initialisation script
RUN apt-get -q update && apt-get -qy install netcat
ADD https://github.com/eficode/wait-for/releases/download/v2.1.1/wait-for /usr/local/bin/
COPY wp-setup.sh /usr/local/bin/wpsetup
RUN chmod +x /usr/local/bin/wpsetup \
  && chmod +rx /usr/local/bin/wait-for

# prepare for CLI execution
USER www-data
