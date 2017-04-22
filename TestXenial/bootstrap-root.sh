#!/usr/bin/env bash


#
# Install latest Git
#
add-apt-repository ppa:git-core/ppa
apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://apt.dockerproject.org/gpg | sudo apt-key add -

add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       ubuntu-$(lsb_release -cs) \
       main"

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
sudo apt-get -y install docker-engine
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
