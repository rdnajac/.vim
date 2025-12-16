local ft_map = {
  dirvish = {
    a = [[%{%v:lua.nv.icons.directory(b:dirvish._dir)..' '..fnamemodify(b:dirvish._dir, ':~')%}]],
    -- b = [[%{%v:lua.nv.lsp.dirvish.status()%}]],
    c = [[ %{join(map if opts.ft == '(argv(), "fnamemodify(v:val, ':t')"), ', ')} ]],
  },
}

return vim
  .iter(pairs(ft_map))
  :map(function(ft, sec)
    return {
      winbar = {
        lualine_a = { sec.a },
        lualine_b = { sec.b },
        lualine_c = { sec.c },
        lualine_z = sec.z and { sec.z } or nil,
      },
      filetypes = { ft },
    }
  end)
  :totable()
