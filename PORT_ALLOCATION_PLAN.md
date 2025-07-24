# Comprehensive Port Allocation Plan

## 🚨 **RESERVED PORTS**
- **80**: Traefik HTTP (reverse proxy)
- **443**: Traefik HTTPS (reverse proxy)
- **22**: SSH (system)
- **53**: DNS (AdGuard Home)

## 📊 **PORT RANGES BY CATEGORY**

### **3000-3099: Analytics & Monitoring**
- 3000: Grafana
- 3001: Prometheus
- 3002: Uptime Kuma
- 3003: Metabase
- 3004: Apache Superset
- 3005: PostHog
- 3006: Plausible Analytics
- 3007: Grafana Agent HTTP
- 3008: Tempo HTTP
- 3009: Vector HTTP

### **5000-5099: Development & CI/CD**
- 5000: GitLab
- 5001: Gitea
- 5002: Jenkins
- 5003: Drone CI
- 5004: Registry (Docker)

### **6000-6099: Databases**
- 6379: Redis
- 6380: Redis Sentinel
- 5432: PostgreSQL
- 3306: MariaDB/MySQL
- 9200: Elasticsearch
- 27017: MongoDB (if added)

### **7000-7099: Communication**
- 7000: Rocket.Chat
- 7001: Mattermost
- 7002: Jitsi Meet
- 7003: BigBlueButton
- 7004: Element (Matrix)

### **8000-8099: Business Applications**
- 8000: Nextcloud
- 8001: SuiteCRM
- 8002: ERPNext
- 8003: Dolibarr
- 8004: Invoice Ninja
- 8005: Akaunting
- 8006: Firefly III

### **8100-8199: Project Management**
- 8100: OpenProject
- 8101: Taiga
- 8102: Kanboard
- 8103: Wekan
- 8104: Redmine

### **8200-8299: E-commerce**
- 8200: WooCommerce
- 8201: Magento
- 8202: PrestaShop
- 8203: Shopware
- 8204: OpenCart

### **8300-8399: Knowledge Management**
- 8300: BookStack
- 8301: DokuWiki
- 8302: Outline
- 8303: TiddlyWiki
- 8304: MediaWiki

### **8400-8499: Learning Management**
- 8400: Moodle
- 8401: Canvas LMS
- 8402: Open edX
- 8403: Chamilo

### **8500-8599: Utilities & Tools**
- 8500: File Browser
- 8501: Syncthing
- 8502: Immich
- 8503: PhotoPrism
- 8504: Duplicati
- 8505: Portainer

### **8600-8699: Security & Admin**
- 8600: Vaultwarden
- 8601: Wazuh Dashboard
- 8602: pgAdmin
- 8603: phpMyAdmin
- 8604: Adminer

### **8700-8799: Automation & Workflows**
- 8700: n8n
- 8701: Huginn
- 8702: Apache Airflow
- 8703: Node-RED

### **8800-8899: Email & Communication**
- 8800: Roundcube
- 8801: MailHog
- 8802: Postfix Admin
- 8803: Mail-in-a-Box

### **8900-8999: Media & Content**
- 8900: Jellyfin
- 8901: Plex (if kept)
- 8902: Photoprism
- 8903: Immich

### **9000-9099: Monitoring & Logging**
- 9000: Portainer
- 9001: Loki
- 9002: Grafana Loki
- 9003: Kibana
- 9004: Graylog
- 9005: Dozzel

### **9100-9199: Networking & Proxy**
- 9100: Node Exporter
- 9101: Blackbox Exporter
- 9102: cAdvisor
- 9103: Nginx Exporter
- 9104: Redis Exporter

### **9200-9299: Alerts & Notifications**
- 9200: AlertManager
- 9201: ntfy
- 9202: Gotify
- 9203: Apprise

## 🔧 **TRAEFIK CONFIGURATION STRATEGY**

### **Subdomain Strategy** (Recommended for Business)
```yaml
# Example routing
- grafana.yourdomain.com → grafana:3000
- crm.yourdomain.com → suitecrm:8001
- files.yourdomain.com → nextcloud:8000
- chat.yourdomain.com → rocketchat:7000
```

### **Path-based Strategy** (Alternative)
```yaml
# Example routing
- yourdomain.com/grafana → grafana:3000
- yourdomain.com/crm → suitecrm:8001
- yourdomain.com/files → nextcloud:8000
```

## 📋 **ENVIRONMENT VARIABLE UPDATES**

### **Core Infrastructure**
```env
# Reverse Proxy
TRAEFIK_HTTP_PORT=80
TRAEFIK_HTTPS_PORT=443
TRAEFIK_DASHBOARD_PORT=8080

# DNS
ADGUARD_DNS_PORT=53
ADGUARD_WEB_PORT=3010

# Databases
POSTGRES_PORT=5432
MYSQL_PORT=3306
REDIS_PORT=6379
```

### **Business Applications**
```env
# Core Business
NEXTCLOUD_PORT=8000
SUITECRM_PORT=8001
ERPNEXT_PORT=8002
INVOICE_NINJA_PORT=8004

# Communication
ROCKETCHAT_PORT=7000
MATTERMOST_PORT=7001
JITSI_PORT=7002

# Project Management
OPENPROJECT_PORT=8100
TAIGA_PORT=8101
KANBOARD_PORT=8102
```

### **Analytics & Monitoring**
```env
# Analytics
GRAFANA_PORT=3000
PROMETHEUS_PORT=3001
UPTIME_KUMA_PORT=3002
METABASE_PORT=3003

# Monitoring
PORTAINER_PORT=9000
LOKI_PORT=9001
KIBANA_PORT=9004
```

## 🛡️ **SECURITY CONSIDERATIONS**

### **Internal Only Ports** (Behind Traefik)
- Database ports (3306, 5432, 6379)
- Monitoring exporters (9100-9199)
- Internal APIs

### **Public Facing** (Through Traefik)
- All business applications (8000-8999)
- Communication tools (7000-7099)
- Analytics dashboards (3000-3099)

### **Admin Access Only**
- Traefik dashboard (8080)
- Portainer (9000)
- Database admin tools (8600-8699)

## 🔄 **MIGRATION STRATEGY**

### **Phase 1**: Update .env file with new port assignments
### **Phase 2**: Deploy Traefik as reverse proxy
### **Phase 3**: Update all service configurations
### **Phase 4**: Test each service through Traefik
### **Phase 5**: Update DNS/domain configurations

This port allocation ensures no conflicts, proper organization, and scalability for business deployment.

