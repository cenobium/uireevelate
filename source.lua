--[[
  LocalUI — client interface helper
  Self-contained. No external fetches. No remotes.
]]

local localui = {}
local gs = (cloneref and cloneref) or function(o) return o end

local function svc(n)
    return gs(game:GetService(n))
end

localui.svc = {
    tw = svc("TweenService"),
    inp = svc("UserInputService"),
    plr = svc("Players"),
    gui = svc("GuiService"),
    run = svc("RunService"),
    http = svc("HttpService"),
    cas = svc("ContextActionService"),
}

localui.studio = false
localui.icons = {}
localui.presets = {
    default = {
        bg = Color3.fromRGB(18, 18, 22),
        container = Color3.fromRGB(24, 24, 30),
        element = Color3.fromRGB(32, 32, 40),
        hover = Color3.fromRGB(42, 42, 52),
        active = Color3.fromRGB(55, 55, 68),
        accent = Color3.fromRGB(120, 140, 255),
        text = Color3.fromRGB(240, 240, 245),
        subtext = Color3.fromRGB(160, 160, 175),
        border = Color3.fromRGB(50, 50, 62),
    },
    midnight = {
        bg = Color3.fromRGB(10, 12, 18),
        container = Color3.fromRGB(16, 18, 26),
        element = Color3.fromRGB(22, 26, 36),
        hover = Color3.fromRGB(30, 36, 48),
        active = Color3.fromRGB(40, 48, 64),
        accent = Color3.fromRGB(90, 160, 255),
        text = Color3.fromRGB(235, 240, 250),
        subtext = Color3.fromRGB(140, 150, 170),
        border = Color3.fromRGB(40, 48, 64),
    },
}

local function rnd(n)
    n = n or 12
    local a = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local s = ""
    for i = 1, n do
        local idx = math.random(1, #a)
        s = s .. a:sub(idx, idx)
    end
    return s
end

local function make(class, props)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            pcall(function() o[k] = v end)
        end
    end
    if props and props.Parent then
        o.Parent = props.Parent
    end
    return o
end

local function protect(gui)
    if gethui then
        pcall(function() gui.Parent = gethui() end)
    else
        local lp = localui.svc.plr.LocalPlayer
        gui.Parent = lp:FindFirstChildOfClass("PlayerGui") or lp:WaitForChild("PlayerGui")
    end
    pcall(function() gui:SetAttribute("lui", true) end)
end

local CONFIG_FOLDER = "LocalData"

local function ensure_folder(path)
    if isfolder and not isfolder(path) then
        pcall(makefolder, path)
    end
end

local function load_config(game_name, config_name)
    if not (isfile and readfile) then return nil end
    local path = CONFIG_FOLDER .. "/" .. game_name .. "/" .. config_name .. ".json"
    if not isfile(path) then return nil end
    local ok, raw = pcall(readfile, path)
    if not ok then return nil end
    local ok2, data = pcall(function() return localui.svc.http:JSONDecode(raw) end)
    return ok2 and data or nil
end

function localui.notify(title, text, duration)
    duration = duration or 3
    local gui = make("ScreenGui", {
        Name = rnd(),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100,
    })
    protect(gui)
    local frame = make("Frame", {
        Parent = gui,
        BackgroundColor3 = Color3.fromRGB(24, 24, 30),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 260, 0, 64),
        Position = UDim2.new(1, -280, 0, 20),
    })
    make("UICorner", { Parent = frame, CornerRadius = UDim.new(0, 8) })
    make("TextLabel", {
        Parent = frame,
        BackgroundTransparency = 1,
        Text = tostring(title or ""),
        TextColor3 = Color3.fromRGB(240, 240, 245),
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        Size = UDim2.new(1, -16, 0, 22),
        Position = UDim2.new(0, 10, 0, 8),
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    make("TextLabel", {
        Parent = frame,
        BackgroundTransparency = 1,
        Text = tostring(text or ""),
        TextColor3 = Color3.fromRGB(160, 160, 175),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Size = UDim2.new(1, -16, 0, 24),
        Position = UDim2.new(0, 10, 0, 30),
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    task.delay(duration, function()
        pcall(function() gui:Destroy() end)
    end)
end

function localui.new(title, options)
    options = options or {}
    local theme = options.Theme or localui.presets.default
    if type(theme) == "string" and localui.presets[theme] then
        theme = localui.presets[theme]
    end
    for k, v in pairs(localui.presets.default) do
        if theme[k] == nil then theme[k] = v end
    end

    local game_name = options.GameName or "Default"
    local flags = {}
    local flag_setters = {}
    local conns = {}

    if getgenv and getgenv().__lui_inst then
        pcall(function() getgenv().__lui_inst:destroy() end)
        getgenv().__lui_inst = nil
    end

    local gui = make("ScreenGui", {
        Name = rnd(),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 50,
    })
    protect(gui)

    local root = make("Frame", {
        Parent = gui,
        Name = rnd(),
        BackgroundColor3 = theme.bg,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 520, 0, 400),
        Position = UDim2.new(0.5, -260, 0.5, -200),
        Active = true,
    })
    make("UICorner", { Parent = root, CornerRadius = UDim.new(0, 10) })
    make("UIStroke", { Parent = root, Color = theme.border, Thickness = 1 })

    local top = make("Frame", {
        Parent = root,
        BackgroundColor3 = theme.container,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 36),
    })
    make("UICorner", { Parent = top, CornerRadius = UDim.new(0, 10) })
    make("TextLabel", {
        Parent = top,
        BackgroundTransparency = 1,
        Text = tostring(title or "Menu"),
        TextColor3 = theme.text,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local close = make("TextButton", {
        Parent = top,
        BackgroundTransparency = 1,
        Text = "x",
        TextColor3 = theme.subtext,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        Size = UDim2.new(0, 32, 1, 0),
        Position = UDim2.new(1, -36, 0, 0),
    })

    local side = make("Frame", {
        Parent = root,
        BackgroundColor3 = theme.container,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 120, 1, -36),
        Position = UDim2.new(0, 0, 0, 36),
    })
    local pages = make("Frame", {
        Parent = root,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -128, 1, -44),
        Position = UDim2.new(0, 124, 0, 40),
    })

    local dragging, drag_start, start_pos
    top.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            drag_start = inp.Position
            start_pos = root.Position
        end
    end)
    top.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    table.insert(conns, localui.svc.inp.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local d = inp.Position - drag_start
            root.Position = UDim2.new(start_pos.X.Scale, start_pos.X.Offset + d.X, start_pos.Y.Scale, start_pos.Y.Offset + d.Y)
        end
    end))

    local w = {
        gui = gui,
        root = root,
        flags = flags,
        theme = theme,
    }

    function w:destroy()
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        if gui then pcall(function() gui:Destroy() end) end
        if getgenv then getgenv().__lui_inst = nil end
    end

    close.MouseButton1Click:Connect(function() w:destroy() end)

    function w:notify(title, text, duration)
        localui.notify(title, text, duration)
    end

    function w:apply_theme(over)
        if type(over) == "string" and localui.presets[over] then over = localui.presets[over] end
        if type(over) ~= "table" then return end
        for k, v in pairs(over) do theme[k] = v end
        root.BackgroundColor3 = theme.bg
        top.BackgroundColor3 = theme.container
        side.BackgroundColor3 = theme.container
    end

    function w:accent(c)
        if typeof(c) == "Color3" then theme.accent = c end
    end

    local tabs = {}
    local active_page

    function w:tab(name, icon)
        local btn = make("TextButton", {
            Parent = side,
            BackgroundColor3 = theme.element,
            BorderSizePixel = 0,
            Text = tostring(name),
            TextColor3 = theme.text,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            Size = UDim2.new(1, -12, 0, 28),
            Position = UDim2.new(0, 6, 0, 8 + (#tabs * 34)),
        })
        make("UICorner", { Parent = btn, CornerRadius = UDim.new(0, 6) })

        local page = make("ScrollingFrame", {
            Parent = pages,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 3,
            Visible = false,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
        })
        make("UIListLayout", {
            Parent = page,
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        local tab = { page = page, name = name }

        local function show()
            if active_page then active_page.Visible = false end
            page.Visible = true
            active_page = page
            for _, t in ipairs(tabs) do
                t.btn.BackgroundColor3 = theme.element
            end
            btn.BackgroundColor3 = theme.active
        end
        btn.MouseButton1Click:Connect(show)
        tab.btn = btn
        table.insert(tabs, tab)
        if #tabs == 1 then show() end

        local function row()
            local f = make("Frame", {
                Parent = page,
                BackgroundColor3 = theme.element,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -4, 0, 32),
            })
            make("UICorner", { Parent = f, CornerRadius = UDim.new(0, 6) })
            return f
        end

        function tab:button(text, cb, flag)
            local f = row()
            local b = make("TextButton", {
                Parent = f,
                BackgroundTransparency = 1,
                Text = tostring(text),
                TextColor3 = theme.text,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                Size = UDim2.new(1, 0, 1, 0),
            })
            b.MouseButton1Click:Connect(function()
                if cb then pcall(cb) end
            end)
            return b
        end

        function tab:toggle(text, default, cb, flag)
            local state = default and true or false
            local f = row()
            make("TextLabel", {
                Parent = f,
                BackgroundTransparency = 1,
                Text = tostring(text),
                TextColor3 = theme.text,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                Size = UDim2.new(1, -50, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            local sw = make("TextButton", {
                Parent = f,
                BackgroundColor3 = state and theme.accent or theme.hover,
                Text = "",
                Size = UDim2.new(0, 36, 0, 18),
                Position = UDim2.new(1, -44, 0.5, -9),
                BorderSizePixel = 0,
            })
            make("UICorner", { Parent = sw, CornerRadius = UDim.new(1, 0) })
            local function set(v, fire)
                state = not not v
                sw.BackgroundColor3 = state and theme.accent or theme.hover
                if flag then flags[flag] = state end
                if fire ~= false and cb then pcall(cb, state) end
            end
            sw.MouseButton1Click:Connect(function() set(not state, true) end)
            if flag then
                flags[flag] = state
                flag_setters[flag] = set
            end
            return { set = set, get = function() return state end }
        end

        function tab:slider(text, min, max, default, cb, flag, step)
            min, max = min or 0, max or 100
            local val = default or min
            step = step or 1
            local f = make("Frame", {
                Parent = page,
                BackgroundColor3 = theme.element,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -4, 0, 48),
            })
            make("UICorner", { Parent = f, CornerRadius = UDim.new(0, 6) })
            make("TextLabel", {
                Parent = f,
                BackgroundTransparency = 1,
                Text = tostring(text),
                TextColor3 = theme.text,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                Size = UDim2.new(1, -60, 0, 20),
                Position = UDim2.new(0, 10, 0, 4),
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            local val_lbl = make("TextLabel", {
                Parent = f,
                BackgroundTransparency = 1,
                Text = tostring(val),
                TextColor3 = theme.subtext,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                Size = UDim2.new(0, 50, 0, 20),
                Position = UDim2.new(1, -54, 0, 4),
                TextXAlignment = Enum.TextXAlignment.Right,
            })
            local track = make("Frame", {
                Parent = f,
                BackgroundColor3 = theme.hover,
                BorderSizePixel = 0,
                Size = UDim2.new(1, -20, 0, 4),
                Position = UDim2.new(0, 10, 0, 32),
            })
            make("UICorner", { Parent = track, CornerRadius = UDim.new(1, 0) })
            local fill = make("Frame", {
                Parent = track,
                BackgroundColor3 = theme.accent,
                BorderSizePixel = 0,
                Size = UDim2.new((val - min) / math.max(max - min, 1), 0, 1, 0),
            })
            make("UICorner", { Parent = fill, CornerRadius = UDim.new(1, 0) })

            local function set(v, fire)
                v = math.clamp(v, min, max)
                if step > 0 then v = math.floor(v / step + 0.5) * step end
                val = v
                fill.Size = UDim2.new((val - min) / math.max(max - min, 1), 0, 1, 0)
                val_lbl.Text = tostring(val)
                if flag then flags[flag] = val end
                if fire ~= false and cb then pcall(cb, val) end
            end

            local sliding = false
            track.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                end
            end)
            table.insert(conns, localui.svc.inp.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end))
            table.insert(conns, localui.svc.inp.InputChanged:Connect(function(inp)
                if not sliding then return end
                if inp.UserInputType ~= Enum.UserInputType.MouseMovement and inp.UserInputType ~= Enum.UserInputType.Touch then return end
                local rel = (inp.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1)
                set(min + rel * (max - min), true)
            end))

            if flag then
                flags[flag] = val
                flag_setters[flag] = set
            end
            return { set = set, get = function() return val end }
        end

        function tab:section(text)
            local f = make("TextLabel", {
                Parent = page,
                BackgroundTransparency = 1,
                Text = tostring(text),
                TextColor3 = theme.subtext,
                Font = Enum.Font.GothamMedium,
                TextSize = 12,
                Size = UDim2.new(1, -4, 0, 22),
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            return f
        end

        function tab:label(text)
            return tab:section(text)
        end

        return tab
    end

    if options.AutoLoad then
        local data = load_config(game_name, options.AutoLoad)
        if type(data) == "table" then
            task.defer(function()
                for k, v in pairs(data) do
                    if flag_setters[k] then
                        pcall(flag_setters[k], v, true)
                    end
                end
            end)
        end
    end

    table.insert(conns, localui.svc.inp.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.KeyCode == Enum.KeyCode.RightControl then
            root.Visible = not root.Visible
        end
    end))

    if getgenv then getgenv().__lui_inst = w end
    return w
end

function localui.spotify()
    return { destroy = function() end, set = function() end }
end

function localui.island()
    return { destroy = function() end, set = function() end, expand = function() end, collapse = function() end }
end

return localui
