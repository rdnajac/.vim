;; extends
; `command! Foo lua something()`
((command_statement
   repl: (command) @lua_block
   (#match? @lua_block "^lua\\s"))
 (#set! injection.language "lua"))

; printf() format strings
((call_expression
   function: (identifier) @_func
   (#eq? @_func "printf")
   (string_literal) @injection.content)
 (#set! injection.language "printf"))
