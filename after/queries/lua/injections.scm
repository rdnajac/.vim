;; extends
; Inject lua highlighting into <Cmd>lua ... <CR> strings
; (
;  (string
;    content: (string_content) @injection.content
;    (#lua-match? @injection.content "<Cmd>")
;    (#set! injection.language "vim"))
;  )
