#!/bin/bash
#
# Stoplist Project Deployment Script
#
# This script is a simple wrapper around docker-compose to manage the application stack.
#
# Usage:
#   ./deploy.sh start   - Start all services in detached mode.
#   ./deploy.sh stop    - Stop all running services.
#   ./deploy.sh down    - Stop and remove all services, networks, and volumes.
#   ./deploy.sh logs    - View the logs of all services.
#   ./deploy.sh logs-f  - Follow the logs of all services.
#   ./deploy.sh build   - Rebuild all service images.
#

# The Docker Compose file to use
COMPOSE_FILE="docker-compose.prod.yml"

# Function to display usage information
usage() {
    echo "Usage: $0 {start|stop|down|logs|logs-f|build}"
    exit 1
}

# Main script logic
case "$1" in
    start)
        echo "Starting all services..."
        docker-compose -f $COMPOSE_FILE up -d
        ;;
    stop)
        echo "Stopping all services..."
        docker-compose -f $COMPOSE_FILE stop
        ;;
    down)
        echo "Stopping and removing all services, networks, and volumes..."
        docker-compose -f $COMPOSE_FILE down
        ;;
    logs)
        echo "Displaying logs..."
        docker-compose -f $COMPOSE_FILE logs
        ;;
    logs-f)
        echo "Following logs..."
        docker-compose -f $COMPOSE_FILE logs -f
        ;;
    build)
        echo "Building/rebuilding all service images..."
        docker-compose -f $COMPOSE_FILE build
        ;;
    *)
        usage
        ;;
esac

exit 0
