-- Customize fonts and colors.

local always_switch_all_window_schemes = true

local wezterm = require 'wezterm'

local schemes = require 'schemes'
local util = require 'util'

local module = {}

-- Common utility function to modify color props in config or overrides.
local function setColorSchemeProperties(config, color_scheme_name)
  local color_scheme = wezterm.get_builtin_color_schemes()[color_scheme_name]
  config.color_scheme = color_scheme_name
  config.colors = {
    tab_bar = {
      active_tab = {
        bg_color = color_scheme.background,
        fg_color = color_scheme.foreground,
      },
    },
  }
  -- Also set grey for scrollbar.
  config.colors.scrollbar_thumb = '#555555'
  -- And grey for the selected-text background?
  -- XXX Not sure when to override this for different schemes. For most
  -- schemes the scheme-specified color is OK. Leaving this alone for now.
  -- config.colors.selection_bg = '#555555'
end

-- Common utility function to update one window's color scheme.
local function setColorSchemeForWindow(color_scheme_name, window)
  local overrides = window:get_config_overrides() or {}
  setColorSchemeProperties(overrides, color_scheme_name)
  window:set_config_overrides(overrides)
end

-- Common utility function to set color scheme for all existing and future
-- windows. Except for skipWindow, if non-nil.
local function applySchemeToAllWindows(color_scheme_name, skipWindow)
  for _, mux_window in ipairs(wezterm.mux.all_windows()) do
    local window = mux_window:gui_window()
    if window ~= skipWindow then
      setColorSchemeForWindow(color_scheme_name, window)
    end
  end
  wezterm.GLOBAL.color_scheme_name = color_scheme_name
  wezterm.reload_configuration()
end

-- Keybound action to set current window's color scheme for all existing and
-- future windows.
local function applyWindowSchemeToAllWindows(window, _)
  applySchemeToAllWindows(window:effective_config().color_scheme, window)
end

-- Change one window's color scheme to next or previous in list. Used by the
-- keybound actions for cycling scheme forward or backward.
local function cycleScheme(window, isForward)
  local currentScheme = window:effective_config().color_scheme
  local color_scheme_name = schemes[1]
  for i = 1, #schemes, 1 do
    if schemes[i] == currentScheme then
      -- 1-based arrays can look goofy for mod math...
      if isForward then
        color_scheme_name = schemes[i % #schemes + 1]
      else
        color_scheme_name = schemes[(i-2) % #schemes + 1]
      end
      break
    end
  end
  setColorSchemeForWindow(color_scheme_name, window)
  if always_switch_all_window_schemes then
    applySchemeToAllWindows(color_scheme_name, window)
  end
end

-- Keybound actions for cycling window color scheme forward or backward.
local function cycleSchemeForward(window, _)
  cycleScheme(window, true)
end
local function cycleSchemeBackward(window, _)
  cycleScheme(window, false)
end

function module.configure(config)
  -- Set color scheme.
  local color_scheme_name
  if wezterm.GLOBAL.color_scheme_name == nil then
    color_scheme_name = schemes[1]
  else
    color_scheme_name = wezterm.GLOBAL.color_scheme_name
  end
  setColorSchemeProperties(config, color_scheme_name)
  -- Configure window widgets.
  -- XXX INTEGRATED_BUTTONS has issues with the minimize button not working
  -- if on Linux.
  if util.platform.is_mac then
    config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
  end
  config.enable_scroll_bar = true
  -- Set font family and size.
  config.font = wezterm.font_with_fallback {
    'MonaspiceAr NFM',
    'Noto Color Emoji',
  }
  config.font_size = 10
  config.warn_about_missing_glyphs=false
  -- macOS differences:
  -- Using WebGpu on macOS for its color aesthetics.
  -- Also punching up text brightness a bit on macOS. Note that this
  -- will interfere with building the foreground/background color matching
  -- in status.lua; we'll compensate over there. If this brightness value
  -- is changed then that compensation will also need to be changed.
  if util.platform.is_mac then
    config.front_end = 'WebGpu'
    config.foreground_text_hsb = {
      hue = 1.0,
      saturation = 1.0,
      brightness = 1.2,
    }
    wezterm.GLOBAL.brightness_boosted = true
  else
    wezterm.GLOBAL.brightness_boosted = false
  end
  -- Make inactive panes a bit dimmer.
  config.inactive_pane_hsb = {
    saturation = 0.5,
    brightness = 0.3,
  }
  -- Set keys to cycle and apply color schemes.
  table.insert(
    config.keys,
    {
      key = 's',
      mods = 'ALT',
      action = wezterm.action_callback(cycleSchemeForward),
    }
  )
  table.insert(
    config.keys,
    {
      key = 's',
      mods = 'SHIFT|ALT',
      action = wezterm.action_callback(cycleSchemeBackward),
    }
  )
  table.insert(
    config.keys,
    {
      key = 's',
      mods = 'CTRL|ALT',
      action = wezterm.action_callback(applyWindowSchemeToAllWindows),
    }
  )
end

return module
