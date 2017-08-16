#!/usr/bin/env bash

# Contains shell helper functions related to Python

function set_virtualenv() {
  if test -z "$VIRTUAL_ENV" ; then
    PYTHON_VIRTUAL_ENV=""
  else
    PYTHON_VIRTUAL_ENV="${EMB}[`basename \"$VIRTUAL_ENV\"`]${RESET} "
  fi
}
