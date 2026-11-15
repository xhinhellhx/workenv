-- WezTerm configuration translated from the supplied Ghostty config.
-- Suggested location:
--   macOS/Linux: ~/.wezterm.lua or ~/.config/wezterm/wezterm.lua
--   Windows:    %USERPROFILE%\.wezterm.lua
--
-- This config uses the CPU renderer by default for VM compatibility.
-- If software rendering is slower on your guest, try "OpenGL" instead.

local wezterm = require 'wezterm'
local act = wezterm.action

local config = wezterm.config_builder()

-- ---------------------------------------------------------------------------
-- Rendering
-- ---------------------------------------------------------------------------

config.front_end = 'Software'

-- ---------------------------------------------------------------------------
-- Font and cursor
-- ---------------------------------------------------------------------------

config.font = wezterm.font('SauceCodePro Nerd Font')
config.font_size = 12.0

config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 500

-- Ghostty's `shell-integration-features = no-cursor` has no direct
-- WezTerm equivalent. WezTerm does not install a zsh ZLE widget that forces
-- the cursor to a bar; applications can still change cursor shape via escape
-- sequences (for example, Neovim).

-- ---------------------------------------------------------------------------
-- Colors
-- ---------------------------------------------------------------------------

-- The supplied Ghostty theme name ("Solarized Dark Patched") does not include
-- its actual palette, so use WezTerm's built-in Solarized Dark palette as the
-- closest portable starting point. The split divider is overridden below.
config.color_scheme = 'Solarized Dark - Patched'

config.colors = {
  split = '#93a1a1',
}

-- Ghostty's 0.6 opacity / black fill is an overlay effect. WezTerm's
-- inactive_pane_hsb is a brightness multiplier, not an identical black
-- overlay; 0.6 gives a similar dimming level.
config.inactive_pane_hsb = {
  hue = 1.0,
  saturation = 1.0,
  brightness = 0.6,
}

-- ---------------------------------------------------------------------------
-- Updates and config reload
-- ---------------------------------------------------------------------------

config.check_for_updates = true
config.automatically_reload_config = true

-- WezTerm does not expose Ghostty's separate "stable" update channel or
-- automatic "download" policy as equivalent Lua settings. Use a stable
-- WezTerm release build if you want stable-only updates.

-- ---------------------------------------------------------------------------
-- Key bindings
-- ---------------------------------------------------------------------------

config.keys = {
  -- Tabs
  { key = 't', mods = 'SUPER', action = act.SpawnTab('CurrentPaneDomain') },
  { key = 'w', mods = 'SUPER', action = act.CloseCurrentPane { confirm = false } },
  { key = ']', mods = 'SUPER|SHIFT', action = act.ActivateTabRelative(1) },
  { key = '[', mods = 'SUPER|SHIFT', action = act.ActivateTabRelative(-1) },

  -- Physical number-row keys: 1..8 select tabs 1..8; 9 selects the last tab.
  { key = 'phys:1', mods = 'SUPER', action = act.ActivateTab(0) },
  { key = 'phys:2', mods = 'SUPER', action = act.ActivateTab(1) },
  { key = 'phys:3', mods = 'SUPER', action = act.ActivateTab(2) },
  { key = 'phys:4', mods = 'SUPER', action = act.ActivateTab(3) },
  { key = 'phys:5', mods = 'SUPER', action = act.ActivateTab(4) },
  { key = 'phys:6', mods = 'SUPER', action = act.ActivateTab(5) },
  { key = 'phys:7', mods = 'SUPER', action = act.ActivateTab(6) },
  { key = 'phys:8', mods = 'SUPER', action = act.ActivateTab(7) },
  { key = 'phys:9', mods = 'SUPER', action = act.ActivateTab(-1) },

  -- Splits / panes
  { key = 'd', mods = 'SUPER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'd', mods = 'SUPER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },

  { key = 'LeftArrow',  mods = 'SUPER|SHIFT', action = act.ActivatePaneDirection('Left') },
  { key = 'RightArrow', mods = 'SUPER|SHIFT', action = act.ActivatePaneDirection('Right') },
  { key = 'UpArrow',    mods = 'SUPER|SHIFT', action = act.ActivatePaneDirection('Up') },
  { key = 'DownArrow',  mods = 'SUPER|SHIFT', action = act.ActivatePaneDirection('Down') },

  { key = 'Enter', mods = 'SUPER|SHIFT', action = act.TogglePaneZoomState },

  { key = 'LeftArrow',  mods = 'SUPER|CTRL|SHIFT', action = act.AdjustPaneSize { 'Left', 10 } },
  { key = 'RightArrow', mods = 'SUPER|CTRL|SHIFT', action = act.AdjustPaneSize { 'Right', 10 } },
  { key = 'UpArrow',    mods = 'SUPER|CTRL|SHIFT', action = act.AdjustPaneSize { 'Up', 10 } },
  { key = 'DownArrow',  mods = 'SUPER|CTRL|SHIFT', action = act.AdjustPaneSize { 'Down', 10 } },

  -- Copy / paste / scrollback
  { key = 'c', mods = 'SUPER', action = act.CopyTo('Clipboard') },
  { key = 'v', mods = 'SUPER', action = act.PasteFrom('Clipboard') },

  { key = 'UpArrow',   mods = 'SUPER', action = act.ScrollByPage(-1) },
  { key = 'DownArrow', mods = 'SUPER', action = act.ScrollByPage(1) },
  { key = 'Home',      mods = 'SUPER', action = act.ScrollToTop },
  { key = 'End',       mods = 'SUPER', action = act.ScrollToBottom },

  -- Jump between shell prompts marked with OSC 133 semantic prompt escapes.
  -- Your shell must emit OSC 133 markers for this to work.
  { key = 'UpArrow',   mods = 'SUPER|CTRL', action = act.ScrollToPrompt(-1) },
  { key = 'DownArrow', mods = 'SUPER|CTRL', action = act.ScrollToPrompt(1) },
}

return config
