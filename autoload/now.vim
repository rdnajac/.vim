function! now#() abort
  " return strftime("%H:%M:%S") -- does not support ms-precision
  let total = reltimefloat(reltime())

  " Integer seconds for math
  let totalsec = float2nr(total)

  " Hours, minutes, seconds
  let h = totalsec / 3600
  let m = (totalsec % 3600) / 60
  let s = totalsec % 60

  " Milliseconds from fractional part
  let ms = float2nr((total - totalsec) * 1000)

  " Convert h/m/s to integer explicitly
  let h = float2nr(h)
  let m = float2nr(m)
  let s = float2nr(s)

  return printf("%02d:%02d:%02d.%03d", h, m, s, ms)
endfunction
