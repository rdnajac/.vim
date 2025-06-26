local icon = ''
local ok, devicons = pcall(require, 'nvim-web-devicons')
if ok then
  icon = devicons.get_icon(vim.fn.expand('%:t'), nil, { default = true })
    or devicons.get_icon_by_filetype(vim.bo.filetype, { default = true })
    or ''
end
return icon
