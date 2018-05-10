#!/usr/bin/env bash

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
# make sure node/npm is not installed (causes issues for nvm managed node versions)
#
apt-get purge -y nodejs

#
# install ruby
#
apt-get install -y ruby-dev
gem install jekyll
gem install jekyll-sitemap
gem install redcarpet

#
# create a cache dir and get the bluemix command line
#
#CACHE_DIR=/vagrant/cache
#if [ ! -d $CACHE_DIR ]; then
#    mkdir -p $CACHE_DIR
#fi
#CF_FILENAME="cf-cli_amd64.deb"
#if [ -f ${CACHE_DIR}/${CF_FILENAME} ]; then
#    echo "Using cached version of CloudFoundry command line tools: ${CF_FILENAME}"
#else
#    wget --progress=dot:mega "https://cli.run.pivotal.io/stable?release=debian64&source=github" -O ${CACHE_DIR}/${CF_FILENAME}
#fi
#dpkg -i ${CACHE_DIR}/${CF_FILENAME}
CF_FILENAME="cf-cli_amd64.deb"
wget --progress=dot:mega "https://cli.run.pivotal.io/stable?release=debian64&source=github" -O ${CF_FILENAME}
dpkg -i ${CF_FILENAME}

#
# install golang
#
#GO_FILENAME="go1.7.6.linux-amd64.tar.gz"
#if [ -f ${CACHE_DIR}/${GO_FILENAME} ]; then
#    echo "Using cached version of Go.Lang tools: ${GO_FILENAME}"
#else
#    wget --progress=dot:mega "https://storage.googleapis.com/golang/${GO_FILENAME}" -O ${CACHE_DIR}/${GO_FILENAME}
#fi
#tar -C /usr/local -xzf ${CACHE_DIR}/${GO_FILENAME}

#
# install chrome and xvfb
#
apt-get install -y xvfb google-chrome-stable

#
# install samba if windows host
#
if [ "$1" == "win" ]; then
    apt-get install -y samba
    printf "ubuntu\nubuntu\n" | smbpasswd -as ubuntu

    #
    # configure samba but don't restart as dir hasn't been created
    #
    cat << EOF >> /etc/samba/smb.conf
[src]
path = /home/ubuntu/src
valid users = ubuntu
read only = no
EOF

fi
# make sure python 2 is available.
COUNT="$(python -V 2>&1 | grep -c 2.)"
if [ ${COUNT} -ne 1 ]
then
   sudo apt-get install -y python-minimal
fi

# install other useful packages
apt-get install -y libssl-dev
apt-get install -y unzip
apt-get install -y zip
