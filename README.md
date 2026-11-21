# UIReevelate

Modern UI library for Roblox executor scripts (Delta, etc). Clean dark theme, smooth animations, built-in config system, dynamic island, Spotify control.

Fork / rebrand style matching KyriLib layout and API.

## Installation (Delta / executors)

```lua
local ree = loadstring(game:HttpGet("https://raw.githubusercontent.com/cenobium/uireevelate/refs/heads/main/source.lua"))()
```

## Quick Start

```lua
local ree = loadstring(game:HttpGet("https://raw.githubusercontent.com/cenobium/uireevelate/refs/heads/main/source.lua"))()

local w = ree.new("my script", {
    GameName = "MyGame",
    AutoLoad = "default"
})

local main = w:tab("Main", "sword")

main:button("click me", function()
    w:notify("hey", "button works", 2)
end)

main:toggle("enable thing", false, function(state)
    print(state)
end, "thing")

main:slider("walkspeed", 0, 500, 16, function(val)
    local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = val end
end, "ws")
```

## Features

- buttons, toggles, sliders, inputs, dropdowns, multiselects, color pickers, keybinds
- progress bars, image elements, searchable dropdowns
- notifications with timer
- 5 preset themes + live theme editor
- built-in config save/load + auto-load
- draggable / resizable window
- keybinds (press / hold, mouse buttons)
- Lucide icon names + rbxassetid / https
- dynamic island mode
- Spotify one-liner (where request() exists)
- mobile + desktop executor support

## Window

```lua
local w = ree.new(title, {
    GameName = "string",      -- config folder
    AutoLoad = "default",     -- config name on start
    Theme = { accent = Color3.fromRGB(255, 110, 150) },
    Mode = "window",          -- or "island"
    Island = false,
    Remember = true,
    Shadow = false,
    Splash = true,
    SplashTime = 1.5,
    Logo = "rbxassetid://...",
    KeySystem = "Once",       -- or "Everytime"
    KeySettings = { ... }
})
```

### Methods

```lua
w:tab(name, icon)
w:notify(title, text, duration, icon)
w:accent(color)
w:apply_theme(overrides)
w:island(opts)
w:spotify(opts)
w:resetpos()
w:destroy()
```

In island mode: `w.expand()`, `w.collapse()`, `w.expanded()`.

Toggle visibility: RightControl.

## Tabs & Elements

```lua
local t = w:tab("Combat", "crosshair")

t:button(text, callback, flag?)
t:toggle(text, default, callback, flag?)
t:slider(text, min, max, default, callback, flag?)
t:input(text, default, callback, flag?)
t:dropdown(text, options, default, callback, flag?)
t:multiselect(...)
t:colorpicker(...)
t:keybind(...)
t:progress(...)
t:image(...)
```

Flags wire into the config system automatically.

## Themes

```lua
w:apply_theme(ree.presets.midnight)
w:apply_theme({ accent = Color3.fromRGB(255, 80, 80) })
```

Presets: `ree`, `midnight`, `rose`, `forest`, `slate`.

## Config

GameName + element flags + AutoLoad handle persistence.

## Delta notes

Delta supports standard `game:HttpGet`, `loadstring`, `cloneref`, `getgenv`, `setclipboard`, `request` (where available). This library uses only those surfaces.

## Credits

Structure and feature set inspired by KyriLib. Rebranded and hosted for this repo.
