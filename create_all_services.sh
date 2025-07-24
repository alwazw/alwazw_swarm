#!/bin/bash

# Dashboard services
cat > stacks/dashboards/homar.yml << 'YAML'
version: '3.8'
services:
  homar:
    image: ghcr.io/ajnart/homarr:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_homar
    restart: unless-stopped
    environment:
      - TZ=${TZ}
    ports:
      - "${HOMAR_PORT:-8088}:7575"
    volumes:
      - homar_config:/app/data/configs
      - homar_data:/data
    networks:
      - dashboard_network
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.homar.rule=Host(\`homar.${DOMAIN}\`)"
volumes:
  homar_config:
  homar_data:
networks:
  dashboard_network:
    external: true
YAML

cat > stacks/dashboards/homepage.yml << 'YAML'
version: '3.8'
services:
  homepage:
    image: ghcr.io/benphelps/homepage:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_homepage
    restart: unless-stopped
    environment:
      - TZ=${TZ}
      - PUID=${PUID}
      - PGID=${PGID}
    ports:
      - "${HOMEPAGE_PORT:-8086}:3000"
    volumes:
      - homepage_config:/app/config
      - /var/run/docker.sock:/var/run/docker.sock:ro
    networks:
      - dashboard_network
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.homepage.rule=Host(\`homepage.${DOMAIN}\`)"
volumes:
  homepage_config:
networks:
  dashboard_network:
    external: true
YAML

cat > stacks/dashboards/organizr.yml << 'YAML'
version: '3.8'
services:
  organizr:
    image: organizr/organizr:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_organizr
    restart: unless-stopped
    environment:
      - TZ=${TZ}
      - PUID=${PUID}
      - PGID=${PGID}
    ports:
      - "${ORGANIZR_PORT:-8087}:80"
    volumes:
      - organizr_config:/config
    networks:
      - dashboard_network
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.organizr.rule=Host(\`organizr.${DOMAIN}\`)"
volumes:
  organizr_config:
networks:
  dashboard_network:
    external: true
YAML

echo "Dashboard services created"
