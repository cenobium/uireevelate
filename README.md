# uireevelate

Full KyriLib body hosted here as a single `source.lua`.

## Load (Delta)

```lua
local kyri = loadstring(game:HttpGet("https://raw.githubusercontent.com/cenobium/uireevelate/refs/heads/main/source.lua"))()
```

## Quick

```lua
local kyri = loadstring(game:HttpGet("https://raw.githubusercontent.com/cenobium/uireevelate/refs/heads/main/source.lua"))()

local w = kyri.new("Settings", {
    GameName = "GameData",
    AutoLoad = "default",
    Splash = false
})

local main = w:tab("Main", "settings-2")

main:toggle("option", false, function(state)
end, "opt")

main:slider("value", 0, 100, 16, function(v)
end, "val")

main:notes("info", "put plain notes here")

main:code([[
print("example")
local x = 1
]], 160)

-- hard hide / destroy all marked guis
-- kyri.escape()
```

## Notes / code section

```lua
tab:notes(title, body)   -- paragraph-style notes block
tab:code(source, height) -- monospace selectable code box (height default 140)
```

## Escape / protect

- ScreenGuis use random names
- Parent prefers `gethui()`
- `protect_gui` / `syn.protect_gui` applied when present
- Attribute marker is `lui` (not `kyri`)
- `kyri.escape()` destroys the active window and any remaining `lui` ScreenGuis

```lua
kyri.escape()
```

## Repo layout

- `source.lua` — full library (only file you need)
- no `lib/` split
