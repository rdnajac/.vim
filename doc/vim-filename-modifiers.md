# Filename Modifiers

| mod            | description                                |
| -------------- | ------------------------------------------ |
| `:p`           | full **p**ath                              |
| `:~`           | relative to `$HOME`                        |
| `:.`           | relative to pwd                            |
| `:h`           | **h**ead (drop the last component)         |
| `:t`           | **t**ail (last component only)             |
| `:r`           | **r**oot (remove the extension `.*`)       |
| `:e`           | **e**xtension (excludes the `.`)           |
| `:s?pat?sub?`  | **s**ubstitute first occurrence of pattern |
| `:gs?pat?sub?` | as above, but **g**lobal (all occurrences) |
| `:S`           | **s**hellescape (must be last one)         |

> [!NOTE]
> `:p:h` on a directory name results on the directory name itself
> (without > trailing slash) use `:p:h:h` to get the parent directory.`
