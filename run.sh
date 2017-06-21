#!/usr/bin/env bash

set -e

# Build the project and docker images
#sudo mvn clean package

DOCKER_IP=127.0.0.1

# Remove existing containers
sudo docker-compose stop
sudo docker-compose rm -f

sudo docker-compose up -d rabbitmq

# Start the discovery service next and wait
sudo docker-compose up -d registry

while [ -z ${DISCOVERY_SERVICE_READY} ]; do
  echo "Waiting for registry service..."
  if [ "$(curl --silent $DOCKER_IP:8761/health 2>&1 | grep -q '\"status\":\"UP\"'; echo $?)" = 0 ]; then
      DISCOVERY_SERVICE_READY=true;
  fi
  sleep 2
done

# Start the config service first and wait for it to become available
sudo docker-compose up -d config

while [ -z ${CONFIG_SERVICE_READY} ]; do
  echo "Waiting for config service..."
  if [ "$(curl --silent $DOCKER_IP:8888/health 2>&1 | grep -q '\"status\":\"UP\"'; echo $?)" = 0 ]; then
      CONFIG_SERVICE_READY=true;
  fi
  sleep 2
done

# Start the other containers
sudo docker-compose up -d

# Attach to the log output of the cluster
sudo docker-compose logs
