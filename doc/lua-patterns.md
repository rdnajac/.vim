# Lua Patterns

|symbol | meaning|
|---|---|
| `.`| all characters|
| `%a` | letters|
| `%c` | control characters|
| `%d` | digits|
| `%l` | lowercase letters|
| `%p` | punctuation characters|
| `%s` | space characters|
| `%u` | uppercase letters|
| `%w` | alphanumeric characters|
| `%x` | hexadecimal digits|
| `%z` | represents the character with representation `0`|
| `%x` | (where `x` is any non-alphanumeric character) represents the character `x`. This is the standard way to escape the magic | characters. Any punctuation character (even the non-magic) can be | preceded by a `%` when used to represent itself in a pattern.

> [!NOTE]
> The corresponding capital letters represent the opposite set...
> |
> | pattern items
> | `*` 0 or more
> | `+` at least 1
> | `-` like `*` but shortest possible match
> | `?` 0 or 1 matches
> |
> | other things to remember
> | `^` start of line
> | `$` end of line
