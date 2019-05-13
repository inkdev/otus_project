#!/bin/sh

sudo usermod -aG docker appuser
sudo systemctl restart docker
docker-compose -f docker-compose-crawler.yml up -d
docker-compose -f docker-compose-monitoring.yml up -d
docker-compose -f docker-compose-gitlab.yml up -d
