; INFO: this requires custom Treesitter parser: `TSInstall comments`
; https://github.com/nvim-treesitter/nvim-treesitter#adding-queries
; also see https://github.com/stsewd/tree-sitter-comment/issues/34
; ──────────────────────────────────────────────────────────────────────────────

; highlight `source_code` nodes within comments as strings
; for more information, see `:h treesitter-query` and `h: treesitter-language-injections`
; TODO: make this work for comments that span multiple lines
; TODO: don't highlight unclosed backticks like `this
((source_code) @string
 (#set! "priority" 9999))

