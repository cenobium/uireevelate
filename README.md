# LocalUI

Client-side interface helper for Roblox executors (Delta and others).

Looks and behaves like a normal local UI module. No external asset fetches, no network calls for icons/logos, no remotes, no FireServer / InvokeServer.

## Load

```lua
local localui = loadstring(game:HttpGet("https://raw.githubusercontent.com/cenobium/uireevelate/refs/heads/main/source.lua"))()
```

## Quick

```lua
local localui = loadstring(game:HttpGet("https://raw.githubusercontent.com/cenobium/uireevelate/refs/heads/main/source.lua"))()

local w = localui.new("Settings", {
    GameName = "GameData",
    AutoLoad = "default"
})

local main = w:tab("General", "settings-2")

main:toggle("Option", false, function(state)
end, "opt")

main:slider("Value", 0, 100, 16, function(v)
end, "val")
```

## Design

- ScreenGuis use random names per run
- Parent prefers gethui() when present
- Config folder: LocalData
- Attribute marker: lui
- Spotify integration removed (external)
- Icon pack external fetch disabled
- Zero outbound URLs for library assets

API surface matches common window / tab / element / flag / theme pattern.
