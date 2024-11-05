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
# Functions

define all_files
  find . -not -path '*/\.*' -type f
endef

define die
  (echo "error: $(1)" ; false)
endef

##############################################################################
# Rules

build-ghcup: #internal# build Docker image using ghcup
> docker build \
>   --no-cache \
>   --build-arg "GHC_VERSION=$(GHC_VERSION)" \
>   --build-arg "TERM=${TERM}" \
>   --build-arg "USER_GID=$(shell id -g)" \
>   --build-arg "USER_UID=$(shell id -u)" \
>   --file "ghcup-$(DISTRO)/Dockerfile" \
>   --tag $(DOCKER_IMAGE):$(DOCKER_TAG) \
>   .
.PHONY: build-ghcup

build-manual: #internal# build Docker image using manual installation
> docker build \
>   --no-cache \
>   --build-arg "CABAL_URL=$(CABAL_URL)" \
>   --build-arg "GHC_DIR=$(GHC_DIR)" \
>   --build-arg "GHC_URL=$(GHC_URL)" \
>   --build-arg "TERM=${TERM}" \
>   --build-arg "USER_GID=$(shell id -g)" \
>   --build-arg "USER_UID=$(shell id -u)" \
>   --file "manual-$(DISTRO)/Dockerfile" \
>   --tag $(DOCKER_IMAGE):$(DOCKER_TAG) \
>   .
.PHONY: build-manual

ghc-8.10: # build GHC 8.10 image
ghc-8.10: DOCKER_TAG = 8.10
ghc-8.10: GHC_URL = https://downloads.haskell.org/~ghc/8.10.7/ghc-8.10.7-x86_64-deb10-linux.tar.xz
ghc-8.10: GHC_DIR = ghc-8.10.7
ghc-8.10: CABAL_URL = https://downloads.haskell.org/~cabal/cabal-install-3.4.0.0/cabal-install-3.4.0.0-x86_64-ubuntu-16.04.tar.xz
ghc-8.10: DISTRO=bullseye
ghc-8.10: build-manual
.PHONY: ghc-8.10

ghc-9.0: # build GHC 9.0 image
ghc-9.0: DOCKER_TAG = 9.0
ghc-9.0: GHC_URL = https://downloads.haskell.org/~ghc/9.0.2/ghc-9.0.2-x86_64-deb10-linux.tar.xz
ghc-9.0: GHC_DIR = ghc-9.0.2
ghc-9.0: CABAL_URL = https://downloads.haskell.org/~cabal/cabal-install-3.6.2.0/cabal-install-3.6.2.0-x86_64-linux-deb10.tar.xz
ghc-9.0: DISTRO = bullseye
ghc-9.0: build-manual
.PHONY: ghc-9.0

ghc-9.2: # build GHC 9.2 image
ghc-9.2: DOCKER_TAG = 9.2
ghc-9.2: GHC_URL = https://downloads.haskell.org/ghc/9.2.8/ghc-9.2.8-x86_64-deb10-linux.tar.xz
ghc-9.2: GHC_DIR = ghc-9.2.8
ghc-9.2: CABAL_URL = https://downloads.haskell.org/~cabal/cabal-install-3.8.1.0/cabal-install-3.8.1.0-x86_64-linux-deb10.tar.xz
ghc-9.2: DISTRO = bullseye
ghc-9.2: build-manual
.PHONY: ghc-9.2

ghc-9.4: # build GHC 9.4 image
ghc-9.4: DOCKER_TAG = 9.4
ghc-9.4: GHC_URL = https://downloads.haskell.org/ghc/9.4.8/ghc-9.4.8-x86_64-deb11-linux.tar.xz
ghc-9.4: GHC_DIR = ghc-9.4.8-x86_64-unknown-linux
ghc-9.4: CABAL_URL = https://downloads.haskell.org/~cabal/cabal-install-3.10.2.0/cabal-install-3.10.2.0-x86_64-linux-deb11.tar.xz
ghc-9.4: DISTRO = bullseye
ghc-9.4: build-manual
.PHONY: ghc-9.4

ghc-9.6: # build GHC 9.6 image
ghc-9.6: DOCKER_TAG = 9.6
ghc-9.6: GHC_URL = https://downloads.haskell.org/~ghc/9.6.6/ghc-9.6.6-x86_64-deb11-linux.tar.xz
ghc-9.6: GHC_DIR = ghc-9.6.6-x86_64-unknown-linux
ghc-9.6: CABAL_URL = https://downloads.haskell.org/~cabal/cabal-install-3.12.1.0/cabal-install-3.12.1.0-x86_64-linux-deb12.tar.xz
ghc-9.6: DISTRO = bookworm
ghc-9.6: build-manual
.PHONY: ghc-9.6

ghc-9.8: # build GHC 9.8 image
ghc-9.8: DOCKER_TAG = 9.8
ghc-9.8: GHC_URL = https://downloads.haskell.org/~ghc/9.8.3/ghc-9.8.3-x86_64-deb12-linux.tar.xz
ghc-9.8: GHC_DIR = ghc-9.8.3-x86_64-unknown-linux
ghc-9.8: CABAL_URL = https://downloads.haskell.org/~cabal/cabal-install-3.10.3.0/cabal-install-3.10.3.0-x86_64-linux-deb11.tar.xz
ghc-9.8: DISTRO = bookworm
ghc-9.8: build-manual
.PHONY: ghc-9.8

ghc-9.10: # build GHC 9.10 image
ghc-9.10: DOCKER_TAG = 9.10
ghc-9.10: GHC_URL = https://downloads.haskell.org/ghc/9.10.1/ghc-9.10.1-x86_64-deb12-linux.tar.xz
ghc-9.10: GHC_DIR = ghc-9.10.1-x86_64-unknown-linux
ghc-9.10: CABAL_URL = https://downloads.haskell.org/~cabal/cabal-install-3.10.3.0/cabal-install-3.10.3.0-x86_64-linux-deb11.tar.xz
ghc-9.10: DISTRO = bookworm
ghc-9.10: build-manual
.PHONY: ghc-9.10

ghc-9.12: # build GHC 9.12 image
ghc-9.12: DOCKER_TAG = 9.12
ghc-9.12: GHC_URL = https://downloads.haskell.org/ghc/9.12.1-alpha2/ghc-9.12.0.20241031-x86_64-deb12-linux.tar.xz
ghc-9.12: GHC_DIR = ghc-9.12.0.20241031-x86_64-unknown-linux
ghc-9.12: CABAL_URL = https://downloads.haskell.org/~cabal/cabal-install-3.12.1.0/cabal-install-3.12.1.0-x86_64-linux-deb12.tar.xz
ghc-9.12: DISTRO = bookworm
ghc-9.12: build-manual
.PHONY: ghc-9.12

grep: # grep all non-hidden files for expression E
> $(eval E:= "")
> @test -n "$(E)" || $(call die,"usage: make grep E=expression")
> @$(call all_files) | xargs grep -Hn '$(E)' || true
.PHONY: grep

help: # show this help
> @grep '^[a-zA-Z0-9._-]\+:[^#]*# ' $(MAKEFILE_LIST) \
>   | sed 's/^\([^:]\+\):[^#]*# \(.*\)/make \1\t\2/' \
>   | column -t -s $$'\t'
.PHONY: help

ignored: # list files ignored by git
> @git ls-files . --ignored --exclude-standard --others
.PHONY: ignored

list: # list built images
> @docker images $(DOCKER_IMAGE)
.PHONY: list

recent: # show N most recently modified files
> $(eval N := "10")
> @find . -not -path '*/\.*' -type f -printf '%T+ %p\n' \
>   | sort --reverse \
>   | head -n $(N)
.PHONY: recent

shellcheck: # run shellcheck on scripts
> @find . -name '*.sh' | xargs shellcheck
.PHONY: shellcheck

todo: # search for TODO items
> @find . -type f \
>   -not -path '*/\.*' \
>   -not -path './build/*' \
>   -not -path './project/*' \
>   -not -path ./Makefile \
>   | xargs grep -Hn TODO \
>   | grep -v '^Binary file ' \
>   || true
.PHONY: todo
