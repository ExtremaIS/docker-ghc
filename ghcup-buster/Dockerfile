FROM debian:buster

ARG GHC_VERSION=UNSET
ARG TERM=xterm
ARG USER_GID=1000
ARG USER_UID=1000

ENV LANG=C.UTF-8
ENV TERM=${TERM}

COPY ghcup-buster/build.sh /tmp/build.sh
RUN /tmp/build.sh ${GHC_VERSION} ${USER_UID} ${USER_GID}

USER docker
ENV PATH=/home/docker/.ghcup/bin:${PATH}
VOLUME /host
WORKDIR /host
