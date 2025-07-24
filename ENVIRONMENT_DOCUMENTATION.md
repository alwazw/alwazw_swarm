# Environment Configuration Documentation

## 📋 **Overview**

This document explains the environment configuration for the Docker Swarm business stack. The configuration is organized into logical categories with dedicated port ranges for easy management and scalability.

## 📁 **File Structure**

```
├── .env.alwazw          # Your customized configuration (KEEP SECURE)
├── .env.example         # Template for new deployments
├── .env                 # Current active configuration (symlink to .env.alwazw)
└── secrets/             # Directory for sensitive passwords
    ├── postgres_password.txt
    ├── mysql_root_password.txt
    ├── mysql_user_password.txt
    ├── redis_password.txt
    ├── grafana_password.txt
    ├── pgadmin_password.txt
    ├── nextcloud_admin_password.txt
    └── authentik_bootstrap_password.txt
```

## 🔧 **Setup Instructions**

### **1. Initial Setup**
```bash
# Copy your customized environment file
cp .env.alwazw .env

# Create secrets directory if it doesn't exist
mkdir -p secrets

# Set proper permissions
chmod 600 .env.alwazw
chmod 700 secrets/
```

### **2. Create Secret Files**
```bash
# Create password files (replace with your actual passwords)
echo "WaficWazzan!2" > secrets/postgres_password.txt
echo "WaficWazzan!2" > secrets/mysql_root_password.txt
echo "WaficWazzan!2" > secrets/mysql_user_password.txt
echo "WaficWazzan!2" > secrets/redis_password.txt
echo "WaficWazzan!2" > secrets/grafana_password.txt
echo "WaficWazzan!2" > secrets/pgadmin_password.txt
echo "WaficWazzan!2" > secrets/nextcloud_admin_password.txt
echo "WaficWazzan!2" > secrets/authentik_bootstrap_password.txt

# Set proper permissions
chmod 600 secrets/*.txt
```

## 🌐 **Port Organization**

### **Reserved Ports (DO NOT USE)**
- **80**: HTTP (Traefik reverse proxy)
- **443**: HTTPS (Traefik reverse proxy)
- **22**: SSH (system)
- **53**: DNS (AdGuard Home)

### **Port Ranges by Category**

| Range | Category | Examples |
|-------|----------|----------|
| 3000-3099 | Analytics & Monitoring | Grafana (3000), Prometheus (3001) |
| 5000-5099 | Development & CI/CD | GitLab (5000), Gitea (5001) |
| 6000-6099 | Databases | PostgreSQL (5432), MySQL (3306) |
| 7000-7099 | Communication | Rocket.Chat (7000), Jitsi (7002) |
| 8000-8099 | Business Applications | Nextcloud (8000), CRM (8001) |
| 8100-8199 | Project Management | OpenProject (8100), Taiga (8101) |
| 8200-8299 | E-commerce | WooCommerce (8200), Magento (8201) |
| 8300-8399 | Knowledge Management | BookStack (8300), Wiki (8301) |
| 8400-8499 | Learning Management | Moodle (8400), Canvas (8401) |
| 8500-8599 | Utilities & Tools | File Browser (8500), Syncthing (8501) |
| 8600-8699 | Security & Admin | Vaultwarden (8600), pgAdmin (8601) |
| 8700-8799 | Automation | n8n (8700), Airflow (8702) |
| 8800-8899 | Email Services | Roundcube (8800), MailHog (8801) |
| 8900-8999 | Media & Content | Jellyfin (8900), Plex (32400) |
| 9000-9199 | Monitoring & Logging | Portainer (9000), Exporters (9100+) |
| 9200-9299 | Alerts & Notifications | AlertManager (9200), ntfy (9201) |
| 9300-9399 | Networking & Proxy | LibreSpeed (9300), Whoami (9301) |

## 🔐 **Security Configuration**

### **Password Management**
- **Secrets Directory**: All sensitive passwords stored in `secrets/` directory
- **File Permissions**: 600 for files, 700 for directory
- **Environment Variables**: Only non-sensitive configuration in .env files

### **Token Management**
- **Cloudflare Tunnel**: Configured for secure external access
- **Application Tokens**: Unique tokens for each service
- **API Keys**: Stored securely and rotated regularly

### **SSL/TLS Configuration**
- **Let's Encrypt**: Automatic SSL certificate generation
- **Traefik**: Handles all SSL termination
- **HTTPS Redirect**: Automatic HTTP to HTTPS redirection

## 🏗️ **Service Categories**

### **Core Infrastructure**
- **Traefik**: Reverse proxy and SSL termination
- **AdGuard Home**: DNS filtering and ad blocking
- **Cloudflared**: Secure tunnel for external access

### **Monitoring Stack**
- **Grafana**: Dashboards and visualization
- **Prometheus**: Metrics collection and storage
- **Grafana Agent**: Lightweight telemetry collector
- **Loki**: Log aggregation and storage
- **Uptime Kuma**: Simple uptime monitoring

### **Database Services**
- **PostgreSQL**: Primary relational database
- **MariaDB/MySQL**: Alternative relational database
- **Redis**: In-memory data store and cache

### **Business Applications**
- **Nextcloud**: File sharing and collaboration
- **SuiteCRM**: Customer relationship management
- **Invoice Ninja**: Invoicing and billing
- **OpenProject**: Project management

### **Communication Tools**
- **Rocket.Chat**: Team communication
- **Jitsi Meet**: Video conferencing
- **Email Stack**: Postfix, Roundcube, MailHog

### **Development Tools**
- **GitLab**: Complete DevOps platform
- **n8n**: Workflow automation
- **Portainer**: Container management

## 🔄 **Deployment Workflow**

### **Phase 1: Core Infrastructure**
1. Deploy Traefik (reverse proxy)
2. Deploy AdGuard Home (DNS)
3. Deploy monitoring stack (Grafana, Prometheus)
4. Deploy databases (PostgreSQL, Redis)

### **Phase 2: Business Core**
1. Deploy Nextcloud (file sharing)
2. Deploy communication tools
3. Deploy project management
4. Deploy CRM system

### **Phase 3: Advanced Services**
1. Deploy e-commerce platform
2. Deploy learning management
3. Deploy automation tools
4. Deploy specialized services

### **Phase 4: Integration & Testing**
1. Configure service integrations
2. Set up monitoring and alerting
3. Test all service connectivity
4. Optimize performance

## 📊 **Resource Requirements**

### **Minimum Requirements**
- **RAM**: 8GB (for basic stack)
- **CPU**: 4 cores
- **Storage**: 100GB SSD
- **Network**: 100Mbps

### **Recommended Requirements**
- **RAM**: 16GB (for full stack)
- **CPU**: 8 cores
- **Storage**: 500GB SSD
- **Network**: 1Gbps

### **Enterprise Requirements**
- **RAM**: 32GB+ (for multiple clients)
- **CPU**: 16+ cores
- **Storage**: 1TB+ NVMe SSD
- **Network**: 10Gbps

## 🛠️ **Maintenance Tasks**

### **Daily**
- Monitor service health
- Check log files for errors
- Verify backup completion

### **Weekly**
- Update container images
- Review resource usage
- Check SSL certificate status

### **Monthly**
- Rotate passwords and tokens
- Update documentation
- Performance optimization review

### **Quarterly**
- Security audit
- Disaster recovery testing
- Capacity planning review

## 🚨 **Troubleshooting**

### **Common Issues**
1. **Port Conflicts**: Check port allocation table
2. **Permission Errors**: Verify file permissions
3. **SSL Issues**: Check Traefik configuration
4. **Database Connections**: Verify credentials in secrets/

### **Log Locations**
- **Docker Logs**: `docker logs <container_name>`
- **Traefik Logs**: Available through dashboard
- **Application Logs**: Service-specific locations

### **Health Checks**
- **Service Status**: `docker ps`
- **Resource Usage**: `docker stats`
- **Network Connectivity**: `docker network ls`

## 📞 **Support**

For issues or questions:
1. Check this documentation
2. Review service-specific documentation
3. Check Docker Swarm logs
4. Contact system administrator

---

**Last Updated**: $(date)
**Version**: 1.0
**Maintainer**: Alwazw Business Stack Team

