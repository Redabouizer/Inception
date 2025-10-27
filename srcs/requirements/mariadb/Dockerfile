FROM debian:bullseye

# Install MariaDB server
RUN apt-get update && \
    apt-get install -y \
    mariadb-server \
    mariadb-client && \
    rm -rf /var/lib/apt/lists/*

# Create necessary directories
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld

# Copy configuration files
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy and set permissions for init script
COPY tools/init_db.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init_db.sh

# Expose MariaDB port
EXPOSE 3306

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/init_db.sh"]

# Run MariaDB in safe mode
CMD ["mysqld_safe"]
