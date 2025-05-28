-- Commonly shared utility functions.

local wezterm = require 'wezterm'

local module = {}

-- This part is similar to platform-detect code in multiple repos e.g. :
--   https://github.com/sravioli/wezterm
--   https://github.com/KevinSilvester/wezterm-config
-- For me, I don't really care if this value gets recalculated every time this
-- module is require'd, but I do want to avoid recalculation every time the
-- value is referenced. So just do a simple precalculation here.
local is_win = wezterm.target_triple:find "windows" ~= nil
local is_linux = wezterm.target_triple:find "linux" ~= nil
local is_mac = wezterm.target_triple:find "apple" ~= nil
local os = is_win and "windows" or is_linux and "linux" or is_mac and "mac" or "unknown"
module.platform = { os = os, is_win = is_win, is_linux = is_linux, is_mac = is_mac }

return module