#!/usr/bin/env bash
#
# add repositories for git, docker and chrome
#
#add-apt-repository ppa:git-core/ppa

#apt-get -y install apt-transport-https ca-certificates

# Add new GPG key and add it to adv keychain
#apt-key adv \
#               --keyserver hkp://ha.pool.sks-keyservers.net:80 \
#               --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

# Update where APT will search for Docker Packages
#echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" | sudo tee /etc/apt/sources.list.d/docker.list

#
# add repositories for git, docker and chrome
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

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

apt-get update
# Verifies APT is pulling from the correct Repository for docker
#apt-cache policy docker-engine

#
# Install latest Git
#
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
#apt-get -y install docker-engine=1.12.3-0~trusty
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

#
# create a cache dir and get the bluemix command line
#
CACHE_DIR=/vagrant/cache
if [ ! -d $CACHE_DIR ]; then
    mkdir -p $CACHE_DIR
fi
CF_FILENAME="cf-cli_amd64.deb"
if [ -f ${CACHE_DIR}/${CF_FILENAME} ]; then
    echo "Using cached version of CloudFoundry command line tools: ${CF_FILENAME}"
else
    wget --progress=dot:mega "https://cli.run.pivotal.io/stable?release=debian64&source=github" -O ${CACHE_DIR}/${CF_FILENAME}
fi
dpkg -i ${CACHE_DIR}/${CF_FILENAME}

#
# install golang
#
GO_FILENAME="go1.7.6.linux-amd64.tar.gz"
if [ -f ${CACHE_DIR}/${GO_FILENAME} ]; then
    echo "Using cached version of Go.Lang tools: ${GO_FILENAME}"
else
    wget --progress=dot:mega "https://storage.googleapis.com/golang/${GO_FILENAME}" -O ${CACHE_DIR}/${GO_FILENAME}
fi

tar -C /usr/local -xzf ${CACHE_DIR}/${GO_FILENAME}

#
# install chrome and xvfb
#
apt-get install -y xvfb google-chrome-stable

#
# install ruby for website testing
#
sudo apt-get install -y ruby2.0-dev ruby2.0
sudo rm /usr/bin/ruby && sudo ln -s /usr/bin/ruby2.0 /usr/bin/ruby
sudo rm -fr /usr/bin/gem && sudo ln -s /usr/bin/gem2.0 /usr/bin/gem

gem install jekyll
gem install jekyll-sitemap
gem install redcarpet
