#! /usr/bin/env bash

# Note: Since this script is indended to be sourced, anything declared
#   will be visible throughout the shell session, which may cause name
#   conflicts.


COLOR_RED=`tput setaf 1`
COLOR_CYAN=`tput setaf 6`
COLOR_RESET=`tput sgr0`
LOG_ERROR_CODE=$((0))

function log_error() {
  echo "${COLOR_RED}ERROR${COLOR_RESET} $@" >&2

  LOG_ERROR_CODE=$((1))
}

function log_info() {
  echo "${COLOR_CYAN}INFO${COLOR_RESET} $@" >&2
}


SPOT_SDK_LIBS="/opt/boston-dynamics/spot-cpp-sdk/lib"
VCPKG_INSTALL_DIR="/opt/microsoft/vcpkg"

if [[ ! -d "${SPOT_SDK_LIBS}" ]]; then
  log_error "${SPOT_SDK_LIBS} does not exist."
fi

if [[ ! -d "${VCPKG_INSTALL_DIR}" ]]; then
  log_error "${VCPKG_INSTALL_DIR} does not exist."
fi

REPO_DIR="$(git rev-parse --show-toplevel)"
if [[ $? != 0 ]]; then
  log_error "the current working directory is not a git repository."
elif [[ ":${ROS_PACKAGE_PATH}:" != *":${REPO_DIR}:"* ]]; then
  export ROS_PACKAGE_PATH="${REPO_DIR}:${ROS_PACKAGE_PATH}"
  log_info "${REPO_DIR} added to ROS_PACKAGE_PATH"
fi
unset REPO_DIR


return $LOG_ERROR_CODE
