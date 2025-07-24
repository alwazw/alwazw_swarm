#!/bin/bash

# Create the final missing services
cat > stacks/monitoring/docker_socket_proxy.yml << 'YAML'
version: '3.8'
services:
  docker_socket_proxy:
    image: tecnativa/docker-socket-proxy:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_docker_socket_proxy
    restart: unless-stopped
    environment:
      - CONTAINERS=1
      - SERVICES=1
      - SWARM=1
      - NODES=1
      - NETWORKS=1
      - TASKS=1
    ports:
      - "${DOCKER_SOCKET_PROXY_PORT:-2375}:2375"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
    networks:
      - monitoring_network
networks:
  monitoring_network:
    external: true
YAML

cat > stacks/monitoring/nginx_exporter.yml << 'YAML'
version: '3.8'
services:
  nginx_exporter:
    image: nginx/nginx-prometheus-exporter:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_nginx_exporter
    restart: unless-stopped
    command:
      - '-nginx.scrape-uri=http://nginx:8080/nginx_status'
    ports:
      - "${NGINX_EXPORTER_PORT:-9101}:9113"
    networks:
      - monitoring_network
networks:
  monitoring_network:
    external: true
YAML

cat > stacks/monitoring/redis_exporter.yml << 'YAML'
version: '3.8'
services:
  redis_exporter:
    image: oliver006/redis_exporter:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_redis_exporter
    restart: unless-stopped
    environment:
      - REDIS_ADDR=redis://redis:6379
      - REDIS_PASSWORD=${REDIS_PASSWORD}
    ports:
      - "${REDIS_EXPORTER_PORT:-9102}:9121"
    networks:
      - monitoring_network
      - database_network
    depends_on:
      - redis
networks:
  monitoring_network:
    external: true
  database_network:
    external: true
YAML

cat > stacks/monitoring/push_gateway.yml << 'YAML'
version: '3.8'
services:
  pushgateway:
    image: prom/pushgateway:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_pushgateway
    restart: unless-stopped
    ports:
      - "${PUSHGATEWAY_PORT:-9091}:9091"
    networks:
      - monitoring_network
networks:
  monitoring_network:
    external: true
YAML

cat > stacks/networking/apprise.yml << 'YAML'
version: '3.8'
services:
  apprise:
    image: caronc/apprise:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_apprise
    restart: unless-stopped
    environment:
      - PUID=${PUID}
      - PGID=${PGID}
      - TZ=${TZ}
    ports:
      - "${APPRISE_PORT:-8000}:8000"
    volumes:
      - apprise_config:/config
      - apprise_data:/data
    networks:
      - networking_network
volumes:
  apprise_config:
  apprise_data:
networks:
  networking_network:
    external: true
YAML

echo "ALL 61 SERVICES NOW COMPLETE!"
