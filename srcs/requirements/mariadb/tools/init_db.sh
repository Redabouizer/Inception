#!/bin/bash

# Check if MariaDB data directory is initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB database..."
    
    # Initialize MariaDB data directory
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    
    # Start MariaDB temporarily to configure it
    mysqld_safe --datadir=/var/lib/mysql &
    
    # Wait for MariaDB to start
    until mysqladmin ping --silent; do
        echo "Waiting for MariaDB to start..."
        sleep 2
    done
    
    echo "MariaDB started. Configuring database..."
    
    # Secure installation and create database
    mysql -u root <<-EOSQL
        -- Secure the installation
        DELETE FROM mysql.user WHERE User='';
        DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
        DROP DATABASE IF EXISTS test;
        DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
        
        -- Set root password
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
        
        -- Create database
        CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
        
        -- Create user and grant privileges
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
        
        -- Flush privileges
        FLUSH PRIVILEGES;
EOSQL
    
    echo "Database configuration complete."
    
    # Stop the temporary MariaDB instance
    mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown
    
    echo "MariaDB initialization complete."
else
    echo "MariaDB database already initialized."
fi

# Execute the main command (CMD from Dockerfile)
exec "$@"
