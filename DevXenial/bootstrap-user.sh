#!/usr/bin/env bash

# commands run as the vagrant user after the image is provisioned and the root script is complete

#
# install nvm
#
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] || curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.3/install.sh | bash
. "$NVM_DIR/nvm.sh"

#
# install default nodejs version
#
DEFAULT_NODE_VERSION=6
nvm which $DEFAULT_NODE_VERSION >/dev/null 2>&1 || nvm install $DEFAULT_NODE_VERSION

nvm alias default $DEFAULT_NODE_VERSION

nvm use --delete-prefix default

#
# install Node-based tools
#
npm install -g yo
npm install -g node-inspector
npm install -g typings
npm install -g bower
npm install -g @angular/cli
npm install -g eslint
npm install -g eslint-plugin-smells
npm install -g mocha

#
# configure src directory and share it for windows hosts
#
if [ "$1" == "win" ]; then
    mkdir /home/ubuntu/src
    sudo service smbd restart
fi
