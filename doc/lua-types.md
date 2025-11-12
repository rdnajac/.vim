# Advanced types and LuaCATS (Lua Comment And Type System) annotations

| Type            | Document As:                             |
| --------------- | ---------------------------------------- |
| Union Type      | `TYPE_1 <Bar> TYPE_2 `                   |
| Array           | `VALUE_TYPE[]`                           |
| Tuple           | `[VALUE_TYPE, VALUE_TYPE]`               |
| Dictionary      | `{ [string]: VALUE_TYPE }`               |
| Key-Value Table | `table<KEY_TYPE, VALUE_TYPE>`            |
| Table literal   | `{ key1: VALUE_TYPE, key2: VALUE_TYPE }` |
| Function        | `fun(PARAM: TYPE): RETURN_TYPE`          |


Annotations may need to be placed in parentheses in certain situations, such as
when defining an array that contains multiple value types:

```lua
---@type (string | integer)[]
local myArray = {}
```
