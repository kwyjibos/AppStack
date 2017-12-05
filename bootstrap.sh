#!/bin/bash
apt-get update \
&& apt-get install -y git npm composer docker.io python-pip \
&& pip install docker-compose

cd /vagrant && docker-compose up
