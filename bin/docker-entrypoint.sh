#!/usr/bin/env sh
# Set bash options
[ -n "$DEBUG" ] && set -x
set -o pipefail
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
GEOIP="-a /data/GeoLite2-ASN.mmdb -c /data/GeoLite2-City.mmdb -f /data/GeoLite2-Country.mmdb"
OPTS="-H x-forwarded-for -r -s -p"
CONFIG="-t /config/web"

export TZ="${TZ:-America/New_York}"
export HOSTNAME="${HOSTNAME:-casjaysdev-ifconfig}"

[ -n "${TZ}" ] && echo "${TZ}" >/etc/timezone
[ -n "${HOSTNAME}" ] && echo "${HOSTNAME}" >/etc/hostname
[ -n "${HOSTNAME}" ] && echo "127.0.0.1 $HOSTNAME localhost" >/etc/hosts
[ -f "/usr/share/zoneinfo/${TZ}" ] && ln -sf "/usr/share/zoneinfo/${TZ}" "/etc/localtime"

[ -f "/config/env" ] && . /config/env

case $1 in
bash | sh | shell)
  exec /bin/bash -l
  ;;
healthcheck)
  curl -q -LSsf -I --fail http://localhost:8080/json || exit 10
  ;;
*)
  if [ -f /opt/echoip/echoip ]; then
    echo "starting echoip"
    /opt/echoip/echoip $GEOIP $OPTS $CONFIG
  else
    echo "echoip not found"
    exit 10
  fi
  ;;
esac
