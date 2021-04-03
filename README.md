# `docker-ghc`

* [Overview](#overview)
* [Usage](#usage)
    * [Requirements](#requirements)
    * [Building Images](#building-images)
    * [Running Containers](#running-containers)
* [Alternatives](#alternatives)
* [Project](#project)
    * [Contribution](#contribution)
    * [License](#license)

## Overview

This repository contains the source for building [Docker][] images for various
[GHC][] versions.  These images are intended to be used to try out new
releases of GHC before they are available via [Stack][].

[Docker]: <https://www.docker.com>
[GHC]: <https://www.haskell.org/ghc/>
[Stack]: <https://www.haskellstack.org>

Containers are run using the `docker` user, which is configured to use the UID
and GID of the host user when the image is built.  This allows you to mount
the host filesystem without having to worry about file ownership issues.

## Usage

Since images are configured when built, they should be built locally, *not*
hosted on Docker Hub.

### Requirements

The following software is used:

* [Docker](https://www.docker.com)
* [GNU Make](https://www.gnu.org/software/make/)
* [ShellCheck](https://www.shellcheck.net/)

### Building Images

To see which images are currently configured, run `make help`.

```
$ make help
make ghc-9.0     build GHC 9.0 image
make ghc-9.2     build GHC 9.2 image
make help        show this help
make list        list built images
make shellcheck  run shellcheck on scripts
```

For example, the following command builds a GHC 9.2 image:

```
$ make ghc-9.2
```

Run `make list` to list built images:

```
$ make list
REPOSITORY      TAG       IMAGE ID       CREATED        SIZE
extremais/ghc   9.2       aa24fc25ddaf   12 hours ago   3.52GB
extremais/ghc   9.0       568e37453665   12 hours ago   3.5GB
```

### Running Containers

Run a container to use a built image.  The `/host` directory within the
container may be used to mount a project directory on the host filesystem.
For example, the following command runs a shell in a GHC 9.2 container,
mounting the current directory at `/host`, and automatically removes the
container when finished:

```
$ docker run --rm -it -v "$(pwd)":/host extremais/ghc:9.2 /bin/bash
```

The images are based on [Debian][] Linux, so you can install any packages that
you need using `apt` or `apt-get`.  Use `sudo` to run commands as root.  The
`vim` and `tmux` packages are installed when the images are built.

[Debian]: <https://www.debian.org/>

A container can be used to execute single commands as well.  For example, the
following command mounts the current directory at `/host` and builds the
project, automatically removing the container when finished:

```
$ docker run --rm -it -v "$(pwd)":/host extremais/ghc:9.2 cabal v2-build
```

The following command runs a `ghci` shell, automatically removing the
container when finished:

```
$ docker run --rm -it extremais/ghc:9.2 ghci
```

## Alternatives

It is possible to configure `stack.yaml` to use a specific version of GHC.
Taylor Fausak wrote a helpful tutorial:

* [Testing GHC release candidates with Stack](https://taylor.fausak.me/2017/05/17/testing-ghc-release-candidates-with-stack/)
* [Example `stack.yaml`](https://gist.github.com/tfausak/a7ef9af57a9f0c0099f187cd3d920a87)

## Project

### Contribution

Issues are tracked on GitHub:
<https://github.com/ExtremaIS/docker-ghc/issues>

Issues may also be submitted via email to <bugs@extrema.is>.

### License

This project is released under the
[MIT License](https://opensource.org/licenses/MIT) as specified in the
[`LICENSE`](LICENSE) file.
