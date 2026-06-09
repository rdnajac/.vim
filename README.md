# .vim

My (n)vim configuration.

## Startup

`~/.config/nvim` symlinked to `~/.vim`

### $MYVIMRC

```vim
let default_VIMRC = has('nvim')) ? '~/.config/nvim/init.lua' : '~/.vimrc'
```

### vim.loader

`https://github.com/neovim/neovim/discussions/36905`

## Snacks

Snacks.image can render math inline, $z=a+bi$, or in a `$$` block:

$$
Z = \frac{\bar{X} - \mu}{\sigma / \sqrt{n}}
$$

## netrw

from 'ssh hints':

- <http://thomer.com/howtos/netrw_ssh.html>
- <https://web.archive.org/web/20120319233142/https://www.usevim.com/2012/03/16/editing-remote-files/>

Also read:

- `:h netrw-netrc`
- `:h netrw-ssh-hack`
- `:h netrw_ssh_cmd`

## Bugs

## Resources and references

- [Five Minute Vimscript](http://andrewscala.com/vimscript/)
- [Learn Vimscript the Hard Way](https://learnvimscriptthehardway.stevelosh.com/)
- Google's Vimscript Style Guide:
- [Vimscript Style Guide](https://google.github.io/styleguide/vimscriptguide.xml)
- [Vimscript Full Style Guide](https://google.github.io/styleguide/vimscriptfull.xml)
- [Idiomatic Vimrc](https://github.com/romainl/idiomatic-vimrcr)
- [No Plugins](https://github.com/changemewtf/no_plugins)
- [Neovim](https://neovim.io/)

## Easter Eggs 

$VIMRUNTIME/scripts/emoji_list.lua

---

> Any sufficiently complicated set of Vim plugins contains an ad hoc, informally-
> specified, bug-ridden, slow implementation of half of Vim's features.
>
> _robertmeta's tenth rule_
