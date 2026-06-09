# The Command (or Cmd) ⌘ Key

[macOS: Cut, copy, paste, and other common shortcuts](https://support.apple.com/en-us/102650)

generates the <D-…> modifier in vim

known as the `super` key in ghostty

## maps

table of command + key maps

| key |  macOS    | 👻 ghostty              |  vim            |
| --- | ---------- | ----------------------- | ---------------- |
| a   | Select all | select_all              | -                |
| b   | -          | -                       | <D-b>            |
| c   | Copy       | copy_to_clipboard:mixed | -                |
| d   | -          | New split:right         | -                |
| e   | -          | search_selection        | -                |
| f   | Find       | start_search            | -                |
| g   | Find again | navigate_search:next    | -                |
| h   | Hide       | -                       | -                |
| i   | -          | -                       | <D-i>            |
| j   | -          | scroll_to_selection     | -                |
| k   | -          | clear_screen            | -                |
| l   | -          | -                       | <D-l>            |
| m   | Minimize   | -                       | -                |
| n   | New window | new_window              | -                |
| o   | Open       | -                       | -                |
| p   | Print      | -                       | :Hardcopy (TODO) |
| q   | Quit       | quit                    | -                |
| r   | -          | -                       | :Restart         |
| s   | Save       | -                       | :write ++p       |
| t   | New tab    | new_tab                 | -                |
| u   | -          | -                       | :Undotree (TODO) |
| v   | Paste      | paste_from_clipboard    | -                |
| w   | Close      | close_surface           | -                |
| x   | Cut        | -  | -                |
| y   | -          | -                       | <D-y>            |
| z   | Undo       | undo                    | -            |


" Command-Comma (,): Open settings (preferences) for the front app.
" Command-Tab: Switch to the next most recently used app among your open apps.
" Command–Grave accent (`): Switch between the windows of the app you're using. (The character on the second key varies by keyboard. It's generally the key above the Tab key and to the left of the number 1.)
" Command–Space bar: Show or hide the Spotlight search field. To perform a Spotlight search from a Finder window, press Option–Command–Space bar. (In some versions of macOS, if you use multiple input sources to type in different languages, these shortcuts change input sources. Learn how to change a conflicting keyboard shortcut.)

" Control-Command-F: Use or stop using the app in full screen, if supported by the app.
" Control-Command-N: Create a new folder that contains the currently selected items.
" Control–Command–Space bar or Fn-E: Show the Character Viewer, from which you can choose emoji and other symbols.
" Fn-Q: Create a Quick Note.
" Option-Command-Esc: Force quit an app.
" Shift-Command-5: In macOS Mojave or later, take a screenshot or make a screen recording. Or use Shift-Command-3 or Shift-Command-4 for screenshots. Learn more about screenshots.
" Shift-Command-N: Create a new empty folder in the Finder.
" Space bar: Use Quick Look to preview the selected item.
