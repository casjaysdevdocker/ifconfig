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
trap 'exitCode=${exitCode:-$?};[ -n "$INIT_SH_TEMP_FILE" ] && [ -f "$INIT_SH_TEMP_FILE" ] && rm -Rf "$INIT_SH_TEMP_FILE" &>/dev/null' EXIT
#if [ ! -t 0 ] && { [[ "$1" = --term ]] || [ $# = 0 ]; }; then shift 1 && TERMINAL_APP="TRUE" myterminal -e "$APPNAME $*" && exit || exit 1; fi
[ "$1" = "--debug" ] && set -xo pipefail && export SCRIPT_OPTS="--debug" && export _DEBUG="on"
[ "$1" = "--raw" ] && export SHOW_RAW="true"
set -o pipefail
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
for f in GeoLite2-ASN GeoLite2-City GeoLite2-Country; do
  curl -q -LSsf "https://github.com/P3TERX/GeoLite.mmdb/raw/download/$f.mmdb" -o "/opt/echoip/geoip/$f.mmdb"
  [ -f "/opt/echoip/geoip/$f.mmdb" ] && echo "Installed $f.mmdb to /opt/echoip/geoip" || exit 10
done
