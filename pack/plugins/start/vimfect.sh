#!/bin/sh
#
# Vimfect: Vim plugin management using Git submodules.

set -eu

SCRIPT_NAME=$(basename "$0")
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
VIM_DIR="$HOME/.vim"
PLUG_DIR="$VIM_DIR/pack/plugins/start"
USAGE="Usage: ${SCRIPT_NAME} [plug <repository>|sync|purge <submodule>]"

print_info() { printf "\033[33m%s\033[0m\n" "$1"; }
print_error() { printf "\033[31m%s\033[0m\n" "$1" >&2; }
bail() { print_error "$1"; exit "${2:-1}"; }

vimfect_plug() {
  [ $# -eq 0 ] && bail "No repo. $USAGE"
  repo=$(echo "$1" | sed 's|git@github.com:|https://github.com/|' | sed 's|\.git$|.git|')
  case "$repo" in
    https://github.com/*) ;;
    *) repo="https://github.com/$repo" ;;
  esac

  if git submodule add "$repo"; then
    git commit -m "vimfect: $repo" && print_info "Added $repo"
  else
    bail "Add $repo failed"
  fi
}

vimfect_sync() {
  print_info "Syncing plugins..."
  if ! (git submodule sync && git submodule update --init --recursive); then
    bail "Sync failed"
  fi
}

vimfect_purge() {
  [ $# -eq 0 ] && bail "No submodule. $USAGE"
  submodule_dir="$PLUG_DIR/$1"
  print_info "Purging $submodule_dir..."

  git submodule deinit -f -- "$submodule_dir" || print_error "Deinit failed: $submodule_dir"
  rm -rf ".git/modules/$submodule_dir"        || print_error "Remove .git/modules failed: $submodule_dir"
  git rm --cached "$submodule_dir"            || print_error "Remove index failed: $submodule_dir"
  rm -rf "$submodule_dir"                     || print_error "Remove dir failed: $submodule_dir"
  if ! (git add . && git commit -m "Purged $submodule_dir"); then
    print_error "Commit failed: $submodule_dir"
  fi
}

main() {
  cd "$(git rev-parse --show-toplevel)" || bail "Failed to cd to repo root"

  [ "$SCRIPT_DIR" != "$PLUG_DIR" ] && bail "Script must be in $PLUG_DIR"

  [ $# -eq 0 ] && bail "$USAGE"

  case "$1" in
    plug) shift; vimfect_plug "$@" ;;
    sync) vimfect_sync ;;
    purge) shift; vimfect_purge "$@" ;;
    *) bail "$USAGE" ;;
  esac
}

(main "$@")
