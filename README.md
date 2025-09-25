# .vim

My (n)vim configuration.

## nvim

Global accessor `nv`

## TODO

- [ ] Who is VIMDIR? VIMHOME?

remote ui stuff

- [ ] start an instance of nvim in the background without a ui attached
- [ ] on startup, attach to ui, then try out remote plugins and eval expr
- [ ] neovim as an http server attach to instance view the buffers (logfiles)

## Snacks

### Image

null hypothesis testing

$$
Z = \frac{\bar{X} - \mu}{\sigma / \sqrt{n}}
$$

## netrw

`h: netrw` provides 'ssh hints':

```vimdoc
Thomer Gil has provided a hint on how to speed up netrw+ssh:
http://thomer.com/howtos/netrw_ssh.html

Alex Young has several hints on speeding ssh up:
http://usevim.com/2012/03/16/editing-remote-files/
```

Both pages are offline...

- <https://web.archive.org/web/20120319233142/https://www.usevim.com/2012/03/16/editing-remote-files/>

- <https://web.archive.org/web/20120319233142/https://www.usevim.com/2012/03/16/editing-remote-files/#expand>

Luckily they have been cached by the Internet Archive.

## Spell Checking

Download [cspell](http://streetsidesoftware.github.io/cspell/)
dictionaries from [cspell-dicts](https://github.com/streetsidesoftware/cspell-dicts/tree/main/dictionaries)

### list of dictionaries

```sh
npx cspell dictionaries
```

## QoL

Some plugins save their state in the cache. If you want to reset the state of a
plugin, you can delete the cache.

```sh
rm -rf ~/.cache/nvim
```

Others will save files to ~/.local/share/nvim. You can delete these files, too.

```sh
rm -rf ~/.local/share/nvim
```

| `<plugin>`       | note                        | `<path>`                      |
| ---------------- | --------------------------- | ----------------------------- |
| `blink`          | Blink.cmp completion cache  | `~/.local/share/nvim/blink`   |
| `mason`          | Mason packages and binaries | `~/.local/share/nvim/mason`   |
| `Snacks.scratch` | Snacks scratch buffers      | `~/.local/share/nvim/scratch` |
| `Snacks.picker`  | Snacks picker histories     | `~/.local/share/nvim/snacks`  |

Finally, there is `~/.local/state/nvim`, where we have:

- backup/
- sessions/
- shada/
- swap/
- undo/
- log files

To clean up:

```sh
rm -rf ~/.local/state/nvim/{*.log,sessions,swap,undo}
```

## Cheatsheet

<!-- TODO: add image sources -->

![Vim Cheatsheet](./assets/vim-cheatsheet.png)

## Pipes

![Vim Pipes](./assets/vim-pipes.png)

## Resources and references

- [Five Minute Vimscript](http://andrewscala.com/vimscript/)
- [Learn Vimscript the Hard Way](https://learnvimscriptthehardway.stevelosh.com/)
- Google's Vimscript Style Guide:
  - [Vimscript Style Guide](https://google.github.io/styleguide/vimscriptguide.xml)
  - [Vimscript Full Style Guide](https://google.github.io/styleguide/vimscriptfull.xml)
- [Idiomatic Vimrc](https://github.com/romainl/idiomatic-vimrcr)
- [No Plugins](https://github.com/changemewtf/no_plugins)

- [Neovim](https://neovim.io/)
- [Neovim config without plugins](https://boltless.me/posts/neovim-config-without-plugins-2025/)
- [`lazy.nvim` plugin manager](https://lazy.folke.io/)
- [LazyVim](https://www.lazyvim.org)
- [`lsp-zero`](https://lsp-zero.netlify.app/docs/)

---

> Any sufficiently complicated set of Vim plugins contains an ad hoc, informally-
> specified, bug-ridden, slow implementation of half of Vim's features.
>
> _robertmeta's tenth rule_
