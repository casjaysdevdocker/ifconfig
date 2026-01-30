#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202509161145-git
# @@Author           :  CasjaysDev
# @@Contact          :  CasjaysDev <docker-admin@casjaysdev.pro>
# @@License          :  MIT
# @@ReadME           :
# @@Copyright        :  Copyright 2023 CasjaysDev
# @@Created          :  Mon Aug 28 06:48:42 PM EDT 2023
# @@File             :  05-custom.sh
# @@Description      :  script to run custom
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# shellcheck shell=bash
# shellcheck disable=SC2016
# shellcheck disable=SC2031
# shellcheck disable=SC2120
# shellcheck disable=SC2155
# shellcheck disable=SC2199
# shellcheck disable=SC2317
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
set -o pipefail
[ "$DEBUGGER" = "on" ] && echo "Enabling debugging" && set -x$DEBUGGER_OPTIONS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set env variables
exitCode=0

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Predefined actions

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Main script

# Install echoip binary
ECHOIP_VERSION="${ECHOIP_VERSION:-latest}"
echo "Installing echoip binary using Go"

# Install Go if not present (Alpine should have it in base image)
if ! command -v go &>/dev/null; then
  echo "Go not found, installing..."
  pkmgr install go || apk add --no-cache go
fi

# Build and install echoip
if command -v go &>/dev/null; then
  echo "Building echoip from source..."
  export GOPATH="/tmp/go"
  export GO111MODULE=on
  if go install github.com/mpolden/echoip/cmd/echoip@latest 2>/dev/null; then
    mkdir -p /opt/echoip
    mv "$GOPATH/bin/echoip" /opt/echoip/echoip
    chmod +x /opt/echoip/echoip
    rm -rf "$GOPATH"
    echo "echoip binary installed successfully"
  else
    echo "Failed to build echoip from source"
    exitCode=1
  fi
else
  echo "Go compiler not available, cannot build echoip"
  exitCode=1
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set the exit code
#exitCode=$?
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
exit $exitCode
