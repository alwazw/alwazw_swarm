#!/bin/bash

# Create all remaining service files

# Database services
cat > stacks/database/pgadmin.yml << 'YAML'
version: '3.8'
services:
  pgadmin:
    image: dpage/pgadmin4:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_pgadmin
    restart: unless-stopped
    environment:
      - PGADMIN_DEFAULT_EMAIL=${PGADMIN_EMAIL}
      - PGADMIN_DEFAULT_PASSWORD=${PGADMIN_PASSWORD}
      - PGADMIN_LISTEN_PORT=80
    ports:
      - "${PGADMIN_PORT:-5433}:80"
    volumes:
      - pgadmin_data:/var/lib/pgadmin
    networks:
      - database_network
    depends_on:
      - postgres
volumes:
  pgadmin_data:
networks:
  database_network:
    external: true
YAML

# Email services
cat > stacks/emails/mailhog.yml << 'YAML'
version: '3.8'
services:
  mailhog:
    image: mailhog/mailhog:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_mailhog
    restart: unless-stopped
    ports:
      - "${MAILHOG_SMTP_PORT:-1025}:1025"
      - "${MAILHOG_WEB_PORT:-8025}:8025"
    networks:
      - email_network
volumes:
networks:
  email_network:
    external: true
YAML

cat > stacks/emails/postfix.yml << 'YAML'
version: '3.8'
services:
  postfix:
    image: boky/postfix:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_postfix
    restart: unless-stopped
    environment:
      - HOSTNAME=${POSTFIX_HOSTNAME}
      - RELAYHOST=${POSTFIX_RELAYHOST}
      - RELAYHOST_USERNAME=${POSTFIX_USERNAME}
      - RELAYHOST_PASSWORD=${POSTFIX_PASSWORD}
    ports:
      - "${POSTFIX_PORT:-25}:587"
    networks:
      - email_network
networks:
  email_network:
    external: true
YAML

# Logging services
cat > stacks/logging/dozzle.yml << 'YAML'
version: '3.8'
services:
  dozzle:
    image: amir20/dozzle:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_dozzle
    restart: unless-stopped
    ports:
      - "${DOZZLE_PORT:-8080}:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
    networks:
      - logging_network
networks:
  logging_network:
    external: true
YAML

cat > stacks/logging/elasticsearch.yml << 'YAML'
version: '3.8'
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.11.0
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_elasticsearch
    restart: unless-stopped
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ports:
      - "${ELASTICSEARCH_PORT:-9200}:9200"
    volumes:
      - elasticsearch_data:/usr/share/elasticsearch/data
    networks:
      - logging_network
volumes:
  elasticsearch_data:
networks:
  logging_network:
    external: true
YAML

cat > stacks/logging/kibana.yml << 'YAML'
version: '3.8'
services:
  kibana:
    image: docker.elastic.co/kibana/kibana:8.11.0
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_kibana
    restart: unless-stopped
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    ports:
      - "${KIBANA_PORT:-5601}:5601"
    networks:
      - logging_network
    depends_on:
      - elasticsearch
networks:
  logging_network:
    external: true
YAML

echo "All remaining services created successfully"
