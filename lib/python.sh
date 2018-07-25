#!/usr/bin/env bash

# Contains shell helper functions related to Python

function set_venv_mod_prompt_modifier() {
  unset VENV_PROMPT_MODIFIER

  # check for conda, if found, use it
  if test -n "$CONDA_DEFAULT_ENV" ; then
    local venv_name="$CONDA_DEFAULT_ENV"
  # else, check for $VIRTUAL_ENV
  elif test -n "$VIRTUAL_ENV" ; then
    local venv_name="$VIRTUAL_ENV"
  else
    local venv_name=""
  fi

  if [ -n "$venv_name" ]; then
    VENV_PROMPT_MODIFIER="${EMB}[${venv_name}]${RESET} "
  fi
}
