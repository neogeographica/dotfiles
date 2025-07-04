-- Customize status displays.

local wezterm = require 'wezterm'

local util = require 'util'

local module = {}

local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local YELLOW_SUN = utf8.char(0x2600)
local MAGNIFYING_GLASS = utf8.char(0x1f50d)
local HOURGLASS = utf8.char(0x231b)

-- Utility function to toggle (or initially set) the global controlling
-- whether to show color scheme name in the status bar.
local function toggleSchemeNameStatus(_, _)
  if wezterm.GLOBAL.show_scheme_name == true then
    wezterm.GLOBAL.show_scheme_name = false
  else
    wezterm.GLOBAL.show_scheme_name = true
  end
end

-- Utility function to write out the window's current color scheme name to a
-- file. The scheme name will be appended to the file color_scheme_names.txt
-- in the config dir.
local function dumpSchemeName(window, _)
  file = io.open(wezterm.config_dir .. "/color_scheme_names.txt","a")
  file:write(window:effective_config().color_scheme .. "\n")
  file:close()
end

-- Utility function for composing tab title for display.
local function tab_title(tab_info)
  local retval = tab_info.active_pane.title
  local title = tab_info.tab_title
  if title and #title > 0 then
    retval = title
  end
  -- We already have a copy mode / search mode indicator in the status bar, so
  -- no need to add it to the tab title. Also weirdly it says "Copy mode"
  -- here even in search mode. So just remove it from the tab title.
  return retval:gsub('^Copy mode: ', '')
end

-- Build the list of labels that make up the status bar.
local function segments_for_right_status(window, pane)
  -- Always show workspace and domain name segments.
  local workspace_name = window:active_workspace()
  local domain_name = pane:get_domain_name()
  local segments = {
    ' ' .. workspace_name .. '  ',
    ' ' .. domain_name .. '  ',
  }
  -- Add a magnifying glass icon if current pane is zoomed.
  local tab = pane:tab()
  if tab ~= nil then
    for _, p in ipairs(tab:panes_with_info()) do
      if p.is_zoomed then
        table.insert(segments, 1, ' ' .. MAGNIFYING_GLASS)
      end
    end
  end
  -- Add mode (from key table name) if active.
  local keytable_name = window:active_key_table()
  if keytable_name then
    mode_name = keytable_name:gsub("_", " "):upper()
    table.insert(segments, 1, ' ' .. mode_name .. '  ')
  end
  -- Show color scheme name if requested.
  if wezterm.GLOBAL.show_scheme_name == true then
    table.insert(segments, 1, ' ' .. window:effective_config().color_scheme .. '  ')
  end
  -- Add a lag indicator if the mux server is being slow to respond.
  -- XXX The lag indicator seems to flicker on even when there's not any actual
  -- noticeable problem... commenting it out for now.
--[[
  local meta = pane:get_metadata() or {}
  if meta.is_tardy then
    local secs = meta.since_last_response_ms / 1000.0
    table.insert(segments, 1, string.format('%5.1fs ' .. HOURGLASS, secs))
  end
--]]
  return segments
end

function module.configure(config)
  -- Define callback for setting the displayed tab title.
  wezterm.on(
    'format-tab-title',
    function(tab, tabs, panes, config, hover, max_width)
      return tab_title(tab)
    end
  )
  -- Alternately to the above... modify tab title when a not-currently-focused
  -- tab has unseen output (e.g. from a running program there).
  -- XXX Marking a tab that has "unseen output" is kind of a cool idea, but
  -- the marker can also be triggered just when resizing an existing window.
  -- Not 100% convinced about the utility. Leaving it out for now.
--[[
  wezterm.on(
    'format-tab-title',
    function(tab, tabs, panes, config, hover, max_width)
      local title = tab_title(tab)
      if tab.is_active then
        return title
      end
      for _, pane in ipairs(tab.panes) do
        if pane.has_unseen_output then
          return {
            -- The "x" on the tab seems to always be the same color as the
            -- first character of text. So I guess let's stick a char up
            -- front before setting different colors for the title.
            -- In this case I'm using a "sun" character that looks OK as an
            -- "indicator light" in my chosen font.
            { Text = YELLOW_SUN .. ' ' },
            -- Color 4 is the "yellow" for the palette.
            { Foreground = { Color = config.resolved_palette.brights[4] } },
            { Text = title },
          }
        end
      end
      return title
    end
  )
--]]
  -- Draw some powerline-style info segments on the right side of the tab bar.
  -- Largely taken from https://alexplescan.com/posts/2024/08/10/wezterm/
  wezterm.on(
    'update-status',
    function(window, pane)
      local segments = segments_for_right_status(window, pane)
      local color_scheme = window:effective_config().resolved_palette
      local bg = wezterm.color.parse(color_scheme.background)
      local fg = color_scheme.foreground
      local gradient_to, gradient_from = bg
      gradient_from = gradient_to:lighten(0.2)
      local gradient = wezterm.color.gradient(
        {
          orientation = 'Horizontal',
          colors = { gradient_from, gradient_to },
        },
        #segments
      )
      local elements = {}
      for i, seg in ipairs(segments) do
        local is_first = i == 1
        if is_first then
          table.insert(elements, { Background = { Color = 'none' } })
        end
        -- See comments in appearance.lua for why this darkening in macOS.
        if wezterm.GLOBAL.brightness_boosted == true then
          table.insert(elements, { Foreground = { Color = gradient[i]:darken(0.085) } })
        else
          table.insert(elements, { Foreground = { Color = gradient[i] } })
        end
        table.insert(elements, { Text = SOLID_LEFT_ARROW })
        -- If this is not one of the two rightmost constant segments, use a
        -- yellow foreground color.
        if (#segments - i) <= 1 then
          table.insert(elements, { Foreground = { Color = fg } })
        else
          table.insert(elements, { Foreground = { Color = color_scheme.brights[4] } })
        end
        table.insert(elements, { Background = { Color = gradient[i] } })
        table.insert(elements, { Text = seg })
      end
      window:set_right_status(wezterm.format(elements))
    end
  )
  -- Set key for toggling color scheme name in status.
  table.insert(
    config.keys,
    {
      key = 's',
      mods = 'CTRL',
      action = wezterm.action_callback(toggleSchemeNameStatus),
    }
  )
  -- Set key for dumping color scheme name to a file.
  table.insert(
    config.keys,
    {
      key = 's',
      mods = 'CTRL|SHIFT',
      action = wezterm.action_callback(dumpSchemeName),
    }
  )
end

return module