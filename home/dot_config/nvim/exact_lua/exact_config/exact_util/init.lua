local M = {}

-- Get plugin options for a specific plugin
-- This is useful when setting up a plugin from a different location
---@param plugin_name string
function M.opts(plugin_name)
  local plugin = require('lazy.core.config').plugins[plugin_name]
  if not plugin then
    return {}
  end
  local Plugin = require('lazy.core.plugin')
  return Plugin.values(plugin, 'opts', false)
end

return M
