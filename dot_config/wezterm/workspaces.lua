-- Customize workspace management.

local wezterm = require 'wezterm'

local module = {}

function module.configure(config)
  -- Not much here at the moment. Just add a key shortcut for opening the
  -- launcher to select/create workspace.
  table.insert(
    config.keys,
    {
      key = 'o',
      mods = 'CTRL',
      action = wezterm.action.ShowLauncherArgs {
        flags = 'FUZZY|WORKSPACES',
      },
    }
  )
end

return module