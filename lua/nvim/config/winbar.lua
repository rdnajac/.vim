local M = {
  a = function(parts)
    local ret = {}
    table.insert(ret, '%#Chromatophore_a#')
    local ft = vim.bo.filetype
    if ft then
      table.insert(ret, nv.icons.filetype[ft] .. ' ')
      table.insert(ret, nv.icons.separators.section.rounded.left .. ' ')
    end
    if vim.islist(parts) then
      vim.list_extend(ret, parts)
    else
      table.insert(ret, parts)
    end
    table.insert(ret, '%#Chromatophore_b#')
    table.insert(ret, nv.icons.separators.component.rounded.left)
    return ret
  end,
  b = function() end,
  c = function() end,
  inactive = function() end,
}

local function is_active()
  return vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin)
end

local map = {
  [''] = function()
    if not is_active() then
      return {
        '%#Chromatophore_c#',
        vim.fn.expand('%:~:.'),
        ' ',
        vim.fn['vimline#flag']('readonly'),
        vim.fn['vimline#flag']('modified'),
      }
    end
    local ret = M.a('%t')
    return vim.list_extend(ret, {
      vim.fn['vimline#flag']('readonly'),
      vim.fn['vimline#flag']('modified'),
      nv.status(),
      '%#Chromatophore_bc#',
      nv.icons.separators.component.rounded.left,
      '',
      '%#Chromatophore_c#',
      nv.lsp.docsymbols.get(),
    })
  end,
  acwrite = function()
    local ret = {}
    table.insert(ret, '%#Chromatophore_a#')
    local ft = vim.bo.filetype
    if ft then
      table.insert(ret, nv.icons.filetype[ft] .. ' ')
      if ft == 'oil' then
        local dir = require('oil').get_current_dir()
        if dir then
          table.insert(ret, vim.fn.fnamemodify(dir, ':~'))
        end
      elseif ft == 'nvim-pack' then
        print('ok')
        table.insert(ret, 'TODO: print relevant status info')
      end
    end
    return ret
  end,
  -- stylua: ignore start
  help = function() return { '󰋖  %f' } end,
  nofile = function() return { '[NOFILE]' } end,
  nowrite = function() return { '[NOWRITE]' } end,
  prompt = function() return { '[PROMPT]' } end,
  quickfix = function() return { '%q' } end,
  --stylua: ignore end
  terminal = function()
    return {
      '%#Chromatophore_a#',
      '',
      vim.fn.fnamemodify(vim.fn.getcwd(), ':~'),
      ' ',
      '%#Chromatophore_b#',
      '',
      ' ',
      (vim.g.ooze_channel ~= nil and vim.g.ooze_channel == vim.bo.channel) and ' ' or ' ',
      vim.bo.channel,
      ' %#Chromatophore_bc# ',
    }
  end,
}

M.winbar = function()
  if vim.bo.filetype == 'snacks_dashboard' then
    return '' -- TODO: put startuptime here?
  end
  return table.concat(map[vim.bo.buftype]())
end

function M.setup()
  nv.winbar = M.winbar
  vim.o.winbar = '%{%v:lua.nv.winbar()%}'
end

return setmetatable(M, {
  __call = function()
    return M.winbar()
  end,
})
