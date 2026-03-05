# .vim

My (n)vim configuration.

## Startup

Goal: be as compatible with vim as possible. 

~/.config/nvim symlinked to ~/.vim

1. Source `vimrc`


## Profiling

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

## Snacks

Snacks.image can render math, like the formula for null hypothesis testing:

$$
Z = \frac{\bar{X} - \mu}{\sigma / \sqrt{n}}
$$

## Bugs

### luals doesn't work on first buffer loaded

`https://github.com/folke/lazydev.nvim/issues/136#issuecomment-3773651709`

MasonInstall lua-kanguage-server@3.16.4

### SIGSEGV on startup

Crash when `packadd` is called during `:runtime` or `:source` execution

https://github.com/neovim/neovim/issues/38119

roll back to `cf874cee330db7996e879891b7be0ffa3bd6a535`

## Resources and references

- [Five Minute Vimscript](http://andrewscala.com/vimscript/)
- [Learn Vimscript the Hard Way](https://learnvimscriptthehardway.stevelosh.com/)
- Google's Vimscript Style Guide:
  - [Vimscript Style Guide](https://google.github.io/styleguide/vimscriptguide.xml)
  - [Vimscript Full Style Guide](https://google.github.io/styleguide/vimscriptfull.xml)
- [Idiomatic Vimrc](https://github.com/romainl/idiomatic-vimrcr)
- [No Plugins](https://github.com/changemewtf/no_plugins)

- [Neovim](https://neovim.io/)
- [`lazy.nvim` plugin manager](https://lazy.folke.io/)
- [LazyVim](https://www.lazyvim.org)
- [`lsp-zero`](https://lsp-zero.netlify.app/docs/)

---

> Any sufficiently complicated set of Vim plugins contains an ad hoc, informally-
> specified, bug-ridden, slow implementation of half of Vim's features.
>
> _robertmeta's tenth rule_
