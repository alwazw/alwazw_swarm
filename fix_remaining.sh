#!/bin/bash

# Fix remaining empty files
cat > stacks/logging/graylog.yml << 'YAML'
version: '3.8'
services:
  graylog:
    image: graylog/graylog:5.2
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_graylog
    restart: unless-stopped
    environment:
      - GRAYLOG_PASSWORD_SECRET=${GRAYLOG_PASSWORD_SECRET}
      - GRAYLOG_ROOT_PASSWORD_SHA2=${GRAYLOG_ROOT_PASSWORD_SHA2}
      - GRAYLOG_HTTP_EXTERNAL_URI=http://localhost:9000/
      - GRAYLOG_ELASTICSEARCH_HOSTS=http://elasticsearch:9200
      - GRAYLOG_MONGODB_URI=mongodb://mongo:27017/graylog
    ports:
      - "${GRAYLOG_PORT:-9000}:9000"
      - "${GRAYLOG_SYSLOG_PORT:-1514}:1514/udp"
    networks:
      - logging_network
    depends_on:
      - elasticsearch
networks:
  logging_network:
    external: true
YAML

cat > stacks/logging/fluent_bit.yml << 'YAML'
version: '3.8'
services:
  fluent_bit:
    image: fluent/fluent-bit:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_fluent_bit
    restart: unless-stopped
    ports:
      - "${FLUENT_BIT_PORT:-24224}:24224"
    volumes:
      - ./config/fluent-bit:/fluent-bit/etc
      - /var/log:/var/log:ro
    networks:
      - logging_network
networks:
  logging_network:
    external: true
YAML

cat > stacks/logging/vector.yml << 'YAML'
version: '3.8'
services:
  vector:
    image: timberio/vector:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_vector
    restart: unless-stopped
    ports:
      - "${VECTOR_PORT:-8686}:8686"
    volumes:
      - ./config/vector:/etc/vector
      - /var/log:/var/log:ro
    networks:
      - logging_network
networks:
  logging_network:
    external: true
YAML

cat > stacks/logging/logrotate.yml << 'YAML'
version: '3.8'
services:
  logrotate:
    image: linkyard/docker-logrotate:latest
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_logrotate
    restart: unless-stopped
    environment:
      - LOGROTATE_INTERVAL=daily
      - LOGROTATE_COPIES=7
    volumes:
      - /var/lib/docker/containers:/var/lib/docker/containers:rw
      - /var/log:/var/log:rw
    networks:
      - logging_network
networks:
  logging_network:
    external: true
YAML

cat > stacks/logging/filebat.yml << 'YAML'
version: '3.8'
services:
  filebeat:
    image: docker.elastic.co/beats/filebeat:8.11.0
    container_name: ${COMPOSE_PROJECT_NAME:-alwazw_swarm}_filebeat
    restart: unless-stopped
    user: root
    volumes:
      - ./config/filebeat:/usr/share/filebeat/filebeat.yml:ro
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - /var/log:/var/log:ro
    networks:
      - logging_network
    depends_on:
      - elasticsearch
networks:
  logging_network:
    external: true
YAML

echo "All remaining services fixed!"
