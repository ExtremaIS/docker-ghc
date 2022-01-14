#!/bin/bash

# docker-ghc ghcup build script (Debian bullseye)
#
# Install the specified GHC version and latest Cabal version on Debian
# bullseye using ghcup.

set -o errexit
set -o nounset
#set -o xtrace

##############################################################################
# Constants

RED="$(tput setaf 1)"
GRN="$(tput setaf 2)"
BLD="$(tput bold)"
RST="$(tput sgr0)"

##############################################################################
# Library

put_error () {
  message="${1}"
  echo "${RED}${BLD}${message}${RST}"
}

put_heading () {
  message="${1}"
  echo "${BLD}${message}${RST}"
}

put_info () {
  message="${1}"
  echo "${GRN}${message}${RST}"
}

##############################################################################
# Arguments

put_heading "Configure"

if [ "$#" -lt "1" ] || [ "$#" -gt "3" ] ; then
  put_error "usage: build.sh GHC_VERSION [USER_UID] [USER_GID]"
  exit 1
fi

GHC_VERSION="${1}"
USER_UID="${2:-1000}"
USER_GID="${3:-1000}"

echo "GHC_VERSION=${GHC_VERSION}"
echo "USER_UID=${USER_UID}"
echo "USER_GID=${USER_GID}"

##############################################################################
# Main

put_heading "Install OS packages"
put_info "Updating package index"
apt-get update
put_info "Upgrading installed packages"
apt-get upgrade -y
put_info "Installing packages"
apt-get install -y \
  build-essential \
  curl \
  git \
  libffi-dev \
  libffi7 \
  libgmp-dev \
  libgmp10 \
  libncurses-dev \
  libncurses5 \
  libnuma-dev \
  libtinfo5 \
  sudo \
  tmux \
  vim \
  wget

put_heading "Configure OS"
put_info "Configuring sudo"
sed -i '/^%sudo/s/ALL$/NOPASSWD:ALL/' "/etc/sudoers"

put_heading "Create user"
put_info "Adding group: docker (${USER_GID})"
groupadd \
  --gid "${USER_GID}" \
  "docker"
put_info "Adding user: docker (${USER_UID})"
useradd \
  --create-home \
  --shell "/bin/bash" \
  --uid "${USER_UID}" \
  --gid "${USER_GID}" \
  --groups "adm,staff,sudo" \
  "docker"
put_info "Setting password"
echo "docker:docker" | chpasswd

put_heading "Install ghcup"
put_info "Creating /home/docker/.ghcup/bin"
sudo -u "docker" mkdir -p "/home/docker/.ghcup/bin"
put_info "Downloading ghcup"
sudo -u "docker" \
  wget https://downloads.haskell.org/~ghcup/x86_64-linux-ghcup \
  -O /home/docker/.ghcup/bin/ghcup
put_info "Setting ghcup permissions"
sudo -u "docker" chmod 0755 /home/docker/.ghcup/bin/ghcup
put_info "Upgrading ghcup"
sudo -u "docker" /home/docker/.ghcup/bin/ghcup upgrade
put_info "Confirming ghcup installation"
sudo -u "docker" /home/docker/.ghcup/bin/ghcup --version

put_heading "Install GHC"
put_info "Installing GHC ${GHC_VERSION}"
sudo -u "docker" \
  /home/docker/.ghcup/bin/ghcup install ghc "${GHC_VERSION}" --set
put_info "Confirming GHC installation"
sudo -u "docker" /home/docker/.ghcup/bin/ghc --version

put_heading "Install Cabal"
put_info "Installing Cabal"
sudo -u "docker" /home/docker/.ghcup/bin/ghcup install cabal
put_info "Confirming Cabal installation"
sudo -u "docker" /home/docker/.ghcup/bin/cabal --version
put_info "Updating Cabal package list"
sudo -u "docker" /home/docker/.ghcup/bin/cabal update

put_heading "Clean up"
put_info "Removing package index"
rm -rf /var/lib/apt/lists/*
put_info "Removing build script"
rm /tmp/build.sh
