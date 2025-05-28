-- Customize behavior for the windowing interface.

local wezterm = require 'wezterm'

local module = {}

function module.configure(config)
  -- Disable "are you sure" prompt when closing tab.
  -- XXX Trying to disable tab close confirmation using all the mechanisms
  -- below. This works for the ctrl-shift-w key shortcut, and also works for
  -- the tab "x" in the local domain. In ssh or unix domains however the "x"
  -- closure still shows the confirm prompt.
  config.window_close_confirmation = 'NeverPrompt'
  table.insert(
    config.keys,
    {
      key = 'w',
      mods = 'SHIFT|CTRL',
      action = wezterm.action.CloseCurrentTab { confirm = false },
    }
  )
  table.insert(
    config.keys,
    {
      key = 'w',
      mods = 'CMD',
      action = wezterm.action.CloseCurrentTab { confirm = false },
    }
  )
  wezterm.on(
    'mux-is-process-stateful', 
    function(_proc)
      return false
    end
  )
end

return module