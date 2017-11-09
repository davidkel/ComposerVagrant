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

add-apt-repository ppa:git-core/ppa

apt-get update

# install git
apt-get install -y git

#
# apt-get basic installs
#
apt-get install -y build-essential

#
# Bug Fix: Karma cannot start PhantomJS 1.9.8. Installing libfontconfig fixes the problem
# See: https://github.com/karma-runner/karma-phantomjs-launcher/issues/31
#
apt-get install -y libfontconfig

#
# install some other useful bits
#
apt-get install -y --no-upgrade screen
apt-get install -y --no-upgrade expect
apt-get install -y --no-upgrade jq/trusty-backports
apt-get install -y --no-upgrade python3-yaml
apt-get install -y --no-upgrade curl
apt-get install -y --no-upgrade python3-pip

# Install kernel packages which allows us to use aufs storage driver
apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual

# Install docker-engine
apt-get -y install docker-ce
service docker start
usermod -aG docker vagrant

#
# make sure node/npm is not installed (causes issues for nvm managed node versions)
#
apt-get purge -y nodejs

#
# fix python on trusty
#
pip3 install --upgrade pip
pip3 install -U urllib3
#pip3 install docker-compose
#
# install tested level of docker-compose (version 1.12.0 breaks the compose.yaml for v1)
#
curl -L "https://github.com/docker/compose/releases/download/1.17.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod 755 /usr/local/bin/docker-compose
