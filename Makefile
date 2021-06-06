##############################################################################
# Project configuration

DOCKER_IMAGE := extremais/ghc

##############################################################################
# Make configuration

ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error GNU Make 4.0 or later required)
endif
.RECIPEPREFIX := >

SHELL := bash
.SHELLFLAGS := -o nounset -o errexit -o pipefail -c

MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --warn-undefined-variables

.DEFAULT_GOAL := help

##############################################################################
# Rules

build-ghcup: #internal# build Docker image using ghcup
> docker build \
>   --build-arg "GHC_VERSION=$(GHC_VERSION)" \
>   --build-arg "TERM=${TERM}" \
>   --build-arg "USER_GID=$(shell id -g)" \
>   --build-arg "USER_UID=$(shell id -u)" \
>   --file "ghcup/Dockerfile" \
>   --tag $(DOCKER_IMAGE):$(DOCKER_TAG) \
>   .
.PHONY: build-ghcup

build-manual: #internal# build Docker image using manual installation
> docker build \
>   --build-arg "CABAL_URL=$(CABAL_URL)" \
>   --build-arg "GHC_DIR=$(GHC_DIR)" \
>   --build-arg "GHC_URL=$(GHC_URL)" \
>   --build-arg "TERM=${TERM}" \
>   --build-arg "USER_GID=$(shell id -g)" \
>   --build-arg "USER_UID=$(shell id -u)" \
>   --file "manual/Dockerfile" \
>   --tag $(DOCKER_IMAGE):$(DOCKER_TAG) \
>   .
.PHONY: build-manual

ghc-8.10.5: DOCKER_TAG = 8.10.5
ghc-8.10.5: GHC_URL = https://downloads.haskell.org/ghc/8.10.5/ghc-8.10.5-x86_64-deb9-linux.tar.xz
ghc-8.10.5: GHC_DIR = ghc-8.10.5
ghc-8.10.5: CABAL_URL = https://downloads.haskell.org/~cabal/cabal-install-3.4.0.0/cabal-install-3.4.0.0-x86_64-ubuntu-16.04.tar.xz
ghc-8.10.5: build-manual
ghc-8.10.5: # build GHC 8.10.5 image
.PHONY: ghc-8.10.5

ghc-9.0: DOCKER_TAG = 9.0
ghc-9.0: GHC_VERSION = 9.0.1
ghc-9.0: build-ghcup
ghc-9.0: # build GHC 9.0 image
.PHONY: ghc-9.2

ghc-9.2: DOCKER_TAG = 9.2
ghc-9.2: GHC_URL = https://downloads.haskell.org/ghc/9.2.1-alpha2/ghc-9.2.0.20210422-x86_64-deb10-linux.tar.xz
ghc-9.2: GHC_DIR = ghc-9.2.0.20210422
ghc-9.2: CABAL_URL = https://downloads.haskell.org/~cabal/cabal-install-3.4.0.0/cabal-install-3.4.0.0-x86_64-ubuntu-16.04.tar.xz
ghc-9.2: build-manual
ghc-9.2: # build GHC 9.2 image
.PHONY: ghc-9.2

help: # show this help
> @grep '^[a-zA-Z0-9._-]\+:[^#]*# ' $(MAKEFILE_LIST) \
>   | sed 's/^\([^:]\+\):[^#]*# \(.*\)/make \1\t\2/' \
>   | column -t -s $$'\t'
.PHONY: help

list: # list built images
> @docker images $(DOCKER_IMAGE)
.PHONY: list

shellcheck: # run shellcheck on scripts
> @find . -name '*.sh' | xargs shellcheck
.PHONY: shellcheck
