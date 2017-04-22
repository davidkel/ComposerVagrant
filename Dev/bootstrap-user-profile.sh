#!/usr/bin/env bash

#
# add devenv section to .profile
#
# Note: this will remove any existing devenv section so that
# multiple 'vagrant provision' commands do not cause duplication
#
DEVENV_START_COMMENT="# ---BEGIN-DEVENV-PROFILE-SECTION---"
DEVENV_END_COMMENT="# ---END-DEVENV-PROFILE-SECTION---"

sed -i.bak "/$DEVENV_START_COMMENT/,/$DEVENV_END_COMMENT/d" ~/.profile

cat << END-DEVENV-PROFILE-SECTION >> ~/.profile
$DEVENV_START_COMMENT

# start up Xvfp and set the display
test -e /tmp/.X99-lock || sudo /usr/bin/Xvfb :99 &
export DISPLAY=:99.0

# add Go.Lang to the path
export PATH=/usr/local/go/bin:$PATH

# set node to default version
nvm use default

$DEVENV_END_COMMENT
END-DEVENV-PROFILE-SECTION
