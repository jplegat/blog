#!/bin/bash

# Exit on any error
set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🛑 Stopping and removing containers...${NC}"
docker compose down --remove-orphans

echo -e "${YELLOW}🧹 Pruning unused images (optional)...${NC}"
docker image prune -f

echo -e "${YELLOW}🔨 Building new image (no cache)...${NC}"
docker compose build --no-cache

echo -e "${YELLOW}🚀 Starting containers in detached mode...${NC}"
docker compose up -d

echo -e "${GREEN}✅ Done! Containers are running.${NC}"
echo ""
echo -e "${GREEN}📊 Container status:${NC}"
docker compose ps

echo ""
echo -e "${GREEN}📝 View logs with:${NC} docker compose logs -f"
echo -e "${GREEN}🌐 Access your site at:${NC} http://192.168.1.150:8888"