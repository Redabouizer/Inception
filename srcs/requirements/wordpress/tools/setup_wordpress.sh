#!/bin/bash

set -e

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
until mysql -h mariadb -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SELECT 1" &>/dev/null; do
    echo "MariaDB is unavailable - sleeping"
    sleep 3
done
echo "MariaDB is up and running!"

# Navigate to WordPress directory
cd /var/www/html

# Check if WordPress is already installed
if [ ! -f "wp-config.php" ]; then
    echo "WordPress not found. Installing..."
    
    # Download WordPress
    wp core download --allow-root
    
    # Create wp-config.php
    wp config create \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb:3306 \
        --allow-root
    
    # Wait a bit for database to be fully ready
    sleep 5
    
    # Install WordPress
    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root
    
    # Create additional user
    wp user create \
        ${WP_USER} \
        ${WP_USER_EMAIL} \
        --role=editor \
        --user_pass="${WP_USER_PASSWORD}" \
        --allow-root
    
    # Set proper permissions
    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html
    
    echo "WordPress installation complete!"
else
    echo "WordPress already installed."
fi

# Execute the main command (CMD from Dockerfile)
exec "$@"