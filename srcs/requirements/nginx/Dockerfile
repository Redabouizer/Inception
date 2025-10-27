FROM debian:bullseye

# Install NGINX and OpenSSL
RUN apt-get update && \
    apt-get install -y \
    nginx \
    openssl && \
    rm -rf /var/lib/apt/lists/*

# Create directories for SSL certificates
RUN mkdir -p /etc/nginx/ssl

# Generate self-signed SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=MA/ST=Khouribga/L=Khouribga/O=42Network/OU=rbouizer/CN=rbouizer.42.fr"

# Copy NGINX configuration
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/sites-available/default

# Create symbolic link
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Expose HTTPS port
EXPOSE 443

# Start NGINX in foreground
CMD ["nginx", "-g", "daemon off;"]
