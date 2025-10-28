#!/bin/bash

set -e

# Check if MariaDB data directory is initialized AND configured
if [ ! -f "/var/lib/mysql/.initialized" ]; then
    echo "Initializing MariaDB database..."
    
    # Initialize MariaDB data directory if needed
    if [ ! -d "/var/lib/mysql/mysql" ]; then
        mysql_install_db --user=mysql --datadir=/var/lib/mysql
    fi
    
    # Start MariaDB temporarily to configure it
    mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking=0 --bind-address=0.0.0.0 &
    MYSQL_PID=$!
    
    # Wait for MariaDB to start
    echo "Waiting for MariaDB to start..."
    for i in {30..0}; do
        if mysqladmin ping --silent 2>/dev/null; then
            break
        fi
        echo "MariaDB is unavailable - sleeping"
        sleep 1
    done
    
    if [ "$i" = 0 ]; then
        echo "MariaDB failed to start"
        exit 1
    fi
    
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
    
    # Create marker file
    touch /var/lib/mysql/.initialized
    
    # Stop the temporary MariaDB instance
    if ! kill -s TERM "$MYSQL_PID" || ! wait "$MYSQL_PID"; then
        echo "MariaDB shutdown failed"
        exit 1
    fi
    
    echo "MariaDB initialization complete."
else
    echo "MariaDB database already initialized. Skipping setup."
fi

echo "Starting MariaDB server..."

# Execute the main command (CMD from Dockerfile)
exec "$@"
