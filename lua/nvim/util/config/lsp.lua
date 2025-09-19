-- TODO: make this generic
-- from: `$VIMRUNTIME/lua/vim/lsp.lua`

--- @class vim.lsp.config
--- @field [string] vim.lsp.Config
--- @field package _configs table<string,vim.lsp.Config>
lsp.config = setmetatable({ _configs = {} }, {
  --- @param self vim.lsp.config
  --- @param name string
  --- @return vim.lsp.Config
  __index = function(self, name)
    validate_config_name(name)

    local rconfig = lsp._enabled_configs[name] or {}

    if not rconfig.resolved_config then
      if name == '*' then
        rconfig.resolved_config = lsp.config._configs['*'] or {}
        return rconfig.resolved_config
      end

      -- Resolve configs from lsp/*.lua
      -- Calls to vim.lsp.config in lsp/* have a lower precedence than calls from other sites.
      local rtp_config --- @type vim.lsp.Config?
      for _, v in ipairs(api.nvim_get_runtime_file(('lsp/%s.lua'):format(name), true)) do
        local config = assert(loadfile(v))() ---@type any?
        if type(config) == 'table' then
          --- @type vim.lsp.Config?
          rtp_config = vim.tbl_deep_extend('force', rtp_config or {}, config)
        else
          log.warn(('%s does not return a table, ignoring'):format(v))
        end
      end

      if not rtp_config and not self._configs[name] then
        log.warn(('%s does not have a configuration'):format(name))
        return
      end

      rconfig.resolved_config = vim.tbl_deep_extend(
        'force',
        lsp.config._configs['*'] or {},
        rtp_config or {},
        self._configs[name] or {}
      )
      rconfig.resolved_config.name = name
    end

    return rconfig.resolved_config
  end,

  --- @param self vim.lsp.config
  --- @param name string
  --- @param cfg vim.lsp.Config
  __newindex = function(self, name, cfg)
    validate_config_name(name)
    local msg = ('table (hint: to resolve a config, use vim.lsp.config["%s"])'):format(name)
    validate('cfg', cfg, 'table', msg)
    invalidate_enabled_config(name)
    self._configs[name] = cfg
  end,

  --- @param self vim.lsp.config
  --- @param name string
  --- @param cfg vim.lsp.Config
  __call = function(self, name, cfg)
    validate_config_name(name)
    local msg = ('table (hint: to resolve a config, use vim.lsp.config["%s"])'):format(name)
    validate('cfg', cfg, 'table', msg)
    invalidate_enabled_config(name)
    self[name] = vim.tbl_deep_extend('force', self._configs[name] or {}, cfg)
  end,
})
