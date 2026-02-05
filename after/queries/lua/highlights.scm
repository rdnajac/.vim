;; extends

((identifier) @namespace.builtin
  (#any-of? @namespace.builtin "vim" ))

((identifier) @string
  (#any-of? @string "nv" ))

((identifier) @module
  (#lua-match? @module "Mini.*"))
