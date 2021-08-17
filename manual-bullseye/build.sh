#!/bin/bash

# docker-ghc manual build script (Debian bullseye)
#
# Install the specified GHC and Cabal tarballs on Debian bullseye.

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

if [ "$#" -lt "3" ] || [ "$#" -gt "5" ] ; then
  put_error "usage: build.sh GHC_URL GHC_DIR CABAL_URL [USER_UID] [USER_GID]"
  exit 1
fi

GHC_URL="${1}"
GHC_DIR="${2}"
CABAL_URL="${3}"
USER_UID="${4:-1000}"
USER_GID="${5:-1000}"

echo "GHC_URL=${GHC_URL}"
echo "GHC_DIR=${GHC_DIR}"
echo "CABAL_URL=${CABAL_URL}"
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
  libffi-dev \
  libffi7 \
  libgmp-dev \
  libgmp10 \
  libncurses-dev \
  libncurses5 \
  libnuma-dev \
  libtinfo5 \
  stow \
  sudo \
  tmux \
  vim \
  wget

put_heading "Configure OS"
put_info "Configuring sudo"
sed -i '/^%sudo/s/ALL$/NOPASSWD:ALL/' "/etc/sudoers"
put_info "Creating /usr/local/opt"
mkdir -p /usr/local/opt

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

put_heading "Install GHC"
put_info "Downloading GHC"
cd /tmp
wget "${GHC_URL}" -O - | tar -Jx
put_info "Configuring GHC"
cd "${GHC_DIR}"
./configure --prefix="/usr/local/opt/${GHC_DIR}"
put_info "Installing GHC"
make install
put_info "Stowing GHC"
cd /usr/local/opt
stow "${GHC_DIR}"
put_info "Cleaning"
rm -rf "/tmp/${GHC_DIR}"
put_info "Confirming GHC installation"
/usr/local/bin/ghc --version

put_heading "Install Cabal"
put_info "Downloading Cabal"
cd /tmp
wget "${CABAL_URL}" -O - | tar -Jx --no-overwrite-dir
put_info "Installing Cabal"
mv cabal /usr/local/bin/cabal
put_info "Confirming Cabal installation"
/usr/local/bin/cabal --version
put_info "Updating Cabal package list"
sudo -u "docker" /usr/local/bin/cabal update

put_heading "Clean up"
put_info "Removing package index"
rm -rf /var/lib/apt/lists/*
put_info "Removing build script"
rm /tmp/build.sh
