#!/bin/bash

# create new network
docker network create hadoop_network

# build docker image with the name hadoop-base:3.3.1
docker build -t hadoop-base:3.3.1 .

# running from image to container, -d to make it run in the background
docker-compose up -d