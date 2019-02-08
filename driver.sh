#!/usr/bin/env bash

set -eu

setup_variables() {
  while [[ ${#} -ge 1 ]]; do
    case ${1} in
      "-c"|"--clean") cleanup=true ;;
      "-j"|"--jobs") shift; jobs=$1 ;;
      "-j"*) jobs=${1/-j} ;;
      "-h"|"--help")
        cat usage.txt
        exit 0 ;;
    esac

    shift
  done

  # Turn on debug mode after parameters in case -h was specified
  set -x

  case ${REPO:=upstream} in
    "upstream")
      url=https://github.com/open-power/skiboot
      ;;
    "6.1"|"6.2")
      url=https://github.com/open-power/skiboot
      branch=skiboot-${REPO}.x
      ;;
  esac

  export CROSS=powerpc64-linux-gnu-
}

check_dependencies() {
  command -v nproc
  command -v gcc
  command -v ${CROSS}gcc
  command -v ccache
}

mako_reactor() {
  time \
  make -j"${jobs:-$(nproc)}" CROSS="$(command -v ccache) ${CROSS}" "${@}"
}


build_skiboot() {
  git clone --depth=1 -b ${branch:=master} --single-branch "${url}" skiboot
  cd skiboot

  git show -s | cat

  [[ -n "${cleanup:-}" ]] && mako_reactor clean
  mako_reactor skiboot.lid

  cd "${OLDPWD}"
}

setup_variables "${@}"
check_dependencies
build_skiboot
