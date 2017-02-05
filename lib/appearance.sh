#!/usr/bin/env bash

function git_branch_name() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/';
}

function set_git_branch() {
  unset GIT_BRANCH
  local branch=`git_branch_name`;

  if test $branch
  then
    GIT_BRANCH="${branch}"
  fi
}

function set_git_prompt() {
  set_git_branch

  if test ${GIT_BRANCH}; then
    GIT_PROMPT=" ${EMB}git:(${EMR}${GIT_BRANCH}${EMB})${RESET}"
  else
    unset GIT_PROMPT
  fi
}

function update_prompt() {
  local EXIT="$?" # this has to be first
  set_git_prompt

  if [ $EXIT -eq 0 ]
  then
    ret_status="${EMG}λ ${RESET}"
  else
    ret_status="${EMR}λ ${RESET}"
  fi

  PS1="${ret_status}${EMC}\w${RESET}${GIT_PROMPT} ${RESET}"
}

PROMPT_COMMAND=update_prompt
