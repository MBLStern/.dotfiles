local wezterm = require 'wezterm'
local mux = wezterm.mux

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.leader = { key = 'n', mods = 'CTRL', timeout_milliseconds = 1500 }

wezterm.on('gui-startup', function(window)
    local tab, pane, window = mux.spawn_window(cmd or {})
    local gui_window = window:gui_window();
    gui_window:perform_action(wezterm.action.ToggleFullScreen, pane)
end)


local background_opacity = 0.85

config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = background_opacity
config.audible_bell = "Disabled"
config.font = wezterm.font('JetBrains Mono', { italic = false })
config.warn_about_missing_glyphs = false
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

-- For example, changing the color scheme:
config.color_scheme = 'Catppuccin Mocha'
config.colors = {
    background = 'black',
    cursor_bg = 'lightgray'
}

config.window_background_opacity = background_opacity
config.enable_wayland = true

-- toggle function
wezterm.on("toggle-opacity", function(window, pane)
    local overrides = window:get_config_overrides() or {}
    if not overrides.window_background_opacity then
        -- if no override is setup, override the default opacity value with 1.0
        overrides.window_background_opacity = 1.0
    else
        -- if there is an override, make it nil so the opacity goes back to the default
        overrides.window_background_opacity = nil
    end
    window:set_config_overrides(overrides)
end)

config.keys = {

    -- Keyboard shortcut to toggle background opacity
    {
        key = 'b',
        mods = 'CTRL',
        action = wezterm.action.EmitEvent("toggle-opacity"),
    },
    -- horizontal split
    {
        key = 'n',
        mods = 'LEADER',
        action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },

    -- vertical split
    {
        key = 'v',
        mods = 'LEADER',
        action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },

    -- close active pane
    {
        key = 'q',
        mods = 'LEADER',
        action = wezterm.action.CloseCurrentPane { confirm = true }
    },

    {
        key = 'o',
        mods = 'LEADER',
        action = wezterm.action_callback(function(win, pane)
            local tab = win:active_tab()
            for _, p in ipairs(tab:panes()) do
                if p:pane_id() ~= pane:pane_id() then
                    p:activate()
                    win:perform_action(wezterm.action.CloseCurrentPane { confirm = false }, p)
                end
            end
        end),
    },

    -- change active pane in direction
    {
        key = 'k',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection('Up')
    },
    {
        key = 'j',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection('Down')
    },
    {
        key = 'l',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection('Right')
    },
    {
        key = 'h',
        mods = 'LEADER',
        action = wezterm.action.ActivatePaneDirection('Left')
    }
}
-- and finally, return the configuration to wezterm
return config
