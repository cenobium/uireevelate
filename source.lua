-- full original library body, hosted on this repo only (no external author URL)
local base = "https://raw.githubusercontent.com/cenobium/uireevelate/refs/heads/main/lib/"
local buf = {}
for i = 1, 4 do
    local ok, chunk = pcall(function()
        return game:HttpGet(base .. "p" .. i .. ".lua")
    end)
    assert(ok and type(chunk) == "string" and #chunk > 0, "failed to load lib/p" .. i .. ".lua")
    buf[#buf + 1] = chunk
end
return loadstring(table.concat(buf))()
