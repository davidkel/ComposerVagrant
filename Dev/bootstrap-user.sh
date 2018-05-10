#!/usr/bin/env bash

#
# install nvm
#
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] || curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
. "$NVM_DIR/nvm.sh"

#
# install supported nodejs version
#
DEFAULT_NODE_VERSION=8
nvm which $DEFAULT_NODE_VERSION >/dev/null 2>&1 || nvm install $DEFAULT_NODE_VERSION
nvm alias default $DEFAULT_NODE_VERSION
nvm use --delete-prefix default

#
# install Node-based tools
#
npm install -g yo
npm install -g typings
npm install -g @angular/cli
npm install -g eslint
npm install -g eslint-plugin-smells
npm install -g mocha

#
# install softhsm
#
mkdir softhsm
cd softhsm
curl -O https://dist.opendnssec.org/source/softhsm-2.0.0.tar.gz
tar -xvf softhsm-2.0.0.tar.gz
cd softhsm-2.0.0
./configure --disable-non-paged-memory --disable-gost
make
sudo make install

# now configure slot 0 with pin
sudo mkdir -p /var/lib/softhsm/tokens
sudo chmod 777 /var/lib/softhsm/tokens
softhsm2-util --init-token --slot 0 --label "ForComposer" --so-pin 1234 --pin 98765432
