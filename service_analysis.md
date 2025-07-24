# Docker Swarm Service Analysis

## Current Stack Categories and Services

### 1. Alerts (5 services)
- alert_manager - Prometheus alerting component
- discord_bot - Discord notifications
- notification_aggregator - Centralized notification management
- ntfy - Simple notification service
- telegram_bot - Telegram notifications

**Analysis**: Multiple notification services - could consolidate to 1-2 main ones.

### 2. Analytics (1 service)
- grafana - Data visualization and monitoring dashboards

**Analysis**: Good, single service for analytics.

### 3. Automation (2 services)
- home_assistant - Home automation platform
- n8n - Workflow automation

**Analysis**: Both serve different purposes, keep both.

### 4. Backup (5 services)
- duplicati - Cross-platform backup
- kopia - Fast and secure backup
- rclone - Cloud storage sync
- resilo_sync - P2P file sync
- seafile - File hosting platform

**Analysis**: Too many backup solutions. Recommend keeping 2-3 max (duplicati, rclone, kopia).

### 5. Dashboards (4 services)
- heimdall - Application dashboard
- homar - Modern dashboard
- homepage - Customizable homepage
- organizr - Service organizer

**Analysis**: Multiple dashboard services doing similar things. Recommend keeping 1-2 max.

### 6. Database (4 services) ✅ CURRENTLY WORKING
- mariadb - MySQL-compatible database
- pgadmin - PostgreSQL administration
- postgres - PostgreSQL database
- redis - In-memory data store

**Analysis**: Good mix of database services, all serve different purposes.

### 7. Emails (2 services)
- mailhog - Email testing tool
- postfix - Mail transfer agent

**Analysis**: Both useful for different purposes, keep both.

### 8. Logging (10 services)
- dozzel - Docker log viewer
- elasticsearch - Search and analytics engine
- filebat - Log file processor
- fluent_bit - Log processor and forwarder
- graylog - Log management
- kibana - Elasticsearch visualization
- logrotate - Log rotation utility
- loki - Log aggregation system
- promtail - Log shipping agent
- vector - Data pipeline tool

**Analysis**: Too many logging solutions. ELK stack (elasticsearch + kibana) OR Loki + promtail would be sufficient.

### 9. Media (2 services)
- jellyfin - Media server
- plex - Media server

**Analysis**: Both do the same thing. Choose one (jellyfin is open source, plex has better features).

### 10. Monitoring (9 services)
- blackbox_exporter - Prometheus exporter for endpoints
- cadvisor - Container metrics
- docker_socket_proxy - Secure Docker API access
- nginx_exporter - Nginx metrics
- node_exporter - System metrics
- prometheus - Monitoring system
- push_gateway - Prometheus push gateway
- redis_exporter - Redis metrics
- uptime_kuma - Uptime monitoring

**Analysis**: Good monitoring stack, most are complementary. Could reduce exporters based on actual needs.

### 11. Networking (7 services)
- adguard_home - DNS ad blocker
- apprise - Notification service
- cloudflared - Cloudflare tunnel ✅ CURRENTLY WORKING
- gotify - Notification server
- librespeed - Speed test server
- webhook-relay - Webhook forwarding
- whoami - Service identification

**Analysis**: Some overlap with notification services. Consolidate notification services.

### 12. Nextcloud (1 service) ✅ CURRENTLY WORKING
- nextcloud - File sharing and collaboration

**Analysis**: Single service, good.

### 13. Security (2 services)
- vaultwarden - Password manager
- wazuh - Security monitoring

**Analysis**: Both serve different security purposes, keep both.

### 14. Utilities (5 services)
- filebrowser - Web file manager
- immich - Photo management
- librespeed - Speed test (duplicate from networking)
- photoprism - Photo management
- syncthing - File synchronization

**Analysis**: Duplicate librespeed, two photo management solutions (choose one).

## Recommendations

### Services to Remove/Consolidate:
1. **Dashboards**: Keep only heimdall or homepage
2. **Backup**: Remove resilo_sync and seafile, keep duplicati + rclone + kopia
3. **Logging**: Choose either ELK stack OR Loki+promtail, remove others
4. **Media**: Choose either jellyfin OR plex
5. **Notifications**: Consolidate to ntfy + one bot (discord or telegram)
6. **Photo Management**: Choose either immich OR photoprism
7. **Remove duplicate**: librespeed (exists in both networking and utilities)

### Suggested New Stack Organization:
- **Core Infrastructure**: database, networking, security
- **Monitoring & Analytics**: monitoring, analytics, logging (consolidated)
- **Applications**: nextcloud, media, automation
- **Management**: dashboards, utilities, backup (consolidated)
- **Communications**: alerts (consolidated), emails

