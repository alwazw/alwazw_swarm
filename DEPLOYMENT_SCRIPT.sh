#!/bin/bash

# Docker Swarm Business Stack Deployment Script
# Author: Manus AI
# Version: 1.0
# Description: Complete deployment script for business-ready Docker stack

set -e

echo "🚀 Starting Docker Swarm Business Stack Deployment..."

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root for security reasons"
   exit 1
fi

print_header "System Requirements Check"

# Check Ubuntu version
if ! lsb_release -d | grep -q "Ubuntu"; then
    print_error "This script is designed for Ubuntu systems"
    exit 1
fi

print_status "✅ Ubuntu system detected"

# Update system packages
print_status "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install required packages
print_status "Installing required packages..."
sudo apt install -y \
    curl \
    wget \
    git \
    unzip \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

# Install Docker if not present
if ! command -v docker &> /dev/null; then
    print_status "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    print_warning "Please log out and log back in for Docker group changes to take effect"
else
    print_status "✅ Docker already installed"
fi

# Install Docker Compose if not present
if ! command -v docker-compose &> /dev/null; then
    print_status "Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
else
    print_status "✅ Docker Compose already installed"
fi

# Install UFW if not present
if ! command -v ufw &> /dev/null; then
    print_status "Installing UFW firewall..."
    sudo apt install -y ufw
else
    print_status "✅ UFW already installed"
fi

print_header "Firewall Configuration"

# Configure UFW firewall rules
print_status "Configuring firewall rules..."

# Reset UFW to defaults
sudo ufw --force reset

# Default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Essential ports
print_status "Opening essential ports..."
sudo ufw allow 22/tcp comment 'SSH'
sudo ufw allow 80/tcp comment 'HTTP - Traefik'
sudo ufw allow 443/tcp comment 'HTTPS - Traefik'

# Application ports
print_status "Opening application ports..."
sudo ufw allow 3000/tcp comment 'Grafana'
sudo ufw allow 3001/tcp comment 'Uptime Kuma'
sudo ufw allow 3100/tcp comment 'Loki'
sudo ufw allow 8000/tcp comment 'Nextcloud'
sudo ufw allow 8083/tcp comment 'Vaultwarden'
sudo ufw allow 8085/tcp comment 'Heimdall HTTP'
sudo ufw allow 8096/tcp comment 'Jellyfin'
sudo ufw allow 8444/tcp comment 'Heimdall HTTPS'
sudo ufw allow 9090/tcp comment 'Prometheus'
sudo ufw allow 32400/tcp comment 'Plex'

# Database ports (restrict to localhost if needed)
sudo ufw allow 5432/tcp comment 'PostgreSQL'
sudo ufw allow 6379/tcp comment 'Redis'

# Enable UFW
sudo ufw --force enable

print_status "✅ Firewall configured successfully"

print_header "Required Ports Summary"
cat << 'EOF'
📋 REQUIRED OPEN PORTS:

🌐 Web Services (Public):
- 80/tcp   - HTTP (Traefik Reverse Proxy)
- 443/tcp  - HTTPS (Traefik Reverse Proxy)

📊 Monitoring & Analytics:
- 3000/tcp - Grafana Dashboard
- 3001/tcp - Uptime Kuma
- 3100/tcp - Loki Logs
- 9090/tcp - Prometheus Metrics

🔐 Security & Management:
- 8083/tcp - Vaultwarden Password Manager
- 8085/tcp - Heimdall Dashboard HTTP
- 8444/tcp - Heimdall Dashboard HTTPS

☁️ File & Collaboration:
- 8000/tcp - Nextcloud

🎬 Media Services:
- 8096/tcp - Jellyfin Media Server
- 32400/tcp - Plex Media Server

🗄️ Database Services:
- 5432/tcp - PostgreSQL
- 6379/tcp - Redis

🔧 System:
- 22/tcp   - SSH Access
EOF

print_header "Docker Stack Deployment"

# Create project directory
PROJECT_DIR="/opt/alwazw_swarm"
if [ ! -d "$PROJECT_DIR" ]; then
    print_status "Creating project directory..."
    sudo mkdir -p $PROJECT_DIR
    sudo chown $USER:$USER $PROJECT_DIR
fi

cd $PROJECT_DIR

# Clone or update repository
if [ ! -d ".git" ]; then
    print_status "Cloning repository..."
    git clone https://github.com/alwazw/alwazw_swarm.git .
else
    print_status "Updating repository..."
    git pull origin main
fi

# Create required directories
print_status "Creating required directories..."
mkdir -p {config/{traefik,grafana,prometheus,loki,promtail},data/{grafana,prometheus,loki,vaultwarden,nextcloud,jellyfin,plex},logs}

# Set proper permissions
sudo chown -R $USER:$USER $PROJECT_DIR

# Copy environment file
if [ ! -f ".env" ]; then
    if [ -f ".env.alwazw" ]; then
        cp .env.alwazw .env
        print_status "✅ Environment file configured"
    else
        print_warning "Please configure .env file before deployment"
        exit 1
    fi
fi

print_header "Service Deployment"

# Deploy the stack
print_status "Deploying Docker stack..."
docker-compose -f docker-compose-fixed.yml up -d

# Wait for services to start
print_status "Waiting for services to initialize..."
sleep 30

print_header "Service Validation"

# Function to check service health
check_service() {
    local service_name=$1
    local port=$2
    local path=${3:-""}
    
    print_status "Checking $service_name on port $port..."
    
    if curl -f -s "http://localhost:$port$path" > /dev/null; then
        print_status "✅ $service_name is responding"
        return 0
    else
        print_error "❌ $service_name is not responding"
        return 1
    fi
}

# Check all services
FAILED_SERVICES=0

check_service "Traefik Dashboard" "8080" "/dashboard/" || ((FAILED_SERVICES++))
check_service "Grafana" "3000" || ((FAILED_SERVICES++))
check_service "Prometheus" "9090" || ((FAILED_SERVICES++))
check_service "Uptime Kuma" "3001" || ((FAILED_SERVICES++))
check_service "Loki" "3100" "/ready" || ((FAILED_SERVICES++))
check_service "Vaultwarden" "8083" || ((FAILED_SERVICES++))
check_service "Heimdall" "8085" || ((FAILED_SERVICES++))
check_service "Nextcloud" "8000" || ((FAILED_SERVICES++))
check_service "Jellyfin" "8096" || ((FAILED_SERVICES++))
check_service "Plex" "32400" || ((FAILED_SERVICES++))

print_header "Deployment Summary"

if [ $FAILED_SERVICES -eq 0 ]; then
    print_status "🎉 ALL SERVICES DEPLOYED SUCCESSFULLY!"
    echo ""
    print_status "Access your services at:"
    echo "📊 Grafana: http://$(hostname -I | awk '{print $1}'):3000"
    echo "📈 Prometheus: http://$(hostname -I | awk '{print $1}'):9090"
    echo "⏱️ Uptime Kuma: http://$(hostname -I | awk '{print $1}'):3001"
    echo "🔒 Vaultwarden: http://$(hostname -I | awk '{print $1}'):8083"
    echo "🏠 Heimdall: http://$(hostname -I | awk '{print $1}'):8085"
    echo "☁️ Nextcloud: http://$(hostname -I | awk '{print $1}'):8000"
    echo "🎬 Jellyfin: http://$(hostname -I | awk '{print $1}'):8096"
    echo "📺 Plex: http://$(hostname -I | awk '{print $1}'):32400"
    echo ""
    print_status "🔧 Admin Interfaces:"
    echo "🌐 Traefik Dashboard: http://$(hostname -I | awk '{print $1}'):8080"
    echo ""
    print_status "Default credentials are in your .env file"
else
    print_error "⚠️ $FAILED_SERVICES services failed to start properly"
    print_status "Check logs with: docker-compose logs [service_name]"
fi

print_header "Next Steps"
cat << 'EOF'
🎯 RECOMMENDED NEXT STEPS:

1. 🔐 Change default passwords in .env file
2. 🌐 Configure domain names in Traefik
3. 🔒 Set up SSL certificates
4. 📊 Configure monitoring dashboards
5. 💾 Set up backup strategies
6. 🔄 Configure automatic updates

📚 Documentation: Check the project README for detailed configuration guides
🐛 Issues: Report problems to the project repository
🎉 Enjoy your new business stack!
EOF

print_status "Deployment script completed!"

