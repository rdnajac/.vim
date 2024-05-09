#!/bin/bash

plug() {
  local repo="$1"
  repo="${repo/git@github.com:/https://github.com/}"
  repo="${repo%.git}.git"
  [[ "${repo#https://github.com/}" = "$repo" ]] && repo="https://github.com/$repo"
  

  if git submodule add "$repo"; then
    echo "Successfully added $repo as a submodule"
    git commit -m "vimfect: $repo "
  else
    err "Error adding $repo"
    return 1
  fi
}

vimfect_sanitize() {
}

vimfect_sync() {
  echo "Syncing Vim plugins..."
  if ! git submodule sync && git submodule update --init --recursive; then
    err "Failed to sync submodules."
    return 1
  fi
}



vimfect() {
  cd "$(dirname "$0")" || exit 1
  if [ $# -eq 0 ]; then
    vimfect_sync
  else
    plug "$1"
  fi
}

vimfect "$@"

