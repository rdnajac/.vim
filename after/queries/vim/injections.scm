;; extends
((comment) @injection.content
  (#set! injection.language "comment"))

; `command! Foo lua something()`
((command_statement
   repl: (command) @lua_block
   (#match? @lua_block "^lua\\s"))
 (#set! injection.language "lua"))
