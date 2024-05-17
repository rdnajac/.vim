#!/bin/sh
#
# A Vim plugin manager script to add and sync Git submodules for Vim plugins.

set -eu

#######################################
# Color print functions
# Arguments:
#   $1: Message to print.
#######################################
pr_info() { printf "\033[33m%s\033[0m\n" "$1"; }
pr_error()  { printf "\033[31m%s\033[0m\n" "$1" >&2; }

#######################################
# Add a Git repository as a submodule and commit the change.
# Globals:
#   None
# Arguments:
#   $1: Repository URL or path.
#######################################
vimfect_plug()
{
  repo=$(echo "$1" | sed 's|git@github.com:|https://github.com/|' | sed 's|\.git$|.git|')
  case "$repo" in
    https://github.com/*) ;;
    *) repo="https://github.com/$repo" ;;
  esac

  if git submodule add "$repo"; then
    git commit -m "vimfect: $repo"
    pr_info "added $repo"
  else
    pr_error "error adding $repo"
  fi
}

#######################################
# Synchronize Git submodules.
# Globals:
#   None
# Arguments:
#   None
#######################################
vimfect_sync()
{
  pr_info "syncing Vim plugins..."
  if ! git submodule sync || ! git submodule update --init --recursive; then
    pr_error "failed to sync submodules."
  fi
}

#######################################
# Main function to handle plugin management.
# Globals:
#   None
# Arguments:
#   $@: Command line arguments passed to the script.
#######################################
main()
{
  cd "$(dirname "$0")" || exit 1
  if [ "$#" -gt 0 ]; then vimfect_plug "$1"; fi
  vimfect_sync
}

main "$@"

