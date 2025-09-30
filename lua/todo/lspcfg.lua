-- `$VIMRUNTIME/lua/vim/lsp.lua`

--- @class config
--- @field [string] Config
--- @field package _configs table<string,Config>
M = setmetatable({ _configs = {}, _enabled = {} }, {

  --- @param self config
  --- @param name string
  --- @return Config
  __index = function(self, name)
    local rconfig = self._enabled[name] or {}
    --- code cotinues...
    if not rconfig.resolved_config then
      if name == '*' then
        rconfig.resolved_config = self._configs['*'] or {}
        return rconfig.resolved_config
      end

      -- Resolve configs from lsp/*.lua
      -- Calls to vim.lsp.config in lsp/* have a lower precedence than calls from other sites.
      local rtp_config --- @type Config?
      for _, v in ipairs(api.nvim_get_runtime_file(('lsp/%s.lua'):format(name), true)) do
        local config = assert(loadfile(v))() ---@type any?
        if type(config) == 'table' then
          --- @type Config?
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
        self._configs['*'] or {},
        rtp_config or {},
        self._configs[name] or {}
      )
      rconfig.resolved_config.name = name
    end

    return rconfig.resolved_config
  end,

  --- @param self config
  --- @param name string
  --- @param cfg Config
  __newindex = function(self, name, cfg)
    self._configs[name] = cfg
  end,

  --- @param self config
  --- @param name string
  --- @param cfg Config
  __call = function(self, name, cfg)
    self[name] = vim.tbl_deep_extend('force', self._configs[name] or {}, cfg)
  end,
})
