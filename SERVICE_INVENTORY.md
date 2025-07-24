# COMPLETE SERVICE INVENTORY & PORT ALLOCATION

## 📊 **AUDIT RESULTS**
- **Total Services**: 61
- **Empty/Incomplete**: 28 services
- **Has Content**: 33 services
- **Completion Rate**: 54%

## 🔧 **STANDARD SERVICE TEMPLATE**

```yaml
version: '3.8'

services:
  service_name:
    image: vendor/image:tag
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_service_name
    restart: unless-stopped
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TZ}
      # Service-specific environment variables
    ports:
      - "${SERVICE_PORT}:internal_port"
    volumes:
      - service_data:/data
      - service_config:/config
    networks:
      - category_network
    depends_on:
      - postgres  # if needed
      - redis     # if needed
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.service.rule=Host(`service.${DOMAIN}`)"
      - "traefik.http.services.service.loadbalancer.server.port=internal_port"

volumes:
  service_data:
  service_config:

networks:
  category_network:
    external: true
```

## 🌐 **NETWORK ARCHITECTURE**

### **Network Categories**
- `traefik_network` - Reverse proxy network
- `monitoring_network` - Prometheus, Grafana, exporters
- `logging_network` - Loki, Promtail, log processors
- `database_network` - PostgreSQL, MariaDB, Redis
- `media_network` - Jellyfin, Plex, PhotoPrism
- `automation_network` - N8N, Home Assistant
- `backup_network` - Duplicati, Kopia, Rclone
- `security_network` - Vaultwarden, Wazuh
- `dashboard_network` - Heimdall, Homepage, Organizr
- `utility_network` - FileBrowser, Syncthing
- `alert_network` - AlertManager, notification services
- `email_network` - MailHog, Postfix

## 📋 **COMPLETE PORT ALLOCATION PLAN**

### **Reserved Ports**
- `80` - Traefik HTTP
- `443` - Traefik HTTPS

### **Monitoring & Analytics (3000-3199)**
- `3000` - Grafana
- `3001` - Uptime Kuma
- `3100` - Loki
- `3110` - Grafana Agent

### **Databases (5400-5499)**
- `5432` - PostgreSQL
- `5433` - PgAdmin
- `5434` - MariaDB
- `6379` - Redis

### **Media Services (8000-8199)**
- `8096` - Jellyfin
- `8097` - PhotoPrism
- `8098` - Immich
- `32400` - Plex

### **Security & Authentication (8200-8299)**
- `8083` - Vaultwarden
- `8200` - Wazuh

### **Dashboards (8300-8399)**
- `8085` - Heimdall
- `8086` - Homepage
- `8087` - Organizr
- `8088` - Homar

### **Automation (5600-5699)**
- `5678` - N8N
- `8123` - Home Assistant

### **Backup Services (8400-8499)**
- `8200` - Duplicati
- `8201` - Kopia
- `8202` - Seafile

### **Utilities (8500-8599)**
- `8080` - FileBrowser
- `8384` - Syncthing
- `8081` - LibreSpeed

### **Networking (8600-8699)**
- `3080` - AdGuard Home
- `8080` - Dozzle
- `8082` - Gotify

### **Email Services (2500-2599)**
- `1025` - MailHog SMTP
- `8025` - MailHog Web
- `25` - Postfix

### **Logging (3200-3299)**
- `9200` - Elasticsearch
- `5601` - Kibana
- `9000` - Graylog

### **Monitoring Exporters (9000-9199)**
- `9090` - Prometheus
- `9100` - Node Exporter
- `9101` - Nginx Exporter
- `9102` - Redis Exporter
- `9115` - Blackbox Exporter
- `9091` - Push Gateway
- `8080` - cAdvisor

### **Alert Services (9200-9299)**
- `9093` - AlertManager
- `9094` - Discord Bot
- `9095` - Telegram Bot
- `9096` - NTFY

## 📁 **VOLUME REQUIREMENTS**

### **Standard Volumes Per Service**
- `{service}_data` - Application data
- `{service}_config` - Configuration files
- `{service}_logs` - Service logs (if needed)

### **Shared Volumes**
- `media_movies` - Movie files
- `media_tv` - TV show files
- `media_photos` - Photo collection
- `backup_storage` - Backup destination
- `shared_files` - Cross-service file sharing

## 🔐 **ENVIRONMENT VARIABLES REQUIRED**

### **Global Variables**
```bash
# Project Configuration
COMPOSE_PROJECT_NAME=alwazw_swarm
DOMAIN=alwazw.local
TZ=America/New_York
PUID=1000
PGID=1000

# Database Credentials
POSTGRES_DB=alwazw_db
POSTGRES_USER=alwazw
POSTGRES_PASSWORD=WaficWazzan!2
MYSQL_ROOT_PASSWORD=WaficWazzan!2
REDIS_PASSWORD=WaficWazzan!2

# Admin Credentials
GRAFANA_ADMIN_USER=alwazw
GRAFANA_ADMIN_PASSWORD=WaficWazzan!2
VAULTWARDEN_ADMIN_TOKEN=secure_token_here

# Media Paths
MEDIA_PATH_MOVIES=/data/media/movies
MEDIA_PATH_TV=/data/media/tv
MEDIA_PATH_PHOTOS=/data/media/photos

# Backup Paths
BACKUP_PATH=/data/backups
```

### **Service-Specific Ports**
```bash
# All service ports as defined above
GRAFANA_PORT=3000
PROMETHEUS_PORT=9090
JELLYFIN_PORT=8096
# ... (all 61 services)
```

## ✅ **PHASE 1 COMPLETION STATUS**
- [x] 1.1 Audit all 61 existing yml files and categorize by completeness
- [x] 1.2 Identify which files are empty/incomplete vs working  
- [x] 1.3 Create master service inventory with required ports, volumes, networks
- [x] 1.4 Define standard template for all service compose files
- [x] 1.5 Plan network architecture for service categories

**PHASE 1 COMPLETE - PROCEEDING TO PHASE 2**

