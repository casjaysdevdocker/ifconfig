# Build
FROM golang:1.15-buster AS src

RUN apt update && apt install -yy git && \
  git clone -q https://github.com/mpolden/echoip /go/src/github.com/mpolden/echoip && \
  cd /go/src/github.com/mpolden/echoip

WORKDIR /go/src/github.com/mpolden/echoip
ENV GO111MODULE=on CGO_ENABLED=0
RUN make

FROM casjaysdevdocker/alpine:latest AS build

ARG ALPINE_VERSION="v3.16"

ARG DEFAULT_DATA_DIR="/usr/local/share/template-files/data" \
  DEFAULT_CONF_DIR="/usr/local/share/template-files/config" \
  DEFAULT_TEMPLATE_DIR="/usr/local/share/template-files/defaults"

ARG PACK_LIST="bash"

ENV LANG=en_US.UTF-8 \
  ENV=ENV=~/.bashrc \
  TZ="America/New_York" \
  SHELL="/bin/sh" \
  TERM="xterm-256color" \
  TIMEZONE="${TZ:-$TIMEZONE}" \
  HOSTNAME="casjaysdev-ifconfig"

COPY ./rootfs/. /
COPY --from=src /go/bin/echoip /opt/echoip/

RUN set -ex; \
  rm -Rf "/etc/apk/repositories"; \
  mkdir -p "${DEFAULT_DATA_DIR}" "${DEFAULT_CONF_DIR}" "${DEFAULT_TEMPLATE_DIR}"; \
  echo "http://dl-cdn.alpinelinux.org/alpine/${ALPINE_VERSION}/main" >>"/etc/apk/repositories"; \
  echo "http://dl-cdn.alpinelinux.org/alpine/${ALPINE_VERSION}/community" >>"/etc/apk/repositories"; \
  if [ "${ALPINE_VERSION}" = "edge" ]; then echo "http://dl-cdn.alpinelinux.org/alpine/${ALPINE_VERSION}/testing" >>"/etc/apk/repositories" ; fi ; \
  apk update --update-cache && apk add --no-cache ${PACK_LIST}

RUN cp -Rf /usr/local/share/template-files/data/. /opt/echoip/ && \
  ln -sf /opt/echoip/echoip /usr/local/bin/echoip

RUN echo 'Running cleanup' ; \
  rm -Rf /usr/share/doc/* /usr/share/info/* /tmp/* /var/tmp/* ; \
  rm -Rf /usr/local/bin/.gitkeep /usr/local/bin/.gitkeep /config /data /var/cache/apk/* ; \
  rm -rf /lib/systemd/system/multi-user.target.wants/* ; \
  rm -rf /etc/systemd/system/*.wants/* ; \
  rm -rf /lib/systemd/system/local-fs.target.wants/* ; \
  rm -rf /lib/systemd/system/sockets.target.wants/*udev* ; \
  rm -rf /lib/systemd/system/sockets.target.wants/*initctl* ; \
  rm -rf /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* ; \
  rm -rf /lib/systemd/system/systemd-update-utmp* ; \
  if [ -d "/lib/systemd/system/sysinit.target.wants" ]; then cd "/lib/systemd/system/sysinit.target.wants" && rm $(ls | grep -v systemd-tmpfiles-setup) ; fi

FROM scratch

ARG \
  SERVICE_PORT="8080" \
  EXPOSE_PORTS="8080" \
  PHP_SERVER="ifconfig" \
  NODE_VERSION="system" \
  NODE_MANAGER="system" \
  BUILD_VERSION="latest" \
  LICENSE="MIT" \
  IMAGE_NAME="ifconfig" \
  BUILD_DATE="Mon Nov 14 12:26:35 PM EST 2022" \
  TIMEZONE="America/New_York"

LABEL maintainer="CasjaysDev <docker-admin@casjaysdev.com>" \
  org.opencontainers.image.vendor="CasjaysDev" \
  org.opencontainers.image.authors="CasjaysDev" \
  org.opencontainers.image.vcs-type="Git" \
  org.opencontainers.image.name="${IMAGE_NAME}" \
  org.opencontainers.image.base.name="${IMAGE_NAME}" \
  org.opencontainers.image.license="${LICENSE}" \
  org.opencontainers.image.vcs-ref="${BUILD_VERSION}" \
  org.opencontainers.image.build-date="${BUILD_DATE}" \
  org.opencontainers.image.version="${BUILD_VERSION}" \
  org.opencontainers.image.schema-version="${BUILD_VERSION}" \
  org.opencontainers.image.url="https://hub.docker.com/r/casjaysdevdocker/${IMAGE_NAME}" \
  org.opencontainers.image.vcs-url="https://github.com/casjaysdevdocker/${IMAGE_NAME}" \
  org.opencontainers.image.url.source="https://github.com/casjaysdevdocker/${IMAGE_NAME}" \
  org.opencontainers.image.documentation="https://hub.docker.com/r/casjaysdevdocker/${IMAGE_NAME}" \
  org.opencontainers.image.description="Containerized version of ${IMAGE_NAME}" \
  com.github.containers.toolbox="false"

ENV LANG=en_US.UTF-8 \
  ENV=~/.bashrc \
  SHELL="/bin/bash" \
  PORT="${SERVICE_PORT}" \
  TERM="xterm-256color" \
  PHP_SERVER="${PHP_SERVER}" \
  CONTAINER_NAME="${IMAGE_NAME}" \
  TZ="${TZ:-America/New_York}" \
  TIMEZONE="${TZ:-$TIMEZONE}" \
  HOSTNAME="casjaysdev-${IMAGE_NAME}"

COPY --from=build /. /

USER root
WORKDIR /root

VOLUME [ "/config","/data" ]

EXPOSE $EXPOSE_PORTS

#CMD [ "" ]
ENTRYPOINT [ "tini", "-p", "SIGTERM", "--", "/usr/local/bin/entrypoint.sh" ]
HEALTHCHECK --start-period=1m --interval=2m --timeout=3s CMD [ "/usr/local/bin/entrypoint.sh", "healthcheck" ]
