local H = {}

function H.segment(hl, text, sep)
  if not text or text == '' then
    return ''
  end
  return ('%%#%s#%s%s'):format(hl, text, sep or '')
end

function H.compose(parts)
  return table.concat(vim.iter(parts):flatten():totable(), '')
end

local function section_a()
  local parts = {}
  local ft = vim.bo.filetype
  local icon = ft and nv.icons.filetype[ft] or ''
  parts[#parts + 1] = H.segment('Chromatophore_a', icon and (icon .. ' ') or '')
  parts[#parts + 1] = H.segment('Chromatophore_a', '%t', ' ')
  return parts
end

local function section_b()
  local parts = {}
  parts[#parts + 1] = H.segment('Chromatophore_b', vim.fn['vimline#flag']('readonly'))
  parts[#parts + 1] = H.segment('Chromatophore_b', vim.fn['vimline#flag']('modified'))
  parts[#parts + 1] = H.segment('Chromatophore_b', nv.status(), '  ')
  return parts
end

local function section_c()
  local parts = {}
  local doc = nv.lsp.docsymbols.get()
  if doc and doc ~= '' then
    parts[#parts + 1] = H.segment('Chromatophore_c', doc)
  end
  return parts
end

-- Example renderer
local function build_winbar()
  if vim.bo.filetype == 'snacks_dashboard' then
    return ''
  end
  local a = section_a()
  local b = section_b()
  local c = section_c()
  return H.compose({ a, b, c })
end

return {
  section_a = section_a,
  section_b = section_b,
  section_c = section_c,
  build_winbar = build_winbar,
}
