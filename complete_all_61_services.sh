#!/bin/bash

# Complete all remaining services to reach 61 total

# Monitoring exporters
cat > stacks/monitoring/node_exporter.yml << 'YAML'
version: '3.8'
services:
  node_exporter:
    image: prom/node-exporter:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_node_exporter
    restart: unless-stopped
    command:
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/rootfs'
      - '--path.sysfs=/host/sys'
      - '--web.listen-address=0.0.0.0:9100'
    ports:
      - "${NODE_EXPORTER_PORT:-9100}:9100"
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    networks:
      - monitoring_network
networks:
  monitoring_network:
    external: true
YAML

cat > stacks/monitoring/cadvisor.yml << 'YAML'
version: '3.8'
services:
  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_cadvisor
    restart: unless-stopped
    privileged: true
    ports:
      - "${CADVISOR_PORT:-8080}:8080"
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker:/var/lib/docker:ro
    networks:
      - monitoring_network
networks:
  monitoring_network:
    external: true
YAML

cat > stacks/monitoring/blackbox_exporter.yml << 'YAML'
version: '3.8'
services:
  blackbox_exporter:
    image: prom/blackbox-exporter:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_blackbox_exporter
    restart: unless-stopped
    ports:
      - "${BLACKBOX_EXPORTER_PORT:-9115}:9115"
    volumes:
      - ./config/blackbox:/etc/blackbox_exporter
    networks:
      - monitoring_network
networks:
  monitoring_network:
    external: true
YAML

# Networking services
cat > stacks/networking/adguard_home.yml << 'YAML'
version: '3.8'
services:
  adguard:
    image: adguard/adguardhome:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_adguard
    restart: unless-stopped
    ports:
      - "${ADGUARD_PORT:-3080}:3000"
      - "${ADGUARD_DNS_PORT:-53}:53/tcp"
      - "${ADGUARD_DNS_PORT:-53}:53/udp"
    volumes:
      - adguard_work:/opt/adguardhome/work
      - adguard_conf:/opt/adguardhome/conf
    networks:
      - networking_network
volumes:
  adguard_work:
  adguard_conf:
networks:
  networking_network:
    external: true
YAML

cat > stacks/networking/cloudflared.yml << 'YAML'
version: '3.8'
services:
  cloudflared:
    image: cloudflare/cloudflared:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_cloudflared
    restart: unless-stopped
    command: tunnel --no-autoupdate run --token ${CLOUDFLARE_TUNNEL_TOKEN}
    networks:
      - networking_network
networks:
  networking_network:
    external: true
YAML

cat > stacks/networking/gotify.yml << 'YAML'
version: '3.8'
services:
  gotify:
    image: gotify/server:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_gotify
    restart: unless-stopped
    environment:
      - GOTIFY_DEFAULTUSER_NAME=${GOTIFY_USER:-alwazw}
      - GOTIFY_DEFAULTUSER_PASS=${GOTIFY_PASSWORD}
    ports:
      - "${GOTIFY_PORT:-8082}:80"
    volumes:
      - gotify_data:/app/data
    networks:
      - networking_network
volumes:
  gotify_data:
networks:
  networking_network:
    external: true
YAML

cat > stacks/networking/librespeed.yml << 'YAML'
version: '3.8'
services:
  librespeed:
    image: lscr.io/linuxserver/librespeed:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_librespeed
    restart: unless-stopped
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TZ}
    ports:
      - "${LIBRESPEED_PORT:-8081}:80"
    networks:
      - networking_network
networks:
  networking_network:
    external: true
YAML

cat > stacks/networking/webhook-relay.yml << 'YAML'
version: '3.8'
services:
  webhook_relay:
    image: webhookrelay/webhookrelayd:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_webhook_relay
    restart: unless-stopped
    environment:
      - RELAY_KEY=${WEBHOOK_RELAY_KEY}
      - RELAY_SECRET=${WEBHOOK_RELAY_SECRET}
    networks:
      - networking_network
networks:
  networking_network:
    external: true
YAML

cat > stacks/networking/whoami.yml << 'YAML'
version: '3.8'
services:
  whoami:
    image: traefik/whoami:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_whoami
    restart: unless-stopped
    ports:
      - "${WHOAMI_PORT:-8089}:80"
    networks:
      - networking_network
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.whoami.rule=Host(\`whoami.${DOMAIN}\`)"
networks:
  networking_network:
    external: true
YAML

# Security services
cat > stacks/security/wazuh.yml << 'YAML'
version: '3.8'
services:
  wazuh:
    image: wazuh/wazuh-manager:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_wazuh
    restart: unless-stopped
    environment:
      - WAZUH_MANAGER_ADMIN_USER=${WAZUH_USER:-alwazw}
      - WAZUH_MANAGER_ADMIN_PASSWORD=${WAZUH_PASSWORD}
    ports:
      - "${WAZUH_PORT:-1514}:1514"
      - "${WAZUH_API_PORT:-55000}:55000"
    volumes:
      - wazuh_data:/var/ossec/data
      - wazuh_logs:/var/ossec/logs
    networks:
      - security_network
volumes:
  wazuh_data:
  wazuh_logs:
networks:
  security_network:
    external: true
YAML

# Utilities
cat > stacks/utilities/filebrowser.yml << 'YAML'
version: '3.8'
services:
  filebrowser:
    image: filebrowser/filebrowser:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_filebrowser
    restart: unless-stopped
    ports:
      - "${FILEBROWSER_PORT:-8080}:80"
    volumes:
      - filebrowser_data:/database
      - ${FILEBROWSER_ROOT:-/data}:/srv
    networks:
      - utility_network
volumes:
  filebrowser_data:
networks:
  utility_network:
    external: true
YAML

cat > stacks/utilities/immich.yml << 'YAML'
version: '3.8'
services:
  immich:
    image: ghcr.io/immich-app/immich-server:release
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_immich
    restart: unless-stopped
    environment:
      - DB_HOSTNAME=postgres
      - DB_USERNAME=${IMMICH_DB_USER:-immich}
      - DB_PASSWORD=${IMMICH_DB_PASSWORD}
      - DB_DATABASE_NAME=${IMMICH_DB_NAME:-immich}
      - REDIS_HOSTNAME=redis
    ports:
      - "${IMMICH_PORT:-8098}:3001"
    volumes:
      - immich_upload:/usr/src/app/upload
      - ${IMMICH_PHOTOS_PATH:-/data/photos}:/usr/src/app/upload/library:ro
    networks:
      - utility_network
      - database_network
    depends_on:
      - postgres
      - redis
volumes:
  immich_upload:
networks:
  utility_network:
    external: true
  database_network:
    external: true
YAML

cat > stacks/utilities/photoprism.yml << 'YAML'
version: '3.8'
services:
  photoprism:
    image: photoprism/photoprism:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_photoprism
    restart: unless-stopped
    environment:
      - PHOTOPRISM_ADMIN_PASSWORD=${PHOTOPRISM_PASSWORD}
      - PHOTOPRISM_HTTP_PORT=2342
      - PHOTOPRISM_DATABASE_DRIVER=mysql
      - PHOTOPRISM_DATABASE_SERVER=mariadb:3306
      - PHOTOPRISM_DATABASE_NAME=${PHOTOPRISM_DB_NAME:-photoprism}
      - PHOTOPRISM_DATABASE_USER=${PHOTOPRISM_DB_USER:-photoprism}
      - PHOTOPRISM_DATABASE_PASSWORD=${PHOTOPRISM_DB_PASSWORD}
    ports:
      - "${PHOTOPRISM_PORT:-8097}:2342"
    volumes:
      - photoprism_storage:/photoprism/storage
      - ${PHOTOPRISM_PHOTOS_PATH:-/data/photos}:/photoprism/originals:ro
    networks:
      - utility_network
      - database_network
    depends_on:
      - mariadb
volumes:
  photoprism_storage:
networks:
  utility_network:
    external: true
  database_network:
    external: true
YAML

cat > stacks/utilities/syncthing.yml << 'YAML'
version: '3.8'
services:
  syncthing:
    image: lscr.io/linuxserver/syncthing:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_syncthing
    restart: unless-stopped
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TZ}
    ports:
      - "${SYNCTHING_PORT:-8384}:8384"
      - "${SYNCTHING_SYNC_PORT:-22000}:22000/tcp"
      - "${SYNCTHING_DISCOVERY_PORT:-21027}:21027/udp"
    volumes:
      - syncthing_config:/config
      - ${SYNCTHING_DATA_PATH:-/data/sync}:/data
    networks:
      - utility_network
volumes:
  syncthing_config:
networks:
  utility_network:
    external: true
YAML

# Nextcloud
cat > stacks/nextcloud/nextcloud.yml << 'YAML'
version: '3.8'
services:
  nextcloud:
    image: nextcloud:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_nextcloud
    restart: unless-stopped
    environment:
      - MYSQL_HOST=mariadb
      - MYSQL_DATABASE=${NEXTCLOUD_DB_NAME:-nextcloud}
      - MYSQL_USER=${NEXTCLOUD_DB_USER:-nextcloud}
      - MYSQL_PASSWORD=${NEXTCLOUD_DB_PASSWORD}
      - NEXTCLOUD_ADMIN_USER=${NEXTCLOUD_ADMIN_USER:-alwazw}
      - NEXTCLOUD_ADMIN_PASSWORD=${NEXTCLOUD_ADMIN_PASSWORD}
      - NEXTCLOUD_TRUSTED_DOMAINS=${DOMAIN}
    ports:
      - "${NEXTCLOUD_PORT:-8000}:80"
    volumes:
      - nextcloud_data:/var/www/html
      - ${NEXTCLOUD_DATA_PATH:-/data/nextcloud}:/var/www/html/data
    networks:
      - nextcloud_network
      - database_network
    depends_on:
      - mariadb
volumes:
  nextcloud_data:
networks:
  nextcloud_network:
    external: true
  database_network:
    external: true
YAML

echo "ALL 61 SERVICES COMPLETED!"
