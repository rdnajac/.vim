# .vim

My (n)vim configuration.

## TODO

- [ ] Who is VIMDIR? VIMHOME? PACKDIR???
  - they're all g: variables
  - they're present even with `-u NONE`
  - neovim only
- [x] vim-nvim notification library
- [ ] <M-.> does what?
- [ ] `edit = '[ -z "$NVIM" ] && (nvim -- {{filename}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{filename}})'`

## Bugs

`https://github.com/folke/lazydev.nvim/issues/136#issuecomment-3773651709`

## vim pipes

Taken from an infographic attributed to
[Barry Arthur](http://of-vim-and-vigor.blogspot.com)

| cmd                  | repeatable? | undoable? | example                                               |
| -------------------- | ----------- | --------- | ----------------------------------------------------- |
| read (`:help :r!`)   | no          | yes       | `:0r !cmd` puts cmd output into top of buffer         |
| write (`:help :w_c`) | no          | no        | `:w !cmd` is not the same as `:w!cmd`, note the space |
| filter (`:help :!`)  | yes\*       | yes\*     | `!!cmd` is not the same as `:.                        |

> \* `!!` form is dot-repeatable;
> motion forms are repeatable and undoable

Notes:

- use `:silent` to suppress `Press <Enter>` prompts
- use `:redraw` to fix the screen if something was printed with `:silent`
- pay attention to how `|` behaves in the `!` command (shell pipe)
- use <C-j> to print `^@` to use as newlines in `!`

### more examples

- `:r !date^@-join`
- `:r !uuencode file file`
- `:w !sudo tee %`
- `:w !sudo dd of=%`
- `:%! xxd [-r]`
- `:%! column -t`
- `:%! sort`

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

### [Vim Galore](https://github.com/mhinz/vim-galore?tab=readme-ov-file#editing-remote-files)

There is a section on editing remote files that suggests
reading these help files:

- `:h netrw-netrc`
- `:h netrw-ssh-hack`
- `:h netrw_ssh_cmd`

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

## Snacks

Snacks.image can also render math, like the formula for null hypothesis testing:

$$
Z = \frac{\bar{X} - \mu}{\sigma / \sqrt{n}}
$$

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
