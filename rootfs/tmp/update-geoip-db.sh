#!/usr/bin/env bash
# shellcheck shell=bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202407071207-git
# @@Author           :  Jason Hempstead
# @@Contact          :  git-admin@casjaysdev.pro
# @@License          :  LICENSE.md
# @@ReadME           :  init.sh --help
# @@Copyright        :  Copyright: (c) 2024 Jason Hempstead, Casjays Developments
# @@Created          :  Sunday, Jul 07, 2024 12:07 EDT
# @@File             :  init.sh
# @@Description      :  Update GeoIP databases
# @@Changelog        :  newScript
# @@TODO             :  Refactor code
# @@Other            :
# @@Resource         :
# @@Terminal App     :  no
# @@sudo/root        :  no
# @@Template         :  bash/system
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# shell check options
# shellcheck disable=SC2317
# shellcheck disable=SC2120
# shellcheck disable=SC2155
# shellcheck disable=SC2199
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename "$0")"
VERSION="202407071207-git"
HOME="${USER_HOME:-$HOME}"
USER="${SUDO_USER:-$USER}"
RUN_USER="${SUDO_USER:-$USER}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
set -o pipefail
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
for f in GeoLite2-ASN GeoLite2-City GeoLite2-Country; do
  if curl -q -LSsf "https://github.com/P3TERX/GeoLite.mmdb/raw/download/$f.mmdb" -o "/opt/echoip/geoip/$f.tmp"; then
    mv -f "/opt/echoip/geoip/$f.tmp" "/opt/echoip/geoip/$f.mmdb"
    [ -f "/opt/echoip/geoip/$f.mmdb" ] && echo "Installed $f.mmdb to /opt/echoip/geoip"
  else
    echo "Failed to update GeoIP $f"
    exit 10
  fi
done
