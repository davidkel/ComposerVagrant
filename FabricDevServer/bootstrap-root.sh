#!/usr/bin/env bash

#
# add repositories for git, docker
#
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

apt-get update

#
# install docker
#
apt-get -y install docker-ce
service docker start
usermod -aG docker ubuntu
#
# install docker compose
#
curl -L "https://github.com/docker/compose/releases/download/1.17.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod 755 /usr/local/bin/docker-compose

#
# install zip
#
apt-get -y install zip
