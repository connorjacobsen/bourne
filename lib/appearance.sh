#!/usr/bin/env bash

function is_git_repository {
  git branch > /dev/null 2>&1
}

function git_branch_name() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/';
}

function set_git_branch() {
  unset BRANCH
  local branch=`git_branch_name`;

  if test $branch
  then
    BRANCH="${branch}"
  fi
}

function git_dirty() {
  expr `git status --porcelain 2>/dev/null| wc -l`
}

function set_git_prompt() {
  git_status="$(git status 2> /dev/null)"

  if [[ ${git_status} =~ "working tree clean" ]]; then
    state="${EMG}"
  elif [[ ${git_status} =~ "Changes to be committed" ]]; then
    state="${EMY}"
  else
    state="${EMR}"
  fi

  # Set arrow icon based on status against remote
  remote=""
  if [[ ${git_status} =~ "Your branch is ahead of" ]]; then
    remote="↑"
  elif [[ ${git_status} =~ "Your branch is behind" ]]; then
    remote="↓"
  elif [[ ${git_status} =~ "have diverged" ]]; then
    remote="↕"
  fi

  # Get branch name
  set_git_branch
  branch=${BRANCH}

  if test ${BRANCH}; then
    # set the final branch string
    BRANCH="${state}git:(${branch}${remote})${RESET}"
    local git_dirty_prompt;
    if [[ `git_dirty` -eq 0 ]]; then
      git_dirty_prompt=""
    else
      git_dirty_prompt=" ${EMY}✗${RESET}"
    fi

    BRANCH=" ${BRANCH}${git_dirty_prompt}${RESET}"
  else
    unset BRANCH
  fi
}

function update_prompt() {
  local EXIT="$?" # this has to be first
  set_venv_mod_prompt_modifier

  if [ $EXIT -eq 0 ]
  then
    ret_status="${EMG}λ ${RESET}"
  else
    ret_status="${EMR}λ ${RESET}"
  fi

  if is_git_repository ; then
    set_git_prompt
  else
    BRANCH=""
  fi

  PS1="${ret_status}${VENV_PROMPT_MODIFIER}${EMC}\w${RESET}${BRANCH} "
}

PROMPT_COMMAND=update_prompt

# Set directory colors
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
