---@class Plugin
---@field spec PlugSpec
---@field name string
---@field dir string
---@field active boolean
local Plugin = {}
Plugin.__index = Plugin

-- Constructor
function Plugin.new(spec)
    local self = setmetatable({}, Plugin)
    self.spec = spec
    self.name = spec.name or spec.src:match('.*/(.*)%.git$')
    self.dir = spec.dir or vim.fn.stdpath("data") .. "/site/pack/core/start/" .. self.name
    self.active = true
    return self
end

-- Check if plugin is enabled
function Plugin:enabled()
    local e = self.spec.enabled
    if vim.is_callable(e) then
        local ok, res = pcall(e)
        return ok and res
    end
    return e == nil or e == true
end

-- Run plugin config (lazy if event is set)
function Plugin:config()
    if not vim.is_callable(self.spec.config) then
        return
    end
    if self.spec.event then
        local aug = vim.api.nvim_create_augroup("LazyLoad", { clear = true })
        vim.api.nvim_create_autocmd(self.spec.event, {
            group = aug,
            once = true,
            callback = self.spec.config,
        })
    else
        self.spec.config()
    end
end

-- Run build command
function Plugin:build()
    local b = self.spec.build
    if not b then return end

    local function notify(ok, err)
        local msg = "Build " .. (ok and "succeeded" or "failed") .. " for " .. self.name
        if err then msg = msg .. ": " .. err end
        Snacks.notify(msg, ok and "info" or "error")
    end

    if vim.is_callable(b) then
        local ok, result = pcall(b)
        notify(ok, ok and nil or result)
    elseif type(b) == "string" then
        local cmd = string.format("cd %s && %s", vim.fn.shellescape(self.dir), b)
        local output = vim.fn.system(cmd)
        notify(vim.v.shell_error == 0, vim.v.shell_error ~= 0 and output or nil)
    else
        notify(false, "Invalid build command type: " .. type(b))
    end
end

-- Convert a raw spec to a Plugin instance
function Plugin.from_spec(spec)
    return Plugin.new(spec)
end

-- =========================================================
-- Plugin Manager

local M = {}

local function to_spec(module)
    if not M.enabled(module) then return nil end

    local t = type(module)
    local src = t == "string" and module or module[1] or module.src
    if type(src) ~= "string" or src == "" then return nil end

    if src:match("^%w[%w._-]*/[%w._-]+$") then
        src = "https://github.com/" .. src .. (src:sub(-4) ~= ".git" and ".git" or "")
    end

    return {
        src = src,
        name = t == "table" and module.name or nil,
        version = t == "table" and module.version or nil,
        build = t == "table" and module.build or nil,
        config = t == "table" and module.config or nil,
        dependencies = t == "table" and module.dependencies or nil,
        specs = t == "table" and module.specs or nil,
        event = t == "table" and module.event or nil,
        enabled = t == "table" and module.enabled or nil,
    }
end

-- Import all specs, flatten dependencies
function M.import_specs(plugin)
    local specs = {}
    local function add_spec(p)
        local s = to_spec(p)
        if not s then return end
        table.insert(specs, s)
        for _, field in ipairs({ "dependencies", "specs" }) do
            local list = s[field]
            if type(list) == "table" then
                for _, f in ipairs(list) do
                    add_spec(f)
                end
            end
        end
    end
    add_spec(plugin)
    return specs
end

-- Load a plugin module as a Plugin object
function M.Plug(modname)
    local plugin_module = Require(modname)
    if not plugin_module then return nil end

    local specs = M.import_specs(plugin_module)
    local plugins = {}
    for _, s in ipairs(specs) do
        local p = Plugin.from_spec(s)
        table.insert(plugins, p)

        -- Automatically add to pack
        vim.pack.add({ s }, { confirm = vim.v.vim_did_enter == 0 })
    end

    return plugins[1]  -- return main plugin object
end

-- Run config for all plugins
function M.do_configs(plugins)
    for _, plugin in pairs(plugins) do
        if plugin.enabled() then
            plugin:config()
        end
    end
end

M.enabled = function(plugin)
    local enabled = plugin.enabled
    if vim.is_callable(enabled) then
        local ok, res = pcall(enabled)
        return ok and res
    end
    return enabled == nil or enabled == true
end

return setmetatable(M, {
    __call = function(_, modname)
        return M.Plug(modname)
    end,
})
