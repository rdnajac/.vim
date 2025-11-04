# formatoptions: fo-table (default `tcqj`)

| opt | Description                                                                                                              |
| --- | ------------------------------------------------------------------------------------------------------------------------ |
| `t` | Auto-wrap text using 'textwidth'                                                                                         |
| `c` | Auto-wrap comments using 'textwidth', inserting the current comment leader automatically.                                |
| `r` | Automatically insert the current comment leader after hitting <Enter> in Insert mode.                                    |
| `o` | Automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode.                                 |
| `/` | With `o`: do not insert the comment leader for a // comment after a statement, only when // is at the start of the line. |
| `q` | Allow formatting of comments with "gq". or when the comment leader changes.                                              |
| `w` | Trailing white space indicates a paragraph continues in the next line.                                                   |
| `a` | Automatic formatting of paragraphs.                                                                                      |
| `n` | When formatting text, recognize numbered lists using `formatlistpat`                                                     |
| `2` | When formatting text, use the indent of the second line of a paragraph                                                   |
| `l` | Long lines are not automatically broken in insert mode                                                                   |
| `j` | Where it makes sense, remove a comment leader when joining lines. For                                                    |

> [NOTE]:
> with fo-o, use `CTRL-U` to delete unwanted comment leaders in insert mode
