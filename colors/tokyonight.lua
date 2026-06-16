package.preload['tokyonight.colors'] = function()
  -- bt()
  return require('nvim.tokyonight.colors')
end

package.preload['tokyonight.groups'] = function()
  -- bt()
  return require('nvim.tokyonight.groups')
end

require('nvim.tokyonight').init()
