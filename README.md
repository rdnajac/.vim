# .vim

My (n)vim configuration.

## Startup

Goal: be as compatible with vim as possible.

`~/.config/nvim` symlinked to `~/.vim`

1. Source `vimrc`
2. ???

### vim.loader

`https://github.com/neovim/neovim/discussions/36905`

## nvim

### Profiling

Profiling with [LuaJIT](https://luajit.org/ext_profiler.html)

```lua
require('jit.p').start('ri1', '/tmp/prof')
-- do stuff
-- ...
require('jit.p').stop()
```

## Spell Checking

Download [cspell](http://streetsidesoftware.github.io/cspell/)
dictionaries from [cspell-dicts](https://github.com/streetsidesoftware/cspell-dicts/tree/main/dictionaries)

```sh
# lists all dictionaries
npx cspell dictionaries
```

### spell.vim

```vim
" see `:h :mkspell` and treesitter's `nospell`
let &spellfile = g:['vimrc#dir'] . '/.spell/en.utf-8.add'
autocmd FileType tex,markdown,rmd,quarto setlocal spell
```

## Snacks

Snacks.image can render math inline, $z=a+bi$, or in a `$$` block:

$$
Z = \frac{\bar{X} - \mu}{\sigma / \sqrt{n}}
$$

## Bugs

### vint

vint from mason needs latest [vimlparser](https://github.com/vim-jp/vim-vimlparser)

https://raw.githubusercontent.com/Vimjas/vint/94d2cb3fd9526a89911b7c1e083a1fd78bace729/vint/_bundles/__init__.py

local build works?

clone the repo
navigate to the directory
install with `pipx install -e .`

## Resources and references

- [Five Minute Vimscript](http://andrewscala.com/vimscript/)
- [Learn Vimscript the Hard Way](https://learnvimscriptthehardway.stevelosh.com/)
- Google's Vimscript Style Guide:
  - [Vimscript Style Guide](https://google.github.io/styleguide/vimscriptguide.xml)
  - [Vimscript Full Style Guide](https://google.github.io/styleguide/vimscriptfull.xml)
- [Idiomatic Vimrc](https://github.com/romainl/idiomatic-vimrcr)
- [No Plugins](https://github.com/changemewtf/no_plugins)

- [Neovim](https://neovim.io/)

---

> Any sufficiently complicated set of Vim plugins contains an ad hoc, informally-
> specified, bug-ridden, slow implementation of half of Vim's features.
>
> _robertmeta's tenth rule_
