# Docker Swarm Stack

A comprehensive Docker Compose stack for running multiple services including databases, analytics, dashboards, and management tools.

## Services Included

- **PostgreSQL** - Primary database server
- **Redis** - In-memory data structure store
- **Grafana** - Analytics and monitoring dashboards
- **pgAdmin** - PostgreSQL administration tool
- **Heimdall** - Application dashboard
- **MariaDB** - Alternative database option
- **Vaultwarden** - Password manager
- **Wazuh** - Security monitoring platform
- **n8n** - Workflow automation
- **Home Assistant** - Home automation platform
- **Plex** - Media server
- **LibreSpeed** - Network speed testing
- **AdGuard Home** - Network-wide ad blocking

## Quick Start

### Prerequisites

- Docker and Docker Compose installed
- At least 4GB of available RAM
- Sufficient disk space for volumes

### Deployment

1. Clone this repository:
```bash
git clone https://github.com/yourusername/swarm.git
cd swarm
```

2. Create secrets directory and files:
```bash
mkdir -p secrets
echo "your_password" > secrets/postgres_password.txt
echo "your_password" > secrets/mysql_root_password.txt
echo "your_password" > secrets/mysql_user_password.txt
echo "your_password" > secrets/pgadmin_password.txt
echo "your_email@domain.com" > secrets/pgadmin_email.txt
echo "your_password" > secrets/grafana_password.txt
echo "your_password" > secrets/librespeed_password.txt
chmod 600 secrets/*.txt
```

3. Configure environment variables:
```bash
cp .env.example .env
# Edit .env file with your specific configuration
```

4. Deploy the stack:
```bash
# For full stack deployment
docker compose -f docker-compose.yml -f database.yml -f analytics.yml -f networking.yml -f security.yml -f dashboards.yml -f media.yml -f automation.yml up -d

# For simplified deployment (recommended for testing)
docker compose -f working-stack.yml up -d
```

## Service Access

After deployment, services will be available at:

- **Grafana**: http://localhost:3000 (admin/your_password)
- **pgAdmin**: http://localhost:8080 (your_email/your_password)
- **Heimdall**: http://localhost (dashboard interface)
- **PostgreSQL**: localhost:5432 (postgres/your_password)
- **Redis**: localhost:6379

## Configuration Files

- `docker-compose.yml` - Main orchestration file with networks and volumes
- `_base.yml` - Common service configurations
- `database.yml` - Database services (PostgreSQL, Redis, MariaDB, pgAdmin)
- `analytics.yml` - Analytics services (Grafana)
- `networking.yml` - Network services (LibreSpeed, AdGuard Home)
- `security.yml` - Security services (Vaultwarden, Wazuh)
- `dashboards.yml` - Dashboard services (Heimdall)
- `media.yml` - Media services (Plex)
- `automation.yml` - Automation services (n8n, Home Assistant)
- `working-stack.yml` - Simplified working configuration

## Environment Variables

Copy `.env.example` to `.env` and configure:

```bash
# Database ports
POSTGRES_PORT=5432
REDIS_PORT=6379
MARIADB_PORT=3306

# Web interface ports
GRAFANA_PORT=3000
PGADMIN_PORT=8080
HEIMDALL_HTTP_PORT=80
HEIMDALL_HTTPS_PORT=443

# User configuration
PUID=1000
PGID=1000
TZ=America/Toronto

# Media paths
MEDIA_PATH=/path/to/your/media
```

## Security

- All passwords are stored in separate secret files
- Secrets directory should have restricted permissions (600)
- Default passwords should be changed in production
- Consider using Docker Swarm secrets for production deployments

## Troubleshooting

### Common Issues

1. **Port conflicts**: Ensure no other services are using the configured ports
2. **Permission issues**: Check that the user has proper Docker permissions
3. **Network issues**: Some environments may require host networking mode
4. **Volume permissions**: Ensure proper ownership of volume mount points

### Host Networking Mode

If you encounter networking issues, use the simplified configuration:

```bash
docker compose -f working-stack.yml up -d
```

This uses host networking mode which bypasses Docker's network isolation.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the deployment
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
- Check the troubleshooting section
- Review Docker and Docker Compose documentation
- Open an issue in this repository

