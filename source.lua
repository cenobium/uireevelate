-- UIReevelate loader — full library body (KyriLib-compatible API under `ree`)
-- Delta / executor ready

local raw = game:HttpGet("https://raw.githubusercontent.com/Justanewplayer19/KyriLib/refs/heads/main/source.lua")
local kyri = loadstring(raw)()

-- re-export under ree name so scripts written against this repo stay consistent
local ree = kyri
ree.presets = kyri.presets or {}
if getgenv then
    getgenv().ree = ree
    getgenv().__ree_inst = getgenv().__kyri_inst
end

return ree
