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

function git_dirty() {
  expr `git status --porcelain 2>/dev/null| wc -l`
}

function set_git_prompt() {
  set_git_branch

  if test ${GIT_BRANCH}; then
    local git_dirty_prompt;
    if [[ `git_dirty` -eq 0 ]]; then
      git_dirty_prompt=""
    else
      git_dirty_prompt=" ${EMY}✗${RESET}"
    fi

    GIT_PROMPT=" ${EMB}git:(${EMR}${GIT_BRANCH}${EMB})${git_dirty_prompt}${RESET}"
  else
    unset GIT_PROMPT
  fi
}

function update_prompt() {
  local EXIT="$?" # this has to be first
  set_git_prompt
  set_virtualenv

  if [ $EXIT -eq 0 ]
  then
    ret_status="${EMG}λ ${RESET}"
  else
    ret_status="${EMR}λ ${RESET}"
  fi

  PS1="${ret_status}${PYTHON_VIRTUAL_ENV}${EMC}\w${RESET}${GIT_PROMPT} ${RESET}"
}

PROMPT_COMMAND=update_prompt

# Set directory colors
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
