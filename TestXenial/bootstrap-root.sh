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
# install docker
#
sudo apt-get -y install docker-ce
service docker start
usermod -aG docker ubuntu
#
# install docker compose
#
curl -L "https://github.com/docker/compose/releases/download/1.11.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod 755 /usr/local/bin/docker-compose

#
# make sure node/npm is not installed (causes issues for nvm managed node versions)
#
apt-get purge -y nodejs

#
# install python 2.7 for node gyp
#
#apt-get install -y python2.7
#ln -s /usr/bin/python2.7 /usr/bin/python
apt-get install -y python-minimal
