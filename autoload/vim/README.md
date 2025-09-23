# Defaults                                            *defaults* *nvim-defaults*

Add these to vim sensible

```help
- Filetype detection
- Syntax highlighting 
- 
- see :highlight for a list of highlight groups colorschemes should set.

- 'autoindent' is enabled
- 'autoread' is enabled (works in all UIs, including terminal)
- 'background' defaults to "dark"
- 'backupdir' defaults to .,~/.local/state/nvim/backup//
- 'belloff' defaults to "all"
- 'comments' includes "fb:•"
- 'commentstring' defaults to ""
- 'compatible' is always disabled
- 'complete' excludes "i"
- 'completeopt' defaults to "menu,popup"
- 'define' defaults to "". The C ftplugin sets it to "^\\s*#\\s*define"
- 'diffopt' includes "linematch:40"
- 'directory' defaults to ~/.local/state/nvim/swap//
- 'display' defaults to "lastline"
- 'encoding' is UTF-8 (cf. 'fileencoding' for file-content encoding)
- 'fillchars' defaults (in effect) to "vert:│,fold:·,foldsep:│"
- 'formatoptions' defaults to "tcqj"
- 'grepprg' uses the -H and -I flags for regular grep, and defaults to using ripgrep if available
- 'hidden' is enabled
- 'history' defaults to 10000 (the maximum)
- 'hlsearch' is enabled
- 'include' defaults to "". The C ftplugin sets it to "^\\s*#\\s*include"
- 'incsearch' is enabled
- 'joinspaces' is disabled
- 'jumpoptions' defaults to "clean"
- 'langnoremap' is enabled
- 'langremap' is disabled
- 'laststatus' defaults to 2 (statusline is always shown)
- 'listchars' defaults to "tab:> ,trail:-,nbsp:+"
- 'maxsearchcount' defaults to 999
- 'mouse' defaults to "nvi", see |default-mouse| for details
- 'mousemodel' defaults to "popup_setpos"
- 'nrformats' defaults to "bin,hex"
- 'path' defaults to ".,,". The C ftplugin adds "/usr/include" if it exists.
- 'sessionoptions' includes "unix,slash", excludes "options"
- 'shortmess' includes "CF", excludes "S"
- 'sidescroll' defaults to 1
- 'smarttab' is enabled
- 'spellfile' defaults to `stdpath("data").."/site/spell/"`
- 'startofline' is disabled
- 'switchbuf' defaults to "uselast"
- 'tabpagemax' defaults to 50
- 'tags' defaults to "./tags;,tags"
- 'termguicolors' is enabled by default if Nvim can detect support from the host terminal
- 'ttimeout' is enabled
- 'ttimeoutlen' defaults to 50
- 'ttyfast' is always set
- 'undodir' defaults to ~/.local/state/nvim/undo// (|xdg|), auto-created
- 'viewoptions' includes "unix,slash", excludes "options"
- 'viminfo' includes "!"
- 'wildoptions' defaults to "pum,tagfile"
```

## Plugins

```help
- |editorconfig| plugin is enabled, .editorconfig settings are applied.
- |man.lua| plugin is enabled, so |:Man| is available by default.
- |matchit| plugin is enabled. To disable it in your config: >vim
    :let loaded_matchit = 1

- |g:vimsyn_embed| defaults to "l" to enable Lua highlighting

```
## Keymaps

```help
DEFAULT MAPPINGS
                                                        *default-mappings*
Nvim creates the following default mappings at |startup|. You can disable any
of these in your config by simply removing the mapping, e.g. ":unmap Y". If
you never want any default mappings, call |:mapclear| early in your config.

- Y |Y-default|
- <C-U> |i_CTRL-U-default|
- <C-W> |i_CTRL-W-default|
- <C-L> |CTRL-L-default|
- & |&-default|
- Q |v_Q-default|
- @ |v_@-default|
- # |v_#-default|
- * |v_star-default|
- gc |gc-default| |v_gc-default| |o_gc-default|
- gcc |gcc-default|
- |gO|
- ]d |]d-default|
- [d |[d-default|
- [D |[D-default|
- ]D |]D-default|
- <C-W>d |CTRL-W_d-default|
- |[q| |]q| |[Q| |]Q| |[CTRL-Q| |]CTRL-Q|
- |[l| |]l| |[L| |]L| |[CTRL-L| |]CTRL-L|
- |[t| |]t| |[T| |]T| |[CTRL-T| |]CTRL-T|
- |[a| |]a| |[A| |]A|
- |[b| |]b| |[B| |]B|
- |[<Space>| |]<Space>|
- LSP defaults |lsp-defaults|
  - K |K-lsp-default|
  - |v_an| |v_in|
  - gr prefix |gr-default|
    - |gra| |gri| |grn| |grr| |grt|
  - <C-S> |i_CTRL-S|
```

## Terminal

```help
DEFAULT AUTOCOMMANDS
                                                        *default-autocmds*
Default autocommands exist in the following groups. Use ":autocmd! {group}" to
remove them and ":autocmd {group}" to see how they're defined.

nvim.terminal:
- BufReadCmd: Treats "term://" buffers as |terminal| buffers. |terminal-start|
- TermClose: A |terminal| buffer started with no arguments (which thus uses
  'shell') and which exits with no error is closed automatically.
- TermRequest: The terminal emulator responds to OSC background and foreground
  requests, indicating (1) a black background and white foreground when Nvim
  option 'background' is "dark" or (2) a white background and black foreground
  when 'background' is "light". While this may not reflect the actual
  foreground/background color, it permits 'background' to be retained for a
  nested Nvim instance running in the terminal emulator.
- TermRequest: Nvim will create extmarks for shells which
  annotate their prompts with OSC 133 escape sequences, enabling users to
  quickly navigate between prompts using |[[| and |]]|.
- TermOpen: Sets default options and mappings for |terminal| buffers:
    - 'nomodifiable'
    - 'undolevels' set to -1
    - 'textwidth' set to 0
    - 'nowrap'
    - 'nolist'
    - 'nonumber'
    - 'norelativenumber'
    - 'signcolumn' set to "no"
    - 'foldcolumn' set to "0"
    - 'winhighlight' uses |hl-StatusLineTerm| and |hl-StatusLineTermNC| in
      place of |hl-StatusLine| and |hl-StatusLineNC|
    - |[[| and |]]| to navigate between shell prompts
``` 
