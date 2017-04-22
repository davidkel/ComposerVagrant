#!/usr/bin/env bash

#
# use latest repos for git and docker
#
add-apt-repository ppa:git-core/ppa
# Ensure that CA certificates are installed
apt-get -y install apt-transport-https ca-certificates

# Add new GPG key and add it to adv keychain
apt-key adv \
               --keyserver hkp://ha.pool.sks-keyservers.net:80 \
               --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

# Update where APT will search for Docker Packages
echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | sudo tee /etc/apt/sources.list.d/docker.list

# Update package lists
apt-get update

# Verifies APT is pulling from the correct Repository
apt-cache policy docker-engine


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
apt-get -y install docker-engine=1.12.3-0~trusty
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
curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod 755 /usr/local/bin/docker-compose
