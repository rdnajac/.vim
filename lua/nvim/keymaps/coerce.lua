local function coerce(char)
  return function()
    vim.api.nvim_feedkeys(vim.keycode('<Plug>(abolish-coerce-word)') .. char, 'nt', false)
  end
end

return {
  { 'cR', group = 'CoeRce', icon = { icon = '󰬴' } },
  { 'cRc', coerce('c'), desc = 'coerceCamelCase' },
  { 'cRm', coerce('m'), desc = 'coerceMixedCase' },
  { 'cRp', coerce('p'), desc = 'coerceMixedcase' },
  { 'cRs', coerce('s'), desc = 'coerce_snake_case' },
  { 'cR_', coerce('_'), desc = 'coercesnakecase' },
  { 'cRu', coerce('u'), desc = 'COERCE_UPPER_CASE' },
  { 'cRU', coerce('U'), desc = 'COERCE_UPPER_CASE' },
  { 'cR-', coerce('-'), desc = 'coerce-dash-case' },
  { 'cRk', coerce('k'), desc = 'coerce-dash-case' },
  { 'cR.', coerce('.'), desc = 'coerce.dot.case' },
  { 'cR<Space>', coerce(' '), desc = 'coerce space case' },
}
