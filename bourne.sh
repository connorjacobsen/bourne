#!/usr/bin/env bash

function _load_bourne_files() {
  subdirectory="$1"
  FILES="${BOURNE}/${subdirectory}/*.sh"
  for config_file in $FILES; do
    if [ -e "${config_file}" ]; then
      source $config_file
    fi
  done
}

function reload_aliases() {
  _load_bourne_files "aliases"
}

function reload_lib() {
  _load_bourne_files "lib"
}

function __bourne_init() {
  reload_lib
  reload_aliases
}
