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
# install previous nodejs version for conversation along with the same global modules
# plus change the level of npm to what was being used.
#
# PREV_NODE_VERSION=4.7.2
# nvm which $PREV_NODE_VERSION >/dev/null 2>&1 || nvm install $PREV_NODE_VERSION --reinstall-packages-from=node

# revert to using the latest conversation version
# nvm use --delete-prefix default
