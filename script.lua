--[[ ⚡ UNIVERSAL HUB - BY KAKAMIKAZE ⚡ ]]
if _G.KakaHubLoaded then pcall(function() _G.KakaHub:Destroy() end) end
_G.KakaHubLoaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    SpeedValue = 16, FlySpeed = 50, FlyEnabled = false,
    NoClip = false, Invisible = false, Fullbright = false, NoFog = false,
    HitboxSize = 10, HitboxEnabled = false, InfiniteJump = false,
    AntiAFK = false, JumpPower = 50,
}

local OriginalFog = Lighting.FogEnd
local OriginalBrightness = Lighting.Brightness

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KakaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
_G.KakaHub = ScreenGui

local viewport = Camera.ViewportSize
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local uiScale = isMobile and math.clamp(viewport.X / 500, 0.85, 1.15) or 1

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 48, 0, 48)
ToggleBtn.Position = UDim2.new(0, 10, 0, 80)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 170)
ToggleBtn.Text = "K"
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.TextSize = 22
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(0, 255, 170); btnStroke.Thickness = 2; btnStroke.Parent = ToggleBtn

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, math.floor(310 * uiScale), 0, math.floor(480 * uiScale))
Main.Position = UDim2.new(0.5, -math.floor(155 * uiScale), 0.5, -math.floor(240 * uiScale))
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 20)
Main.BorderSizePixel = 0; Main.Visible = false; Main.Active = true; Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(0, 255, 170); mainStroke.Thickness = 1.5; mainStroke.Transparency = 0.3
mainStroke.Parent = Main

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, math.floor(60 * uiScale))
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
Header.BorderSizePixel = 0; Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 0, math.floor(32 * uiScale))
Title.Position = UDim2.new(0, 12, 0, 6)
Title.BackgroundTransparency = 1
Title.Text = "⚡ BY KAKAMIKAZE ⚡"
Title.TextColor3 = Color3.fromRGB(0, 255, 170)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = math.floor(15 * uiScale)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -70, 0, math.floor(20 * uiScale))
SubTitle.Position = UDim2.new(0, 12, 0, math.floor(34 * uiScale))
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Universal Hub • Mobile Edition"
SubTitle.TextColor3 = Color3.fromRGB(140, 140, 160)
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = math.floor(11 * uiScale)
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, math.floor(28 * uiScale), 0, math.floor(28 * uiScale))
CloseBtn.Position = UDim2.new(1, -math.floor(36 * uiScale), 0, math.floor(10 * uiScale))
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 60)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = math.floor(14 * uiScale)
CloseBtn.BorderSizePixel = 0; CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)

ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    if Main.Visible then
        Main.Position = UDim2.new(0.5, -Main.AbsoluteSize.X/2, 0.5, -Main.AbsoluteSize.Y/2)
    end
end)

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -16, 0, math.floor(38 * uiScale))
TabBar.Position = UDim2.new(0, 8, 0, math.floor(66 * uiScale))
TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
TabBar.BorderSizePixel = 0; TabBar.Parent = Main
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 8)

local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Size = UDim2.new(1, 0, 1, 0)
TabScroll.BackgroundTransparency = 1
TabScroll.BorderSizePixel = 0
TabScroll.ScrollBarThickness = 0
TabScroll.ScrollDirection = Enum.ScrollDirection.Horizontal
TabScroll.Parent = TabBar
local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 4)
TabLayout.Parent = TabScroll

local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -16, 1, -math.floor(112 * uiScale))
PageContainer.Position = UDim2.new(0, 8, 0, math.floor(110 * uiScale))
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = Main

local Pages, TabButtons = {}, {}

local function CreateTab(name, icon)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, math.floor(68 * uiScale), 1, -8)
    btn.Position = UDim2.new(0, 0, 0, 4)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    btn.TextColor3 = Color3.fromRGB(180, 180, 200)
    btn.Text = icon .. " " .. name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = math.floor(10 * uiScale)
    btn.BorderSizePixel = 0; btn.Parent = TabScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 170)
    page.Visible = false; page.Parent = PageContainer
    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Padding = UDim.new(0, 5)
    pageLayout.Parent = page

    Pages[name] = {Page = page, Layout = pageLayout}
    table.insert(TabButtons, {Btn = btn, Name = name})

    btn.MouseButton1Click:Connect(function()
        for _, d in pairs(Pages) do d.Page.Visible = false end
        for _, tb in ipairs(TabButtons) do
            tb.Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            tb.Btn.TextColor3 = Color3.fromRGB(180, 180, 200)
        end
        page.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
        btn.TextColor3 = Color3.fromRGB(10, 10, 20)
    end)
end

for _, t in ipairs({{"MOVE","🏃"},{"VISÃO","👁️"},{"COMBATE","⚔️"},{"TELEPORT","✨"},{"UTIL","🛠️"}}) do
    CreateTab(t[1], t[2])
end

TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabScroll.CanvasSize = UDim2.new(0, TabLayout.AbsoluteContentSize.X + 10, 0, 0)
end)

local function GetPage(n) return Pages[n].Page end

local function MakeSection(page, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, math.floor(22 * uiScale))
    lbl.BackgroundTransparency = 1
    lbl.Text = "▸ " .. text
    lbl.TextColor3 = Color3.fromRGB(0, 255, 170)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = math.floor(12 * uiScale)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = page
end

local function MakeButton(page, text, cb, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, math.floor(36 * uiScale))
    btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = math.floor(13 * uiScale)
    btn.BorderSizePixel = 0; btn.Parent = page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
    btn.MouseButton1Click:Connect(function()
        local o = btn.BackgroundColor3
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 130)
        task.wait(0.12)
        btn.BackgroundColor3 = o
        cb()
    end)
end

local function MakeToggle(page, text, default, cb)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, math.floor(36 * uiScale))
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    frame.BorderSizePixel = 0; frame.Parent = page
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 7)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -50, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text; lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = math.floor(13 * uiScale)
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = frame
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 42, 0, 22)
    btn.Position = UDim2.new(1, -50, 0.5, -11)
    btn.BackgroundColor3 = default and Color3.fromRGB(0,220,150) or Color3.fromRGB(60,60,80)
    btn.Text = ""; btn.BorderSizePixel = 0; btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = default and UDim2.new(0,24,0.5,-8) or UDim2.new(0,3,0.5,-8)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    knob.BorderSizePixel = 0; knob.Parent = btn
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0,220,150) or Color3.fromRGB(60,60,80)
        TweenService:Create(knob, TweenInfo.new(0.15), {
            Position = state and UDim2.new(0,24,0.5,-8) or UDim2.new(0,3,0.5,-8)
        }):Play()
        cb(state)
    end)
end

local function MakeSlider(page, name, min, max, default, cb)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, math.floor(56 * uiScale))
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    frame.BorderSizePixel = 0; frame.Parent = page
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 7)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -14, 0, math.floor(22 * uiScale))
    lbl.Position = UDim2.new(0, 8, 0, 3)
    lbl.BackgroundTransparency = 1
    lbl.Text = name .. ": " .. default
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = math.floor(12 * uiScale)
    lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = frame
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -20, 0, math.floor(10 * uiScale))
    bar.Position = UDim2.new(0, 10, 0, math.floor(36 * uiScale))
    bar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    bar.BorderSizePixel = 0; bar.Parent = frame
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
    fill.BorderSizePixel = 0; fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local dragging = false
    local function update(input)
        local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1)
        local v = math.floor(min + (max-min)*rel + 0.5)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        lbl.Text = name .. ": " .. v
        cb(v)
    end
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; update(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local dragToggle, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true; dragStart = input.Position; startPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = false
    end
end)

-- MOVIMENTO
local mp = GetPage("MOVE")
MakeSection(mp, "SPEED HACK")
MakeSlider(mp, "WalkSpeed", 1, 100, 16, function(v)
    Config.SpeedValue = v
    local c = LocalPlayer.Character
    if c and c:FindFirstChild("Humanoid") then c.Humanoid.WalkSpeed = v end
end)
MakeToggle(mp, "Speed Ativado", false, function(s)
    local c = LocalPlayer.Character
    if c and c:FindFirstChild("Humanoid") then
        c.Humanoid.WalkSpeed = s and Config.SpeedValue or 16
    end
end)

MakeSection(mp, "JUMP POWER")
MakeSlider(mp, "JumpPower", 1, 200, 50, function(v)
    Config.JumpPower = v
    local c = LocalPlayer.Character
    if c and c:FindFirstChild("Humanoid") then
        c.Humanoid.UseJumpPower = true
        c.Humanoid.JumpPower = v
    end
end)

MakeSection(mp, "FLY HACK")
MakeSlider(mp, "Fly Speed", 10, 200, 50, function(v) Config.FlySpeed = v end)
MakeToggle(mp, "Fly Ativado", false, function(state)
    Config.FlyEnabled = state
    local c = LocalPlayer.Character
    if not c then return end
    local hrp, hum = c:FindFirstChild("HumanoidRootPart"), c:FindFirstChild("Humanoid")
    if not (hrp and hum) then return end
    if state then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "KakaFlyBV"; bv.MaxForce = Vector3.new(1e5,1e5,1e5); bv.Velocity = Vector3.zero; bv.Parent = hrp
        local bg = Instance.new("BodyGyro")
        bg.Name = "KakaFlyBG"; bg.MaxTorque = Vector3.new(1e5,1e5,1e5); bg.P = 1000; bg.Parent = hrp
        hum.PlatformStand = true
    else
        if hrp:FindFirstChild("KakaFlyBV") then hrp.KakaFlyBV:Destroy() end
        if hrp:FindFirstChild("KakaFlyBG") then hrp.KakaFlyBG:Destroy() end
        hum.PlatformStand = false
    end
end)

MakeSection(mp, "NOCLIP & JUMP")
MakeToggle(mp, "Noclip", false, function(s) Config.NoClip = s end)
MakeToggle(mp, "Infinite Jump", false, function(s) Config.InfiniteJump = s end)

-- VISÃO
local vp = GetPage("VISÃO")
MakeSection(vp, "INVISIBILIDADE")
MakeToggle(vp, "Invisible", false, function(state)
    Config.Invisible = state
    local c = LocalPlayer.Character
    if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Transparency = state and 1 or 0
            p.CanCollide = state and false or true
        elseif p:IsA("Decal") then p.Transparency = state and 1 or 0 end
    end
end)

MakeSection(vp, "AMBIENTE")
MakeToggle(vp, "Fullbright", false, function(s)
    Config.Fullbright = s
    Lighting.Brightness = s and 5 or OriginalBrightness
    Lighting.GlobalShadows = not s
end)
MakeToggle(vp, "No Fog", false, function(s)
    Config.NoFog = s
    Lighting.FogEnd = s and 1e10 or OriginalFog
end)

MakeSection(vp, "CAMERA")
MakeSlider(vp, "FOV", 50, 120, 70, function(v) Camera.FieldOfView = v end)
MakeButton(vp, "Reset FOV (70)", function() Camera.FieldOfView = 70 end)

-- COMBATE
local cp = GetPage("COMBATE")
MakeSection(cp, "HITBOX")
MakeSlider(cp, "Hitbox Size", 1, 50, 10, function(v)
    Config.HitboxSize = v
    if Config.HitboxEnabled then
        local c = LocalPlayer.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Size = Vector3.new(v, v, v) end
    end
end)
MakeToggle(cp, "Hitbox Expandido", false, function(state)
    Config.HitboxEnabled = state
    local c = LocalPlayer.Character
    local hrp = c and c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if state then
        hrp.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
        hrp.Transparency = 0.5; hrp.CanCollide = false
    else
        hrp.Size = Vector3.new(2, 2, 1)
        hrp.Transparency = 1; hrp.CanCollide = true
    end
end)

MakeSection(cp, "KNOCKBACK")
MakeToggle(cp, "No Knockback", false, function(state)
    local c = LocalPlayer.Character
    local hrp = c and c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CustomPhysicalProperties = state and PhysicalProperties.new(0.01,0.01,0.01,1,1) or nil
end)

MakeSection(cp, "AUTO")
MakeToggle(cp, "Anti-AFK", false, function(s) Config.AntiAFK = s end)

-- TELEPORT
local tp = GetPage("TELEPORT")
MakeSection(tp, "TP TOOL")
MakeButton(tp, "🔧 Dar TP Tool", function()
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if not bp then return end
    local old = bp:FindFirstChild("KakaTPTool")
    if old then old:Destroy() end
    local tool = Instance.new("Tool")
    tool.Name = "KakaTPTool"; tool.RequiresHandle = false; tool.CanBeDropped = false
    tool.Activated:Connect(function()
        local c = LocalPlayer.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local mouse = LocalPlayer:GetMouse()
        if mouse.Target then hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,3,0)) end
    end)
    tool.Parent = bp
end)

MakeSection(tp, "TP JOGADORES")
local tpFrame = Instance.new("ScrollingFrame")
tpFrame.Size = UDim2.new(1, 0, 0, math.floor(150 * uiScale))
tpFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
tpFrame.BorderSizePixel = 0
tpFrame.ScrollBarThickness = 3
tpFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 170)
tpFrame.Parent = tp
Instance.new("UICorner", tpFrame).CornerRadius = UDim.new(0, 7)
local tpLayout = Instance.new("UIListLayout")
tpLayout.Padding = UDim.new(0, 3); tpLayout.Parent = tpFrame

local function RefreshPlayers()
    for _, c in ipairs(tpFrame:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -8, 0, math.floor(30 * uiScale))
            b.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            b.TextColor3 = Color3.fromRGB(255,255,255)
            b.Text = "👤 " .. plr.Name
            b.Font = Enum.Font.Gotham
            b.TextSize = math.floor(12 * uiScale)
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.BorderSizePixel = 0; b.Parent = tpFrame
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
            local pad = Instance.new("UIPadding", b)
            pad.PaddingLeft = UDim.new(0, 8)
            b.MouseButton1Click:Connect(function()
                local tChar = plr.Character
                local mChar = LocalPlayer.Character
                local mHRP = mChar and mChar:FindFirstChild("HumanoidRootPart")
                if tChar and mHRP then
                    local tHRP = tChar:FindFirstChild("HumanoidRootPart")
                    if tHRP then mHRP.CFrame = tHRP.CFrame + Vector3.new(3,0,0) end
                end
            end)
        end
    end
    tpFrame.CanvasSize = UDim2.new(0, 0, 0, tpLayout.AbsoluteContentSize.Y + 5)
end
RefreshPlayers()
Players.PlayerAdded:Connect(RefreshPlayers)
Players.PlayerRemoving:Connect(function() task.wait(1) RefreshPlayers() end)

MakeButton(tp, "🔄 Atualizar Lista", RefreshPlayers)
MakeButton(tp, "📍 TP para Mouse", function()
    local c = LocalPlayer.Character
    local hrp = c and c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local mouse = LocalPlayer:GetMouse()
    if mouse.Hit then hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,3,0)) end
end)

-- UTIL
local up = GetPage("UTIL")
MakeSection(up, "INFO")
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, 0, 0, math.floor(50 * uiScale))
info.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
info.TextColor3 = Color3.fromRGB(180, 180, 200)
info.Text = "By Kakamikaze • Universal Hub\nJogo ID: " .. game.PlaceId
info.Font = Enum.Font.Gotham
info.TextSize = math.floor(11 * uiScale)
info.TextWrapped = true; info.Parent = up
Instance.new("UICorner", info).CornerRadius = UDim.new(0, 7)

MakeSection(up, "RESPAWN")
MakeButton(up, "💀 Resetar Personagem", function()
    local c = LocalPlayer.Character
    if c and c:FindFirstChild("Humanoid") then c.Humanoid.Health = 0 end
end)

MakeSection(up, "SERVER")
MakeButton(up, "🚪 Rejoin", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

MakeSection(up, "RESET GERAL")
MakeButton(up, "🔄 Resetar Tudo", function()
    Config.SpeedValue = 16; Config.FlyEnabled = false; Config.NoClip = false
    Config.Invisible = false; Config.HitboxEnabled = false; Config.InfiniteJump = false
    local c = LocalPlayer.Character
    if c then
        local hum = c:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = 16; hum.JumpPower = 50; hum.PlatformStand = false end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if hrp then
            if hrp:FindFirstChild("KakaFlyBV") then hrp.KakaFlyBV:Destroy() end
            if hrp:FindFirstChild("KakaFlyBG") then hrp.KakaFlyBG:Destroy() end
            hrp.CustomPhysicalProperties = nil
            hrp.Size = Vector3.new(2, 2, 1)
            hrp.Transparency = 1
            hrp.CanCollide = true
        end
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = true; p.Transparency = 0
            elseif p:IsA("Decal") then p.Transparency = 0 end
        end
    end
    Lighting.Brightness = OriginalBrightness
    Lighting.FogEnd = OriginalFog
    Lighting.GlobalShadows = true
    Camera.FieldOfView = 70
end, Color3.fromRGB(120, 40, 60))

-- LOOPS
RunService.RenderStepped:Connect(function()
    if not Config.FlyEnabled then return end
    local c = LocalPlayer.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    local bv = hrp and hrp:FindFirstChild("KakaFlyBV")
    if not (hrp and bv) then return end
    local move = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end
    bv.Velocity = move.Magnitude > 0 and move.Unit * Config.FlySpeed or Vector3.zero
    hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Camera.CFrame.LookVector)
end)

RunService.Stepped:Connect(function()
    if not Config.NoClip then return end
    local c = LocalPlayer.Character
    if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = false end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if Config.InfiniteJump then
        local c = LocalPlayer.Character
        local hum = c and c:FindFirstChild("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if Config.Invisible then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.Transparency = 1 end
        end
    end
end)

print("[KakaHub] Carregado com sucesso! ✅ By Kakamikaze")
