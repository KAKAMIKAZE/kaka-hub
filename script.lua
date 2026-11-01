-- By Kakamikaze | Rayfield Hub | Versão corrigida e unificada
-- AVISO: Uso apenas educacional.

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- CONFIGURAÇÕES
-- ==========================================
local Config = {
    Aimbot = false,
    FOVSize = 150,
    Smoothness = 0.25,
    TeamCheck = false,
    WallCheck = false,
    SpeedValue = 16,
    SpeedEnabled = false,
    InfJump = false,
    Noclip = false,
    HitboxEnabled = false,
    HitboxSize = 10,
    FlyEnabled = false,
    FlySpeed = 50,
    XrayEnabled = false,
    ESPEnabled = false,
    AntiLagEnabled = false,
    Fullbright = false,
    AntiAFK = false,
}

-- ==========================================
-- FOV CIRCLE
-- ==========================================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Radius = Config.FOVSize
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Transparency = 0.8
FOVCircle.Filled = false

-- ==========================================
-- JANELA RAYFIELD
-- ==========================================
local Window = Rayfield:CreateWindow({
    Name = "Kakamikaze",
    LoadingTitle = "By Kakamikaze",
    LoadingSubtitle = "Carregando...",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false,
})

-- ==========================================
-- ABA COMBAT
-- ==========================================
local CombatTab = Window:CreateTab("Combat", 4483362458)

CombatTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(state) Config.Aimbot = state end,
})

CombatTab:CreateSlider({
    Name = "FOV Size",
    Range = {50, 500},
    Increment = 5,
    Suffix = "px",
    CurrentValue = 150,
    Flag = "FOVSlider",
    Callback = function(value)
        Config.FOVSize = value
        FOVCircle.Radius = value
    end,
})

CombatTab:CreateSlider({
    Name = "Aimbot Smoothness (Menor = Mais Grudado)",
    Range = {0.05, 1},
    Increment = 0.05,
    Suffix = "",
    CurrentValue = 0.25,
    Flag = "SmoothSlider",
    Callback = function(value) Config.Smoothness = value end,
})

CombatTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Flag = "TeamCheck",
    Callback = function(state) Config.TeamCheck = state end,
})

CombatTab:CreateToggle({
    Name = "Wall Check",
    CurrentValue = false,
    Flag = "WallCheck",
    Callback = function(state) Config.WallCheck = state end,
})

-- Hitbox Expander
local function applyHitbox()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                if Config.HitboxEnabled then
                    hrp.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                    hrp.Transparency = 0.5
                    hrp.Color = Color3.fromRGB(255, 0, 0)
                else
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                    hrp.Color = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end
end

CombatTab:CreateToggle({
    Name = "Hitbox Expander",
    CurrentValue = false,
    Flag = "HitboxToggle",
    Callback = function(state)
        Config.HitboxEnabled = state
        applyHitbox()
    end,
})

CombatTab:CreateSlider({
    Name = "Hitbox Size",
    Range = {5, 30},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 10,
    Flag = "HitboxSlider",
    Callback = function(value)
        Config.HitboxSize = value
        if Config.HitboxEnabled then applyHitbox() end
    end,
})

-- ==========================================
-- ABA MOVIMENTO
-- ==========================================
local MoveTab = Window:CreateTab("Movimento", 4483362458)

MoveTab:CreateSlider({
    Name = "Speed",
    Range = {1, 300},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 16,
    Flag = "SpeedSlider",
    Callback = function(value)
        Config.SpeedValue = value
        if Config.SpeedEnabled and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = value end
        end
    end,
})

MoveTab:CreateToggle({
    Name = "Speed Enabled",
    CurrentValue = false,
    Flag = "SpeedToggle",
    Callback = function(state)
        Config.SpeedEnabled = state
        if LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = state and Config.SpeedValue or 16 end
        end
    end,
})

MoveTab:CreateToggle({
    Name = "Inf Jump",
    CurrentValue = false,
    Flag = "InfJump",
    Callback = function(state) Config.InfJump = state end,
})

MoveTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(state) Config.Noclip = state end,
})

-- Fly
local flyConnection = nil
local flyBodyVelocity = nil

local function stopFly()
    Config.FlyEnabled = false
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end

local function startFly()
    Config.FlyEnabled = true
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    hum.PlatformStand = true
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = hrp

    flyConnection = RunService.RenderStepped:Connect(function()
        if not Config.FlyEnabled or not flyBodyVelocity then return end
        local cam = Workspace.CurrentCamera
        local moveDir = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
        if moveDir.Magnitude > 0 then
            flyBodyVelocity.Velocity = moveDir.Unit * Config.FlySpeed
        else
            flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

MoveTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(state)
        if state then startFly() else stopFly() end
    end,
})

MoveTab:CreateSlider({
    Name = "Fly Speed",
    Range = {50, 500},
    Increment = 10,
    Suffix = " studs",
    CurrentValue = 50,
    Flag = "FlySpeedSlider",
    Callback = function(value) Config.FlySpeed = value end,
})

-- ==========================================
-- ABA VISUAL (Xray, ESP, Anti-Lag)
-- ==========================================
local VisualTab = Window:CreateTab("Visual", 4483362458)

-- Xray
local originalTransparency = {}

VisualTab:CreateToggle({
    Name = "Xray (Ver através de paredes)",
    CurrentValue = false,
    Flag = "XrayToggle",
    Callback = function(state)
        Config.XrayEnabled = state
        if state then
            for _, part in pairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") and not part:IsDescendantOf(LocalPlayer.Character) then
                    if not originalTransparency[part] then
                        originalTransparency[part] = part.Transparency
                    end
                    part.Transparency = 0.5
                end
            end
        else
            for part, trans in pairs(originalTransparency) do
                if part and part.Parent then
                    part.Transparency = trans
                end
            end
            originalTransparency = {}
        end
    end,
})

-- ESP
local ESPHighlights = {}

local function toggleESP(state)
    Config.ESPEnabled = state
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hl = Instance.new("Highlight")
                hl.Adornee = player.Character
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.5
                hl.Parent = player.Character
                ESPHighlights[player] = hl
            end
        end
    else
        for _, hl in pairs(ESPHighlights) do
            if hl then hl:Destroy() end
        end
        ESPHighlights = {}
    end
end

VisualTab:CreateToggle({
    Name = "ESP Jogadores",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(state) toggleESP(state) end,
})

-- Anti-Lag (Remove Effects)
local removedEffects = {}

VisualTab:CreateToggle({
    Name = "Anti-Lag (Remove Partículas)",
    CurrentValue = false,
    Flag = "AntiLagToggle",
    Callback = function(state)
        Config.AntiLagEnabled = state
        if state then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
                    if obj.Enabled then
                        obj.Enabled = false
                        table.insert(removedEffects, obj)
                    end
                end
            end
        else
            for _, obj in pairs(removedEffects) do
                if obj and obj.Parent then
                    obj.Enabled = true
                end
            end
            removedEffects = {}
        end
    end,
})

-- Fullbright
VisualTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Flag = "Fullbright",
    Callback = function(state)
        Config.Fullbright = state
        local lighting = game:GetService("Lighting")
        if state then
            lighting.Ambient = Color3.fromRGB(255, 255, 255)
            lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            lighting.Brightness = 2
        else
            lighting.Ambient = Color3.fromRGB(0, 0, 0)
            lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            lighting.Brightness = 1
        end
    end,
})

-- ==========================================
-- ABA UTILITY
-- ==========================================
local UtilityTab = Window:CreateTab("Utility", 4483362458)

-- TP Jogadores
local playerList = {}
local selectedPlayer = nil

local function refreshPlayerList()
    playerList = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(playerList, p.Name)
        end
    end
end
refreshPlayerList()

local playerDropdown = UtilityTab:CreateDropdown({
    Name = "Selecionar Jogador",
    Options = playerList,
    CurrentOption = {},
    MultipleOptions = false,
    Flag = "PlayerSelect",
    Callback = function(option)
        selectedPlayer = option[1]
    end,
})

UtilityTab:CreateButton({
    Name = "Atualizar Lista",
    Callback = function()
        refreshPlayerList()
        playerDropdown:Refresh(playerList)
    end,
})

UtilityTab:CreateButton({
    Name = "TP para Jogador",
    Callback = function()
        if not selectedPlayer then return end
        local target = Players:FindFirstChild(selectedPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(2, 0, 2)
            end
        end
    end,
})

UtilityTab:CreateButton({
    Name = "Fling Jogador",
    Callback = function()
        if not selectedPlayer then return end
        local target = Players:FindFirstChild(selectedPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = target.Character.HumanoidRootPart
            local bv = Instance.new("BodyVelocity")
            bv.Velocity = Vector3.new(0, 5000, 0)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.P = 100000
            bv.Parent = hrp
            game:GetService("Debris"):AddItem(bv, 0.3)
        end
    end,
})

UtilityTab:CreateToggle({
    Name = "Instant Interact",
    CurrentValue = false,
    Flag = "InstantInteract",
    Callback = function(state) Config.InstantInteract = state end,
})

UtilityTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(state) Config.AntiAFK = state end,
})

UtilityTab:CreateButton({
    Name = "TP Tool (Mouse)",
    Callback = function()
        local mouse = LocalPlayer:GetMouse()
        local tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "TP Tool"
        tool.Activated:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
            end
        end)
        tool.Parent = LocalPlayer.Backpack
    end,
})

UtilityTab:CreateButton({
    Name = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end,
})

UtilityTab:CreateButton({
    Name = "Reset",
    Callback = function()
        if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
    end,
})

UtilityTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local HttpService = game:GetService("HttpService")
        local success, response = pcall(function()
            return game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        end)
        if success then
            local data = HttpService:JSONDecode(response)
            for _, server in pairs(data.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                    return
                end
            end
        end
    end,
})

-- ==========================================
-- ABA SCRIPTS
-- ==========================================
local ScriptsTab = Window:CreateTab("Scripts", 4483362458)

ScriptsTab:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end,
})

ScriptsTab:CreateButton({
    Name = "Simple Spy",
    Callback = function()
        loadstring(game:HttpGet("https://github.com/exxtremestuffs/SimpleSpySource/raw/master/SimpleSpy.lua"))()
    end,
})

ScriptsTab:CreateButton({
    Name = "Dark Dex (Explorer)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/BACONHUB1/Dark-Dex/main/DarkDex.lua"))()
    end,
})

ScriptsTab:CreateButton({
    Name = "Fly GUI V3 (Mobile)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
    end,
})

-- ==========================================
-- LÓGICA DO AIMBOT
-- ==========================================
RunService.RenderStepped:Connect(function()
    if Config.Aimbot then
        FOVCircle.Visible = true
        FOVCircle.Radius = Config.FOVSize
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    else
        FOVCircle.Visible = false
    end

    if not Config.Aimbot then return end

    local closestDist = Config.FOVSize
    local bestTarget = nil

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local head = char:FindFirstChild("Head")
            local hum = char:FindFirstChildOfClass("Humanoid")

            if head and hum and hum.Health > 0 then
                if Config.TeamCheck and player.Team == LocalPlayer.Team then continue end
                if Config.WallCheck then
                    local rayParams = RaycastParams.new()
                    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
                    rayParams.FilterType = Enum.RaycastFilterType.Exclude
                    local rayResult = Workspace:Raycast(Camera.CFrame.Position, head.Position - Camera.CFrame.Position, rayParams)
                    if rayResult and rayResult.Instance:IsDescendantOf(char) == false then continue end
                end

                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        bestTarget = head
                    end
                end
            end
        end
    end

    if bestTarget then
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, bestTarget.Position), Config.Smoothness)
    end
end)

-- ==========================================
-- OUTRAS FUNÇÕES
-- ==========================================

-- Inf Jump
UserInputService.JumpRequest:Connect(function()
    if Config.InfJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Noclip
RunService.Stepped:Connect(function()
    if Config.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Instant Interact
game:GetService("ProximityPromptService").PromptShown:Connect(function(prompt)
    if Config.InstantInteract then
        prompt.HoldDuration = 0
    end
end)

-- Anti-AFK
task.spawn(function()
    while task.wait(60) do
        if Config.AntiAFK and LocalPlayer then
            local vu = game:GetService("VirtualUser")
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end
    end
end)

-- Speed Loop
task.spawn(function()
    while task.wait(0.1) do
        if Config.SpeedEnabled and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed ~= Config.SpeedValue then
                hum.WalkSpeed = Config.SpeedValue
            end
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    if Config.SpeedEnabled then
        hum.WalkSpeed = Config.SpeedValue
    end
end)

print("Kakamikaze Hub carregado com sucesso.")
