# Build
FROM golang:1.15-buster AS build
WORKDIR /go/src/github.com/mpolden/echoip
COPY . .

# Must build without cgo because libc is unavailable in runtime image
ENV GO111MODULE=on CGO_ENABLED=0
RUN make

# Run
FROM casjaysdevdocker/alpine:latest as run
COPY --from=build /go/bin/echoip /opt/echoip/
COPY ./html /opt/echoip/html
COPY ./bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

FROM run
ARG BUILD_DATE="$(date +'%Y-%m-%d %H:%M')" 

LABEL \
  org.label-schema.name="ifconfig" \
  org.label-schema.description="Sow ip information" \
  org.label-schema.url="https://hub.docker.com/r/casjaysdevdocker/ifconfig" \
  org.label-schema.vcs-url="https://github.com/casjaysdevdocker/ifconfig" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.version=$BUILD_DATE \
  org.label-schema.vcs-ref=$BUILD_DATE \
  org.label-schema.license="WTFPL" \
  org.label-schema.vcs-type="Git" \
  org.label-schema.schema-version="1.0" \
  org.label-schema.vendor="CasjaysDev" \
  maintainer="CasjaysDev <docker-admin@casjaysdev.com>" 

EXPOSE 8080
WORKDIR /opt/echoip
VOLUME /opt/echoip/html

HEALTHCHECK --start-period=1m --interval=10m --timeout=3s CMD ["/usr/local/bin/docker-entrypoint.sh", "healthcheck"]
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
