#!/bin/sh

VIM_HOME=${VIM_HOME:-$HOME/.vim}
DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site
PACK_DIR=${DATA_HOME}/pack

ln -sfnv "$VIM_HOME"/pack/dev "$PACK_DIR"/dev
ln -sfnv "$PACK_DIR"/core "$VIM_HOME"/pack/core
