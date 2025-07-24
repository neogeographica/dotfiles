-- Customize workspace management.

local wezterm = require 'wezterm'

local module = {}

function module.configure(config)
  -- A key shortcut for opening the launcher to select/create workspace, and
  -- keys for rotating through the workspaces.
  table.insert(
    config.keys,
    {
      key = 'o',
      mods = 'SHIFT|CTRL',
      action = wezterm.action.ShowLauncherArgs {
        flags = 'FUZZY|WORKSPACES',
      },
    }
  )
  table.insert(
    config.keys,
    {
      key = 'RightArrow',
      mods = 'CTRL',
      action = wezterm.action.SwitchWorkspaceRelative(1),
    }
  )
  table.insert(
    config.keys,
    {
      key = 'LeftArrow',
      mods = 'CTRL',
      action = wezterm.action.SwitchWorkspaceRelative(-1)
    }
  )
end

return module