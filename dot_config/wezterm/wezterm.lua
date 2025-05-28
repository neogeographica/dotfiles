-- Top-level WezTerm config. Only exists to load the config pieces that have
-- been parceled out into other modules.

local wezterm = require 'wezterm'

local interface = require 'interface'
local appearance = require 'appearance'
local workspaces = require 'workspaces'
local domains = require 'domains'
local status = require 'status'

local config = wezterm.config_builder()

config.keys = {}
config.key_tables = {}

interface.configure(config)
appearance.configure(config)
workspaces.configure(config)
domains.configure(config)
status.configure(config)

-- Let's try a plugin!
local cmd_sender = wezterm.plugin.require("https://github.com/aureolebigben/wezterm-cmd-sender")
cmd_sender.apply_to_config(config, {
    key = 'y',
    mods = 'CTRL|SHIFT',
    description = 'Enter command to send to all panes of active tab'
})

return config
