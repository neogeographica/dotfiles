-- Customize domain definitions and attachment.

local wezterm = require 'wezterm'

local module = {}

-- Predictive key display seems distracting ... some flickering and the cursor
-- bouncing back and forth. Disable it for now unless lag is really bad.
local ECHO_THRESHOLD_MS = 2000

local function find_and_raise_domain_panes(domain_name, workspace)
  local stop_checking_tabs = false
  local found_attached_pane = false
  for _, check_mux_window in ipairs(wezterm.mux.all_windows()) do
    if check_mux_window:get_workspace() == workspace then
      stop_checking_tabs = false
      for _, check_tab in ipairs(check_mux_window:tabs()) do
        for _, check_pane in ipairs(check_tab:panes()) do
          if check_pane:get_domain_name() == domain_name then
            check_tab:activate()
            check_pane:activate()
            check_mux_window:gui_window():focus()
            stop_checking_tabs = true
            found_attached_pane = true
            break
          end
        end
        if stop_checking_tabs then
          break
        end
      end
    end
  end
  return found_attached_pane
end

function module.configure(config)
  local this_host_domain_name = wezterm.hostname():gsub("%..*","")
  -- Specify a unix domain to use for local terminals that persist state.
  config.unix_domains = {
    {
      name = this_host_domain_name,
    },
  }
  -- Build the list of ssh-accessible remote domains. Skip any that are
  -- the same as the local domain above.
  local remote_domains = {
    'pylon',
    'lazarus',
  }
  config.ssh_domains = {}
  for _, domain_name in ipairs(remote_domains) do
    if domain_name ~= this_host_domain_name then
      table.insert(
        config.ssh_domains,
        {
          name = domain_name,
          remote_address = domain_name,
          username = 'joel',
        }
      )
    end
  end
  -- Now make a list of the domains in the order they should be presented
  -- in the domain-selector.
  domain_choices = {}
  table.insert(domain_choices, { label = 'local' })
  for _, unix_domain in ipairs(config.unix_domains) do
    table.insert(domain_choices, { label = unix_domain.name })
  end
  for _, ssh_domain in ipairs(config.ssh_domains) do
    table.insert(domain_choices, { label = ssh_domain.name })
  end

  -- Use the domain for this host on startup. Note that if a Linux desktop
  -- file is used to launch Wezterm and it specifies other args, this will
  -- be ignored.
  -- XXX Jankiness of unix/ssh domains not worth the persistence... will
  -- just use a regular local terminal.
--  config.default_gui_startup_args = { 'connect', this_host_domain_name }
  config.default_gui_startup_args = { 'connect', 'local' }

  -- Define the action of the domain-selector keybinding, as follows:
  --   * Present a list of domains to select from, w/ fuzzy select enabled.
  --   * If the selected domain is already attached, move its windows to the
  --     front (with a domain-relevant pane/tab activated in each).
  --   * Otherwise attach the domain, opening its windows/tabs/panes in new
  --     windows. If it has no panes, start one in a new window.
  table.insert(
    config.keys,
    {
      key = 'o',
      mods = 'CTRL',
      action = wezterm.action.InputSelector {
        title = "Domains",
        choices = domain_choices,
        fuzzy = true,
        action = wezterm.action_callback(function(window, _pane, _id, label)
          if not label then
            -- No domain selected; do nothing.
            return
          end
          local mux_domain = wezterm.mux.get_domain(label)
          if mux_domain == nil then
            -- Can't find the selected domain; do nothing.
            -- XXX Ideally, play an error beep? post a notification?
            return
          end
          local current_workspace = window:active_workspace()
          if mux_domain:state() == "Attached" then
            -- Selected domain is already attached. Raise its windows and
            -- make sure that a domain-relevant pane is active in each. If
            -- we find any such panes, exit.
            if find_and_raise_domain_panes(label, current_workspace) then
              return
            end
          end
          -- Selected domain is not attached (or has no panes in the workspace).
          if mux_domain:state() ~= "Attached" then
            -- Unattached. So, let's attach!
            mux_domain:attach()
            -- If there are panes, we're done.
            if find_and_raise_domain_panes(label, current_workspace) then
              return
            end
          end
          -- Attached but no panes in the workspace. Let's make a new
          -- window/tab/pane.
          wezterm.mux.spawn_window {
            domain = { DomainName = label },
            workspace = current_workspace,
          }
        end),
      },
    }
  )
end

return module
