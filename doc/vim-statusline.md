# statusline

## fields

| field  | meaning                     |
| ------ | --------------------------- |
| `-`    | left justify                |
| `0`    | leading zeroes              |
| minwid | minimum width               |
| maxwid | maximum width               |
| item   | one letter code (see below) |

## items

- `N` for number
- `S` for string
- `F` for flags as described below
- `-` not applicable

| item | type | meaning                                                                                                                                |
| ---- | ---- | -------------------------------------------------------------------------------------------------------------------------------------- |
| `f`  | S    | Path to the file in the buffer, as typed or relative to current directory.                                                             |
| `F`  | S    | Full path to the file in the buffer.                                                                                                   |
| `t`  | S    | File name (tail) of file in the buffer.                                                                                                |
| `m`  | F    | Modified flag, text is "[+]"; "[-]" if 'modifiable' is off.                                                                            |
| `M`  | F    | Modified flag, text is ",+" or ",-".                                                                                                   |
| `r`  | F    | Readonly flag, text is "[RO]".                                                                                                         |
| `R`  | F    | Readonly flag, text is ",RO".                                                                                                          |
| `h`  | F    | Help buffer flag, text is "[help]".                                                                                                    |
| `H`  | F    | Help buffer flag, text is ",HLP".                                                                                                      |
| `w`  | F    | Preview window flag, text is "[Preview]".                                                                                              |
| `W`  | F    | Preview window flag, text is ",PRV".                                                                                                   |
| `y`  | F    | Type of file in the buffer, e.g., "[vim]". See 'filetype'.                                                                             |
| `Y`  | F    | Type of file in the buffer, e.g., ",VIM". See 'filetype'.                                                                              |
| `q`  | S    | "[Quickfix List]", "[Location List]" or empty.                                                                                         |
| `k`  | S    | Value of "b:keymap_name" or 'keymap' when `:lmap` mappings are being used: "<keymap>"                                                  |
| `n`  | N    | Buffer number.                                                                                                                         |
| `b`  | N    | Value of character under cursor.                                                                                                       |
| `B`  | N    | As above, in hexadecimal.                                                                                                              |
| `o`  | N    | Byte number in file of byte under cursor, first byte is 1.                                                                             |
| `O`  | N    | As above, in hexadecimal.                                                                                                              |
| `l`  | N    | Line number.                                                                                                                           |
| `L`  | N    | Number of lines in buffer.                                                                                                             |
| `c`  | N    | Column number (byte index).                                                                                                            |
| `v`  | N    | Virtual column number (screen column).                                                                                                 |
| `V`  | N    | Virtual column number as -{num}. Not displayed if equal to 'c'.                                                                        |
| `p`  | N    | Percentage through file in lines as in `CTRL-G`.                                                                                       |
| `P`  | S    | Percentage through file of displayed window. This is like the percentage described for 'ruler'. Always 3 in length, unless translated. |
| `S`  | S    | 'showcmd' content, see 'showcmdloc'.                                                                                                   |
| `a`  | S    | Argument list status as in default title. ({current} of {max}) Empty if the argument file count is zero or one.                        |
| `{`  | NF   | Evaluate expression between "%{" and "}" and substitute result.                                                                        |
| `{%` | -    | Same except the result of the expression is re-evaluated as a statusline format string.                                                |
| `%}` | -    | End of "{%" expression                                                                                                                 |
| `(`  | -    | Start of item group. Can be used for setting the width and alignment of a section. Must be followed by `%)` somewhere.                 |
| `)`  | -    | End of item group. No width fields allowed.                                                                                            |

### more items

    T N   For 'tabline': start of tab page N label.  Use %T or %X to end
          the label.  Clicking this label with left mouse button switches
          to the specified tab page, while clicking it with middle mouse
          button closes the specified tab page.
    X N   For 'tabline': start of close tab N label.  Use %X or %T to end
          the label, e.g.: %3Xclose%X.  Use %999X for a "close current
          tab" label.  Clicking this label with left mouse button closes
          the specified tab page.
    @ N   Start of execute function label. Use %X or %T to end the label,
          e.g.: %10@SwitchBuffer@foo.c%X.  Clicking this label runs the
          specified function: in the example when clicking once using left
          mouse button on "foo.c", a `SwitchBuffer(10, 1, 'l', '    ')`
          expression will be run.  The specified function receives the
          following arguments in order:
          1. minwid field value or zero if no N was specified
          2. number of mouse clicks to detect multiple clicks
          3. mouse button used: "l", "r" or "m" for left, right or middle
             button respectively; one should not rely on third argument
             being only "l", "r" or "m": any other non-empty string value
             that contains only ASCII lower case letters may be expected
             for other mouse buttons
          4. modifiers pressed: string which contains "s" if shift
             modifier was pressed, "c" for control, "a" for alt and "m"
             for meta; currently if modifier is not pressed string
             contains space instead, but one should not rely on presence
             of spaces or specific order of modifiers: use |stridx()| to
             test whether some modifier is present; string is guaranteed
             to contain only ASCII letters and spaces, one letter per
             modifier; "?" modifier may also be present, but its presence
             is a bug that denotes that new mouse button recognition was
             added without modifying code that reacts on mouse clicks on
             this label.
          Use |getmousepos()|.winid in the specified function to get the
          corresponding window id of the clicked item.
    < -   Where to truncate line if too long.  Default is at the start.
          No width fields allowed.
    = -   Separation point between alignment sections.  Each section will
          be separated by an equal number of spaces.  With one %= what
          comes after it will be right-aligned.  With two %= there is a
          middle part, with white space left and right of it.
          No width fields allowed.
    # -   Set highlight group.  The name must follow and then a # again.
          Thus use %#HLname# for highlight group HLname.  The same
          highlighting is used, also for the statusline of non-current
          windows.
    * -   Set highlight group to User{N}, where {N} is taken from the
          minwid field, e.g. %1*.  Restore normal highlight with %* or %0*.
          The difference between User{N} and StatusLine will be applied to
          StatusLineNC for the statusline of non-current windows.
          The number N must be between 1 and 9.  See |hl-User1..9|
