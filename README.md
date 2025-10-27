# Inception

**Project by:** Reda Bouizergane (rbouizer)  
**42 Network - System Administration Project**

## 📋 Description

Inception is a system administration project that involves setting up a small infrastructure using Docker and Docker Compose. The project consists of multiple services running in separate containers:

- **NGINX** - Web server with TLSv1.2/1.3 support
- **WordPress** - Content Management System with php-fpm
- **MariaDB** - Database server

## 🏗️ Architecture

```
┌─────────────────────────────────────────┐
│         NGINX (Port 443)                │
│         TLSv1.2/1.3 Only                │
└─────────────┬───────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────┐
│      WordPress + PHP-FPM (Port 9000)    │
└─────────────┬───────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────┐
│         MariaDB (Port 3306)             │
└─────────────────────────────────────────┘
```

## 📁 Project Structure

```
Inception/
├── Makefile
├── README.md
└── srcs/
    ├── docker-compose.yml
    ├── .env
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/
        │   │   └── 50-server.cnf
        │   └── tools/
        │       └── init_db.sh
        ├── nginx/
        │   ├── Dockerfile
        │   └── conf/
        │       ├── nginx.conf
        │       └── default.conf
        └── wordpress/
            ├── Dockerfile
            └── tools/
                └── setup_wordpress.sh
```

## 🚀 Getting Started

### Prerequisites

- Virtual Machine (Linux-based)
- Docker and Docker Compose installed
- Make installed

### Installation

1. **Clone the repository:**
   ```bash
   git clone <your-repo-url>
   cd Inception
   ```

2. **Configure your environment:**
   
   Edit `srcs/.env` file with your credentials:
   ```bash
   DOMAIN_NAME=rbouizer.42.fr
   MYSQL_ROOT_PASSWORD=your_root_password
   MYSQL_USER=your_db_user
   MYSQL_PASSWORD=your_db_password
   # ... etc
   ```

3. **Add domain to hosts file:**
   ```bash
   sudo nano /etc/hosts
   ```
   Add the line:
   ```
   127.0.0.1    rbouizer.42.fr
   ```

4. **Create data directories:**
   ```bash
   sudo mkdir -p /home/rbouizer/data/wordpress
   sudo mkdir -p /home/rbouizer/data/mariadb
   ```

5. **Build and start the project:**
   ```bash
   make
   ```

## 🛠️ Makefile Commands

| Command | Description |
|---------|-------------|
| `make` or `make all` | Create directories and start all containers |
| `make build` | Build all Docker images |
| `make up` | Start all containers |
| `make down` | Stop all containers |
| `make clean` | Stop and remove containers, networks, and volumes |
| `make fclean` | Complete cleanup including data directories |
| `make re` | Rebuild everything from scratch |
| `make status` | Show container status |
| `make logs` | Show all container logs |
| `make logs-nginx` | Show NGINX logs |
| `make logs-wordpress` | Show WordPress logs |
| `make logs-mariadb` | Show MariaDB logs |

## 🔐 Security Features

- ✅ TLSv1.2/1.3 only for NGINX
- ✅ No passwords in Dockerfiles
- ✅ Environment variables for sensitive data
- ✅ Self-signed SSL certificate
- ✅ Secure MariaDB installation
- ✅ Non-root database user
- ✅ Proper file permissions

## 🌐 Access

After successful setup, access your WordPress site at:

**https://rbouizer.42.fr**

### Default Credentials

**WordPress Admin:**
- Username: `rbouizer`
- Password: (from `.env` file)

**WordPress Editor:**
- Username: `editor`
- Password: (from `.env` file)

## 📊 Volumes

The project uses two persistent volumes:

1. **MariaDB Data:** `/home/rbouizer/data/mariadb`
2. **WordPress Files:** `/home/rbouizer/data/wordpress`

## 🔍 Troubleshooting

### Check container status:
```bash
make status
```

### View logs:
```bash
make logs
```

### Restart everything:
```bash
make re
```

### Check if services are running:
```bash
docker ps
```

### Test database connection:
```bash
docker exec -it mariadb mysql -u wpuser -p
```

### Test WordPress PHP-FPM:
```bash
docker exec -it wordpress php-fpm8.2 -t
```

## 📝 Project Requirements Checklist

- ✅ Virtual Machine setup
- ✅ Docker Compose configuration
- ✅ Custom Dockerfiles for each service
- ✅ NGINX with TLSv1.2/1.3 only
- ✅ WordPress with php-fpm
- ✅ MariaDB database
- ✅ Two persistent volumes
- ✅ Docker network connecting containers
- ✅ Automatic container restart
- ✅ No infinite loops in containers
- ✅ Two database users (non-admin)
- ✅ Domain name configuration
- ✅ Environment variables for configuration
- ✅ No passwords in Dockerfiles
- ✅ NGINX as only entry point on port 443

## 📚 Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [WordPress Documentation](https://wordpress.org/support/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [MariaDB Documentation](https://mariadb.org/documentation/)

## 👤 Author

**Reda Bouizergane**
- 42 Intra: rbouizer
- Project: Inception (42 Network)

## 📄 License

This project is part of the 42 Network curriculum.

---

**Note:** This project is for educational purposes as part of the 42 School curriculum. Make sure to use strong, unique passwords in production environments.
# Inception
