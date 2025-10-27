FROM debian:bullseye

# Install PHP-FPM and required extensions
RUN apt-get update && \
    apt-get install -y \
    php8.2 \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-gd \
    php8.2-curl \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-zip \
    php8.2-intl \
    php8.2-bcmath \
    wget \
    curl \
    mariadb-client && \
    rm -rf /var/lib/apt/lists/*

# Download and install WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Configure PHP-FPM
RUN mkdir -p /run/php && \
    sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 9000/g' /etc/php/8.2/fpm/pool.d/www.conf && \
    sed -i 's/;clear_env = no/clear_env = no/g' /etc/php/8.2/fpm/pool.d/www.conf

# Copy WordPress setup script
COPY tools/setup_wordpress.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup_wordpress.sh

# Set working directory
WORKDIR /var/www/html

# Expose PHP-FPM port
EXPOSE 9000

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/setup_wordpress.sh"]

# Run PHP-FPM
CMD ["php-fpm8.2", "-F"]
