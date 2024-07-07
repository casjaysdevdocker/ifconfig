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
GEOIP_DATA_DIR="${1:-/opt/echoip/geoip}"
GEOIP_DOWNLOAD_URL="https://github.com/P3TERX/GeoLite.mmdb/raw/download"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
for f in GeoLite2-ASN GeoLite2-City GeoLite2-Country; do
  printf '%s : ' "Attempting to download from $GEOIP_DOWNLOAD_URL/$f.mmdb"
  if curl -q -LSsf "$GEOIP_DOWNLOAD_URL/$f.mmdb" -o "$GEOIP_DATA_DIR/$f.tmp"; then
    mv -f "$GEOIP_DATA_DIR/$f.tmp" "$GEOIP_DATA_DIR/$f.mmdb"
    [ -f "$GEOIP_DATA_DIR/$f.mmdb" ] && echo "Installed to $GEOIP_DATA_DIR/$f.mmdb"
  else
    echo "Failed to update $GEOIP_DATA_DIR/$f.mmdb"
    exit 10
  fi
done
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
