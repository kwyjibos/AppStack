#!/bin/bash
apt-get update \
&& apt-get install -y git docker.io python-pip \
&& pip install docker-compose \
&& git clone https://github.com/kwyjibos/AppStack.git /opt/AppStack \
&& cd /opt/AppStack \
&& docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
