#!/bin/sh
#
# Vimfect: Vim plugin management using Git submodules.

set -eu

# Global variables
SCRIPT_NAME=$(basename "$0")
PLUGIN_DIR="pack/plugins/start"

#######################################
# Color print functions
# Arguments:
#   $1: Message to print.
#######################################
pr_info() { printf "\033[33m%s\033[0m\n" "$1"; }
pr_error() { printf "\033[31m%s\033[0m\n" "$1" >&2; }

#######################################
# Bail function to handle errors
# Globals:
#   None
# Arguments:
#   $1: Error message to print.
#   $2: Exit status code (optional).
#######################################
bail() { pr_error "$1"; exit "${2:-1}"; }

#######################################
# Add a Git repository as a submodule and commit the change.
# Globals:
#   None
# Arguments:
#   $1: Repository URL or path.
#######################################
vimfect_plug() {
  [ $# -eq 0 ] && bail "No repository provided."

  repo=$(echo "$1" | sed 's|git@github.com:|https://github.com/|' | sed 's|\.git$|.git|')
  case "$repo" in
    https://github.com/*) ;;
    *) repo="https://github.com/$repo" ;;
  esac

  if git submodule add "$repo"; then
    git commit -m "vimfect: $repo"
    pr_info "added $repo"
  else
    bail "error adding $repo"
  fi
}

#######################################
# Synchronize Git submodules.
# Globals:
#   None
# Arguments:
#   None
#######################################
vimfect_sync() {
  pr_info "syncing Vim plugins..."
  if ! git submodule sync || ! git submodule update --init --recursive; then
    bail "failed to sync submodules."
  fi
}

#######################################
# Purge a Git submodule.
# Globals:
#   None
# Arguments:
#   $1: Submodule directory name.
#######################################
#######################################
# Purge a Git submodule.
# Globals:
#   None
# Arguments:
#   $1: Submodule directory name.
#######################################
vimfect_purge() {
  [ $# -eq 0 ] && bail "No submodule specified."

  submodule_dir="$PLUGIN_DIR/$1"
  pr_info "purging submodule $submodule_dir..."

  (
    cd "$(git rev-parse --show-toplevel)" || bail "failed to move to the root of the repository"
    if ! git submodule deinit -f -- "$submodule_dir"; then
      pr_error "Failed to deinit submodule $submodule_dir"
    fi
    if ! rm -rf ".git/modules/$submodule_dir"; then
      pr_error "Failed to remove .git/modules/$submodule_dir"
    fi
    if ! git rm --cached "$submodule_dir"; then
      pr_error "Failed to remove $submodule_dir from index"
    fi
    if ! rm -rf "$submodule_dir"; then
      pr_error "Failed to remove directory $submodule_dir"
    fi
    git add .
    if ! git commit -m "purged submodule $submodule_dir"; then
      pr_error "Failed to commit removal of $submodule_dir"
    fi
  )
}

#######################################
# Print help message and exit
# Globals:
#   SCRIPT_NAME
# Arguments:
#   $1: Exit status code
#######################################
usage() { bail "Usage: ${SCRIPT_NAME} [plug <repository>|sync|purge <submodule>]" 2; }

#######################################
# Main function to handle plugin management.
# Globals:
#   SCRIPT_NAME
# Arguments:
#   $@: Command line arguments passed to the script.
#######################################
main() {
  [ $# -eq 0 ] && usage

  case "$1" in
    plug) shift; vimfect_plug "$@" ;;
    sync) vimfect_sync ;;
    purge) shift; vimfect_purge "$@" ;;
    *) usage ;;
  esac
}

main "$@"
