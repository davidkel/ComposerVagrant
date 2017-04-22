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

# enable default node
nvm use default

$DEVENV_END_COMMENT
END-DEVENV-PROFILE-SECTION
