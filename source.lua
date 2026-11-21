-- full original library body on this repo only
local base = "https://raw.githubusercontent.com/cenobium/uireevelate/refs/heads/main/lib/"
local buf = {}
for i = 1, 16 do
    local ok, chunk = pcall(function()
        return game:HttpGet(base .. "p" .. i .. ".lua")
    end)
    assert(ok and type(chunk) == "string" and #chunk > 0, "failed lib/p" .. i)
    buf[#buf+1] = chunk
end
return loadstring(table.concat(buf))()
