# pipes

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

## more examples

- `:r !date^@-join`
- `:r !uuencode file file`
- `:w !sudo tee %`
- `:w !sudo dd of=%`
- `:%! xxd [-r]`
- `:%! column -t`
- `:%! sort`
