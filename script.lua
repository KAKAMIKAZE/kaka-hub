if _G.KakaHubLoaded then pcall(function() _G.KakaHub:Destroy() end) end
_G.KakaHubLoaded = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {Speed=16, FlySpeed=50, Fly=false, Noclip=false, Invis=false, Hitbox=10, InfJump=false}
local OrigFog, OrigBright = Lighting.FogEnd, Lighting.Brightness

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KakaHub"; ScreenGui.ResetOnSpawn = false; ScreenGui.IgnoreGuiInset = true
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
_G.KakaHub = ScreenGui

local scale = (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled) and math.clamp(Camera.ViewportSize.X/500, 0.85, 1.15) or 1

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 48, 0, 48); ToggleBtn.Position = UDim2.new(0, 10, 0, 80)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 25); ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 170)
ToggleBtn.Text = "K"; ToggleBtn.Font = Enum.Font.GothamBlack; ToggleBtn.TextSize = 22; ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, math.floor(310*scale), 0, math.floor(480*scale))
Main.Position = UDim2.new(0.5, -math.floor(155*scale), 0.5, -math.floor(240*scale))
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 20); Main.Visible = false; Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, math.floor(60*scale)); Header.BackgroundColor3 = Color3.fromRGB(20, 20, 32); Header.Parent = Main
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 0, math.floor(32*scale)); Title.Position = UDim2.new(0, 12, 0, 6)
Title.BackgroundTransparency = 1; Title.Text = "⚡ BY KAKAMIKAZE ⚡"; Title.TextColor3 = Color3.fromRGB(0, 255, 170)
Title.Font = Enum.Font.GothamBlack; Title.TextSize = math.floor(15*scale); Title.TextXAlignment = Enum.TextXAlignment.Left; Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, math.floor(28*scale), 0, math.floor(28*scale)); CloseBtn.Position = UDim2.new(1, -math.floor(36*scale), 0, math.floor(10*scale))
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 60); CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Text = "✕"; CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = math.floor(14*scale); CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)

ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    if Main.Visible then Main.Position = UDim2.new(0.5, -Main.AbsoluteSize.X/2, 0.5, -Main.AbsoluteSize.Y/2) end
end)

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -16, 0, math.floor(38*scale)); TabBar.Position = UDim2.new(0, 8, 0, math.floor(66*scale))
TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 32); TabBar.Parent = Main
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 8)

local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Size = UDim2.new(1, 0, 1, 0); TabScroll.BackgroundTransparency = 1; TabScroll.ScrollBarThickness = 0
TabScroll.ScrollDirection = Enum.ScrollDirection.Horizontal; TabScroll.Parent = TabBar
local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal; TabLayout.Padding = UDim.new(0, 4); TabLayout.Parent = TabScroll

local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -16, 1, -math.floor(112*scale)); PageContainer.Position = UDim2.new(0, 8, 0, math.floor(110*scale))
PageContainer.BackgroundTransparency = 1; PageContainer.Parent = Main

local Pages, TabButtons = {}, {}

local function CreateTab(name, icon)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, math.floor(68*scale), 1, -8); btn.Position = UDim2.new(0, 0, 0, 4)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45); btn.TextColor3 = Color3.fromRGB(180, 180, 200)
    btn.Text = icon .. " " .. name; btn.Font = Enum.Font.GothamBold; btn.TextSize = math.floor(10*scale); btn.Parent = TabScroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.ScrollBarThickness = 3
    page.Visible = false; page.Parent = PageContainer
    local lay = Instance.new("UIListLayout"); lay.Padding = UDim.new(0, 5); lay.Parent = page
    
    Pages[name] = {Page = page, Layout = lay}; table.insert(TabButtons, {Btn = btn, Name = name})
    
    btn.MouseButton1Click:Connect(function()
        for _, d in pairs(Pages) do d.Page.Visible = false end
        for _, tb in ipairs(TabButtons) do
            tb.Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45); tb.Btn.TextColor3 = Color3.fromRGB(180, 180, 200)
        end
        page.Visible = true; btn.BackgroundColor3 = Color3.fromRGB(0, 255, 170); btn.TextColor3 = Color3.fromRGB(10, 10, 20)
    end)
end

for _, t in ipairs({{"MOVE","🏃"},{"VISÃO","👁️"},{"COMBATE","⚔️"},{"TELEPORT","✨"},{"UTIL","🛠️"}}) do CreateTab(t[1], t[2]) end

TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabScroll.CanvasSize = UDim2.new(0, TabLayout.AbsoluteContentSize.X + 10, 0, 0)
end)

local function GetPage(n) return Pages[n].Page end

local function MakeSection(page, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, math.floor(22*scale)); lbl.BackgroundTransparency = 1
    lbl.Text = "▸ " .. text; lbl.TextColor3 = Color3.fromRGB(0, 255, 170)
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = math.floor(12*scale); lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = page
end

local function MakeButton(page, text, cb)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, math.floor(36*scale)); btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Text = text; btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = math.floor(13*scale); btn.Parent = page
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
    btn.MouseButton1Click:Connect(function() cb() end)
end

local function MakeToggle(page, text, default, cb)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, math.floor(36*scale)); frame.BackgroundColor3 = Color3.fromRGB(30, 30, 45); frame.Parent = page
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 7)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -50, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0); lbl.BackgroundTransparency = 1
    lbl.Text = text; lbl.TextColor3 = Color3.fromRGB(255,255,255); lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = math.floor(13*scale); lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = frame
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 42, 0, 22); btn.Position = UDim2.new(1, -50, 0.5, -11)
    btn.BackgroundColor3 = default and Color3.fromRGB(0,220,150) or Color3.fromRGB(60,60,80); btn.Text = ""; btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16); knob.Position = default and UDim2.new(0,24,0.5,-8) or UDim2.new(0,3,0.5,-8)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255); knob.Parent = btn
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state; btn.BackgroundColor3 = state and Color3.fromRGB(0,220,150) or Color3.fromRGB(60,60,80)
        TweenService:Create(knob, TweenInfo.new(0.15), {Position = state and UDim2.new(0,24,0.5,-8) or UDim2.new(0,3,0.5,-8)}):Play()
        cb(state)
    end)
end

local function MakeSlider(page, name, min, max, default, cb)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, math.floor(56*scale)); frame.BackgroundColor3 = Color3.fromRGB(30, 30, 45); frame.Parent = page
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 7)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -14, 0, math.floor(22*scale)); lbl.Position = UDim2.new(0, 8, 0, 3); lbl.BackgroundTransparency = 1
    lbl.Text = name .. ": " .. default; lbl.TextColor3 = Color3.fromRGB(255,255,255); lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = math.floor(12*scale); lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = frame
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -20, 0, math.floor(10*scale)); bar.Position = UDim2.new(0, 10, 0, math.floor(36*scale))
    bar.BackgroundColor3 = Color3.fromRGB(15, 15, 25); bar.Parent = frame
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(0, 255, 170); fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local dragging = false
    local function update(input)
        local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1)
        local v = math.floor(min + (max-min)*rel + 0.5); fill.Size = UDim2.new(rel, 0, 1, 0); lbl.Text = name .. ": " .. v; cb(v)
    end
    bar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; update(input) end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
end

local dT, dS, sP
Header.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dT = true; dS = input.Position; sP = Main.Position end end)
UserInputService.InputChanged:Connect(function(input) if dT and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local d = input.Position - dS; Main.Position = UDim2.new(sP.X.Scale, sP.X.Offset + d.X, sP.Y.Scale, sP.Y.Offset + d.Y) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dT = false end end)

-- MOVE
local mp = GetPage("MOVE")
MakeSection(mp, "SPEED HACK")
MakeSlider(mp, "Speed", 1, 100, 16, function(v) Config.Speed = v; local c = LocalPlayer.Character; if c and c:FindFirstChild("Humanoid") then c.Humanoid.WalkSpeed = v end end)
MakeSection(mp, "JUMP POWER")
MakeSlider(mp, "JumpPower", 1, 200, 50, function(v) local c = LocalPlayer.Character; if c and c:FindFirstChild("Humanoid") then c.Humanoid.UseJumpPower = true; c.Humanoid.JumpPower = v end end)
MakeSection(mp, "FLY HACK")
MakeSlider(mp, "FlySpeed", 10, 200, 50, function(v) Config.FlySpeed = v end)
MakeToggle(mp, "Fly", false, function(s)
    Config.Fly = s; local c = LocalPlayer.Character; if not c then return end
    local hrp, hum = c:FindFirstChild("HumanoidRootPart"), c:FindFirstChild("Humanoid"); if not (hrp and hum) then return end
    if s then
        local bv = Instance.new("BodyVelocity"); bv.Name = "KBV"; bv.MaxForce = Vector3.new(1e5,1e5,1e5); bv.Parent = hrp
        local bg = Instance.new("BodyGyro"); bg.Name = "KBG"; bg.MaxTorque = Vector3.new(1e5,1e5,1e5); bg.P = 1000; bg.Parent = hrp; hum.PlatformStand = true
    else
        if hrp:FindFirstChild("KBV") then hrp.KBV:Destroy() end; if hrp:FindFirstChild("KBG") then hrp.KBG:Destroy() end; hum.PlatformStand = false
    end
end)
MakeSection(mp, "NOCLIP & JUMP")
MakeToggle(mp, "Noclip", false, function(s) Config.Noclip = s end)
MakeToggle(mp, "InfJump", false, function(s) Config.InfJump = s end)

-- VISÃO
local vp = GetPage("VISÃO")
MakeSection(vp, "INVISIBILIDADE")
MakeToggle(vp, "Invisible", false, function(s)
    Config.Invis = s; local c = LocalPlayer.Character; if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then p.Transparency = s and 1 or 0; p.CanCollide = s and false or true
        elseif p:IsA("Decal") then p.Transparency = s and 1 or 0 end
    end
end)
MakeSection(vp, "AMBIENTE")
MakeToggle(vp, "Fullbright", false, function(s) Lighting.Brightness = s and 5 or OrigBright; Lighting.GlobalShadows = not s end)
MakeToggle(vp, "No Fog", false, function(s) Lighting.FogEnd = s and 1e10 or OrigFog end)
MakeSection(vp, "CAMERA")
MakeSlider(vp, "FOV", 50, 120, 70, function(v) Camera.FieldOfView = v end)

-- COMBATE
local cp = GetPage("COMBATE")
MakeSection(cp, "HITBOX")
MakeSlider(cp, "HitboxSize", 1, 50, 10, function(v) Config.Hitbox = v end)
MakeToggle(cp, "Hitbox Expandido", false, function(s)
    local c = LocalPlayer.Character; local hrp = c and c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    if s then hrp.Size = Vector3.new(Config.Hitbox, Config.Hitbox, Config.Hitbox); hrp.Transparency = 0.5; hrp.CanCollide = false
    else hrp.Size = Vector3.new(2, 2, 1); hrp.Transparency = 1; hrp.CanCollide = true end
end)
MakeSection(cp, "KNOCKBACK")
MakeToggle(cp, "No Knockback", false, function(s)
    local c = LocalPlayer.Character; local hrp = c and c:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CustomPhysicalProperties = s and PhysicalProperties.new(0.01,0.01,0.01,1,1) or nil end
end)

-- TELEPORT
local tp = GetPage("TELEPORT")
MakeSection(tp, "TP TOOL")
MakeButton(tp, "🔧 Dar TP Tool", function()
    local bp = LocalPlayer:FindFirstChild("Backpack"); if not bp then return end
    local tool = Instance.new("Tool"); tool.Name = "TPTool"; tool.RequiresHandle = false
    tool.Activated:Connect(function()
        local c = LocalPlayer.Character; local hrp = c and c:FindFirstChild("HumanoidRootPart")
        if hrp then local m = LocalPlayer:GetMouse(); if m.Target then hrp.CFrame = CFrame.new(m.Hit.Position + Vector3.new(0,3,0)) end end
    end)
    tool.Parent = bp
end)
MakeSection(tp, "TP JOGADORES")
local tpF = Instance.new("ScrollingFrame")
tpF.Size = UDim2.new(1, 0, 0, math.floor(150*scale)); tpF.BackgroundColor3 = Color3.fromRGB(20, 20, 30); tpF.Parent = tp
Instance.new("UICorner", tpF).CornerRadius = UDim.new(0, 7)
local tpL = Instance.new("UIListLayout"); tpL.Parent = tpF
local function RefreshP()
    for _, c in ipairs(tpF:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local b = Instance.new("TextButton"); b.Size = UDim2.new(1, -8, 0, math.floor(30*scale)); b.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            b.Text = "👤 " .. plr.Name; b.TextColor3 = Color3.fromRGB(255,255,255); b.TextXAlignment = Enum.TextXAlignment.Left; b.Parent = tpF
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
            b.MouseButton1Click:Connect(function()
                local tC = plr.Character; local mHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if tC and mHRP then local tH = tC:FindFirstChild("HumanoidRootPart"); if tH then mHRP.CFrame = tH.CFrame + Vector3.new(3,0,0) end end
            end)
        end
    end
    tpF.CanvasSize = UDim2.new(0, 0, 0, tpL.AbsoluteContentSize.Y + 5)
end
RefreshP(); Players.PlayerAdded:Connect(RefreshP); Players.PlayerRemoving:Connect(function() task.wait(1) RefreshP() end)
MakeButton(tp, "🔄 Atualizar Lista", RefreshP)

-- UTIL
local up = GetPage("UTIL")
MakeSection(up, "INFO")
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, 0, 0, math.floor(40*scale)); info.BackgroundColor3 = Color3.fromRGB(20, 20, 30); info.Text = "By Kakamikaze • Universal Hub\nID: " .. game.PlaceId
info.TextColor3 = Color3.fromRGB(180, 180, 200); info.TextSize = math.floor(11*scale); info.TextWrapped = true; info.Parent = up
Instance.new("UICorner", info).CornerRadius = UDim.new(0, 7)
MakeSection(up, "RESPAWN")
MakeButton(up, "💀 Resetar Personagem", function() local c = LocalPlayer.Character; if c and c:FindFirstChild("Humanoid") then c.Humanoid.Health = 0 end end)

-- LOOPS
RunService.RenderStepped:Connect(function()
    if not Config.Fly then return end
    local c = LocalPlayer.Character; if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart"); local bv = hrp and hrp:FindFirstChild("KBV"); if not (hrp and bv) then return end
    local mv = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then mv += Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then mv -= Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then mv -= Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then mv += Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then mv += Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then mv -= Vector3.new(0,1,0) end
    bv.Velocity = mv.Magnitude > 0 and mv.Unit * Config.FlySpeed or Vector3.zero
    hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Camera.CFrame.LookVector)
end)

RunService.Stepped:Connect(function()
    if not Config.Noclip then return end
    local c = LocalPlayer.Character; if not c then return end
    for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
end)

UserInputService.JumpRequest:Connect(function()
    if Config.InfJump then local c = LocalPlayer.Character; local h = c and c:FindFirstChild("Humanoid"); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end
end)

print("[KakaHub] ✅ By Kakamikaze")
