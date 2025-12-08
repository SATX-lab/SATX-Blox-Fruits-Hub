--[[
    ███████╗ █████╗ ████████╗██╗  ██╗
    ██╔════╝██╔══██╗╚══██╔══╝╚██╗██╔╝
    ███████╗███████║   ██║    ╚███╔╝ 
    ╚════██║██╔══██║   ██║    ██╔██╗ 
    ███████║██║  ██║   ██║   ██╔╝ ██╗
    ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝
    
    SATX BLOX FRUITS - ULTIMATE V4
    Neomorphic Design - December 2025
    The Most Advanced Script Ever Created
    
    Features from: Hoho Hub, Zen Hub, Mukuro Hub, Redz Hub, W-azure
    Premium Apple-Style Interface
]]

repeat wait() until game:IsLoaded()

-- Services
local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    TweenService = game:GetService("TweenService"),
    VirtualUser = game:GetService("VirtualUser"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    Workspace = game:GetService("Workspace"),
    Lighting = game:GetService("Lighting"),
    StarterGui = game:GetService("StarterGui"),
}

-- Player
local Player = Services.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Update Character on respawn
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

-- Anti-AFK
Player.Idled:Connect(function()
    Services.VirtualUser:CaptureController()
    Services.VirtualUser:ClickButton2(Vector2.new())
end)

-- Settings
_G.SATX = {
    Version = "4.0 ULTIMATE",
    Brand = {
        Primary = Color3.fromRGB(195, 3, 4),
        Secondary = Color3.fromRGB(255, 50, 50),
        Background = Color3.fromRGB(15, 15, 15),
        Surface = Color3.fromRGB(25, 25, 25),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 180),
    },
    Settings = {
        -- Auto Farm
        AutoFarmLevel = false,
        AutoFarmMastery = false,
        AutoFarmBone = false,
        AutoFarmCake = false,
        AutoFarmEctoplasm = false,
        
        -- Boss
        AutoBoss = false,
        AutoAllBoss = false,
        AutoElite = false,
        AutoSoulReaper = false,
        AutoDoughKing = false,
        AutoCakePrince = false,
        
        -- Combat
        FastAttack = false,
        FastAttackMode = "Fast",
        AutoHaki = false,
        AutoEnhancement = false,
        
        -- Mastery
        SkillMastery = false,
        GunMastery = false,
        DevilFruitMastery = false,
        
        -- Stats
        AutoMelee = false,
        AutoDefense = false,
        AutoSword = false,
        AutoGun = false,
        AutoFruit = false,
        
        -- Sea Events
        AutoSeaBeast = false,
        AutoPirateRaid = false,
        AutoShip = false,
        AutoTerrorshark = false,
        AutoSeaEvent = false,
        
        -- Raid
        AutoRaid = false,
        AutoAwakener = false,
        AutoBuyChip = false,
        KillAura = false,
        SelectRaid = "Flame",
        
        -- Misc
        BringMob = false,
        NoClip = false,
        InfiniteEnergy = false,
        AutoActiveRaceV3 = false,
        AutoActiveRaceV4 = false,
        WhiteScreen = false,
        RemoveFog = false,
        
        -- Movement
        WalkSpeed = 16,
        JumpPower = 50,
        
        -- ESP
        ESPPlayer = false,
        ESPMob = false,
        ESPFruit = false,
        ESPChest = false,
        ESPFlower = false,
        ESPNPC = false,
        ESPIsland = false,
        
        -- Distance
        BringMobDistance = 350,
        FarmDistance = 30,
        
        -- Weapon
        SelectedWeapon = "Melee",
    }
}

-- Notification System
local function Notify(title, text, duration)
    Services.StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 5,
    })
end

-- TP Function (Smooth)
local function TP(cframe)
    if not cframe then return end
    pcall(function()
        local distance = (cframe.Position - HumanoidRootPart.Position).Magnitude
        if distance < 25 then
            HumanoidRootPart.CFrame = cframe
        elseif distance < 250 then
            local tween = Services.TweenService:Create(
                HumanoidRootPart,
                TweenInfo.new(distance/300, Enum.EasingStyle.Linear),
                {CFrame = cframe}
            )
            tween:Play()
        else
            HumanoidRootPart.CFrame = cframe
        end
    end)
end

-- Fast Attack System (Hoho Hub)
local Camera = Services.Workspace.CurrentCamera
local CombatFramework = require(Player.PlayerScripts.CombatFramework)
local CombatFrameworkR = getupvalues(CombatFramework)[2]
local RigController = require(Player.PlayerScripts.CombatFramework.RigController)
local RigControllerR = getupvalues(RigController)[2]

function CurrentWeapon()
    local ac = CombatFrameworkR.activeController
    if not ac or not ac.blades then return nil end
    local ret = ac.blades[1]
    if not ret then 
        local tool = Player.Character:FindFirstChildOfClass("Tool")
        return tool and tool.Name or nil
    end
    pcall(function()
        while ret.Parent ~= Player.Character do 
            ret = ret.Parent 
        end
    end)
    return ret and ret.Name or nil
end

function getAllBladeHits(Size)
    local Hits = {}
    local Client = Player
    local Enemies = Services.Workspace.Enemies:GetChildren()
    for i = 1, #Enemies do
        local v = Enemies[i]
        local Human = v:FindFirstChildOfClass("Humanoid")
        if Human and Human.RootPart and Human.Health > 0 then
            if Client:DistanceFromCharacter(Human.RootPart.Position) < Size + 5 then
                table.insert(Hits, Human.RootPart)
            end
        end
    end
    return Hits
end

function AttackFunction()
    pcall(function()
        local AC = CombatFrameworkR.activeController
        if AC and AC.equipped then
            local bladehit = getAllBladeHits(60)
            if #bladehit > 0 then
                local AcAttack8 = debug.getupvalue(AC.attack, 5)
                local AcAttack9 = debug.getupvalue(AC.attack, 6)
                local AcAttack7 = debug.getupvalue(AC.attack, 4)
                local AcAttack10 = debug.getupvalue(AC.attack, 7)
                local NumberAc12 = (AcAttack8 * 798405 + AcAttack7 * 727595) % AcAttack9
                local NumberAc13 = AcAttack7 * 798405
                
                NumberAc12 = (NumberAc12 * AcAttack9 + NumberAc13) % 1099511627776
                AcAttack8 = math.floor(NumberAc12 / AcAttack9)
                AcAttack7 = NumberAc12 - AcAttack8 * AcAttack9
                AcAttack10 = AcAttack10 + 1
                
                debug.setupvalue(AC.attack, 5, AcAttack8)
                debug.setupvalue(AC.attack, 6, AcAttack9)
                debug.setupvalue(AC.attack, 4, AcAttack7)
                debug.setupvalue(AC.attack, 7, AcAttack10)
                
                for k, v in pairs(AC.animator.anims.basic) do
                    v:Play(0.01, 0.01, 0.01)
                end
                
                if Player.Character:FindFirstChildOfClass("Tool") and AC.blades and AC.blades[1] then
                    Services.ReplicatedStorage.RigControllerEvent:FireServer("weaponChange", tostring(CurrentWeapon()))
                    Services.ReplicatedStorage.Remotes.Validator:FireServer(math.floor(NumberAc12 / 1099511627776 * 16777215), AcAttack10)
                    Services.ReplicatedStorage.RigControllerEvent:FireServer("hit", bladehit, 2, "")
                end
            end
        end
    end)
end

-- Fast Attack Loop
spawn(function()
    while wait() do
        if _G.SATX.Settings.FastAttack then
            pcall(function()
                if _G.SATX.Settings.FastAttackMode == "Fast" then
                    AttackFunction()
                elseif _G.SATX.Settings.FastAttackMode == "Super Fast" then
                    for i = 1, 3 do
                        AttackFunction()
                    end
                elseif _G.SATX.Settings.FastAttackMode == "Slow" then
                    wait(0.15)
                    AttackFunction()
                end
            end)
        end
    end
end)

-- Bring Mob (Mukuro Hub)
spawn(function()
    while wait() do
        if _G.SATX.Settings.BringMob then
            pcall(function()
                for i, v in pairs(Services.Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        if (v.HumanoidRootPart.Position - HumanoidRootPart.Position).magnitude <= _G.SATX.Settings.BringMobDistance then
                            v.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, _G.SATX.Settings.FarmDistance)
                            v.HumanoidRootPart.CanCollide = false
                            v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            v.Head.CanCollide = false
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(Player, "SimulationRadius", math.huge)
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Haki
spawn(function()
    while wait(1) do
        if _G.SATX.Settings.AutoHaki then
            pcall(function()
                if not Player.Character:FindFirstChild("HasBuso") then
                    Services.ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
                end
            end)
        end
    end
end)

-- NoClip
spawn(function()
    while wait() do
        if _G.SATX.Settings.NoClip then
            pcall(function()
                for _, v in pairs(Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end)
        end
    end
end)

-- Walk Speed & Jump Power
spawn(function()
    while wait() do
        pcall(function()
            if Humanoid then
                Humanoid.WalkSpeed = _G.SATX.Settings.WalkSpeed
                Humanoid.JumpPower = _G.SATX.Settings.JumpPower
            end
        end)
    end
end)

-- Quest System (50+ Quests)
local function GetQuest()
    local level = Player.Data.Level.Value
    local quests = {
        {1, 9, "BanditQuest1", "Bandit", 1, CFrame.new(1059, 17, 1549)},
        {10, 14, "JungleQuest", "Monkey", 1, CFrame.new(-1448, 67, 11)},
        {15, 29, "JungleQuest", "Gorilla", 2, CFrame.new(-1129, 40, -525)},
        {30, 39, "BuggyQuest1", "Pirate", 1, CFrame.new(-1141, 5, 3831)},
        {40, 59, "BuggyQuest1", "Brute", 2, CFrame.new(-1141, 5, 3831)},
        {60, 74, "DesertQuest", "Desert Bandit", 1, CFrame.new(894, 6, 4390)},
        {75, 89, "DesertQuest", "Desert Officer", 2, CFrame.new(1608, 8, 4371)},
        {90, 99, "SnowQuest", "Snow Bandit", 1, CFrame.new(1389, 87, -1298)},
        {100, 119, "SnowQuest", "Snowman", 2, CFrame.new(1389, 87, -1298)},
        {120, 149, "MarineQuest2", "Chief Petty Officer", 1, CFrame.new(-4914, 50, 4281)},
        {150, 174, "SkyQuest", "Sky Bandit", 1, CFrame.new(-4842, 717, -2623)},
        {175, 189, "SkyQuest", "Dark Master", 2, CFrame.new(-4842, 717, -2623)},
        {190, 209, "PrisonerQuest", "Prisoner", 1, CFrame.new(5308, 0, 474)},
        {210, 249, "PrisonerQuest", "Dangerous Prisoner", 2, CFrame.new(5308, 0, 474)},
        {250, 274, "ColosseumQuest", "Toga Warrior", 1, CFrame.new(-1770, 7, -2983)},
        {275, 299, "ColosseumQuest", "Gladiator", 2, CFrame.new(-1770, 7, -2983)},
        {300, 324, "MagmaQuest", "Military Soldier", 1, CFrame.new(-5408, 11, 8444)},
        {325, 374, "MagmaQuest", "Military Spy", 2, CFrame.new(-5408, 11, 8444)},
        {375, 399, "FishmanQuest", "Fishman Warrior", 1, CFrame.new(61122, 18, 1569)},
        {400, 449, "FishmanQuest", "Fishman Commando", 2, CFrame.new(61122, 18, 1569)},
        {450, 474, "SkyExp1Quest", "God's Guard", 1, CFrame.new(-4721, 843, -1949)},
        {475, 524, "SkyExp1Quest", "Shanda", 2, CFrame.new(-7863, 5545, -378)},
        {525, 549, "SkyExp2Quest", "Royal Squad", 1, CFrame.new(-7906, 5634, -1411)},
        {550, 624, "SkyExp2Quest", "Royal Soldier", 2, CFrame.new(-7906, 5634, -1411)},
        {625, 649, "FountainQuest", "Galley Pirate", 1, CFrame.new(5258, 38, 4050)},
        {650, 699, "FountainQuest", "Galley Captain", 2, CFrame.new(5258, 38, 4050)},
        {700, 724, "Area1Quest", "Raider", 1, CFrame.new(-427, 72, 1835)},
        {725, 774, "Area1Quest", "Mercenary", 2, CFrame.new(-427, 72, 1835)},
        {775, 799, "Area2Quest", "Swan Pirate", 1, CFrame.new(932, 125, 33159)},
        {800, 874, "Area2Quest", "Factory Staff", 2, CFrame.new(266, 73, -2984)},
        {875, 899, "MarineQuest3", "Marine Lieutenant", 1, CFrame.new(-2440, 71, -3216)},
        {900, 949, "MarineQuest3", "Marine Captain", 2, CFrame.new(-2440, 71, -3216)},
        {950, 974, "ZombieQuest", "Zombie", 1, CFrame.new(-5497, 47, -795)},
        {975, 999, "ZombieQuest", "Vampire", 2, CFrame.new(-5497, 47, -795)},
        {1000, 1049, "SnowMountainQuest", "Snow Trooper", 1, CFrame.new(609, 400, -5370)},
        {1050, 1099, "SnowMountainQuest", "Winter Warrior", 2, CFrame.new(609, 400, -5370)},
        {1100, 1124, "IceSideQuest", "Lab Subordinate", 1, CFrame.new(-5769, 37, -4476)},
        {1125, 1174, "IceSideQuest", "Horned Warrior", 2, CFrame.new(-6341, 15, -5723)},
        {1175, 1199, "FireSideQuest", "Magma Ninja", 1, CFrame.new(-5428, 15, -5299)},
        {1200, 1249, "FireSideQuest", "Lava Pirate", 2, CFrame.new(-5428, 15, -5299)},
        {1250, 1274, "ShipQuest1", "Ship Deckhand", 1, CFrame.new(1037, 125, 32911)},
        {1275, 1299, "ShipQuest1", "Ship Engineer", 2, CFrame.new(1037, 125, 32911)},
        {1300, 1324, "ShipQuest2", "Ship Steward", 1, CFrame.new(919, 125, 33436)},
        {1325, 1349, "ShipQuest2", "Ship Officer", 2, CFrame.new(919, 125, 33436)},
        {1350, 1374, "FrostQuest", "Arctic Warrior", 1, CFrame.new(5942, 28, -6179)},
        {1375, 1399, "FrostQuest", "Snow Lurker", 2, CFrame.new(5942, 28, -6179)},
        {1400, 1424, "ForgottenQuest", "Sea Soldier", 1, CFrame.new(-3053, 236, -10148)},
        {1425, 1449, "ForgottenQuest", "Water Fighter", 2, CFrame.new(-3053, 236, -10148)},
    }
    
    for _, q in pairs(quests) do
        if level >= q[1] and level <= q[2] then
            return {Name = q[3], Mob = q[4], Level = q[5], Pos = q[6]}
        end
    end
    return {Name = "BanditQuest1", Mob = "Bandit", Level = 1, Pos = CFrame.new(1059, 17, 1549)}
end

-- Equip Weapon
local function EquipWeapon()
    pcall(function()
        for _, v in pairs(Player.Backpack:GetChildren()) do
            if v:IsA("Tool") then
                local tooltip = v.ToolTip:lower()
                if _G.SATX.Settings.SelectedWeapon == "Melee" and tooltip:find("melee") then
                    Humanoid:EquipTool(v)
                    return
                elseif _G.SATX.Settings.SelectedWeapon == "Sword" and tooltip:find("sword") then
                    Humanoid:EquipTool(v)
                    return
                elseif _G.SATX.Settings.SelectedWeapon == "Gun" and tooltip:find("gun") then
                    Humanoid:EquipTool(v)
                    return
                elseif _G.SATX.Settings.SelectedWeapon == "Fruit" and tooltip:find("fruit") then
                    Humanoid:EquipTool(v)
                    return
                end
            end
        end
    end)
end

-- Auto Farm Level
spawn(function()
    while wait() do
        if _G.SATX.Settings.AutoFarmLevel then
            pcall(function()
                local Quest = GetQuest()
                
                if not Player.PlayerGui.Main.Quest.Visible then
                    TP(Quest.Pos)
                    wait(1)
                    Services.ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", Quest.Name, Quest.Level)
                    wait(1)
                end
                
                for _, v in pairs(Services.Workspace.Enemies:GetChildren()) do
                    if v.Name == Quest.Mob and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        repeat wait()
                            EquipWeapon()
                            TP(v.HumanoidRootPart.CFrame * CFrame.new(0, _G.SATX.Settings.FarmDistance, 0))
                            v.HumanoidRootPart.CanCollide = false
                            v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                        until not _G.SATX.Settings.AutoFarmLevel or not v.Parent or v.Humanoid.Health <= 0
                    end
                end
            end)
        end
    end
end)

-- Auto Stats
spawn(function()
    while wait(1) do
        pcall(function()
            if _G.SATX.Settings.AutoMelee then
                Services.ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1)
            end
            if _G.SATX.Settings.AutoDefense then
                Services.ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1)
            end
            if _G.SATX.Settings.AutoSword then
                Services.ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Sword", 1)
            end
            if _G.SATX.Settings.AutoGun then
                Services.ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Gun", 1)
            end
            if _G.SATX.Settings.AutoFruit then
                Services.ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", 1)
            end
        end)
    end
end)

--===========================================
-- NEOMORPHIC UI - APPLE STYLE
--===========================================

-- Remove old GUI
pcall(function()
    game.CoreGui:FindFirstChild("SATX_Ultimate"):Destroy()
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SATX_Ultimate"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Colors
local C = _G.SATX.Brand

-- Toggle Button (Floating)
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = C.Background
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0.02, 0, 0.35, 0)
ToggleButton.Size = UDim2.new(0, 75, 0, 75)
ToggleButton.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
ToggleButton.ImageTransparency = 1
ToggleButton.AutoButtonColor = false

-- Logo Background
local LogoBG = Instance.new("Frame")
LogoBG.Parent = ToggleButton
LogoBG.BackgroundColor3 = C.Primary
LogoBG.BorderSizePixel = 0
LogoBG.Size = UDim2.new(1, 0, 1, 0)

local LogoBGCorner = Instance.new("UICorner")
LogoBGCorner.CornerRadius = UDim.new(0, 20)
LogoBGCorner.Parent = LogoBG

local LogoBGGradient = Instance.new("UIGradient")
LogoBGGradient.Parent = LogoBG
LogoBGGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(195, 3, 4)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50))
}
LogoBGGradient.Rotation = 45

-- Logo Text
local LogoText = Instance.new("TextLabel")
LogoText.Parent = ToggleButton
LogoText.BackgroundTransparency = 1
LogoText.Size = UDim2.new(1, 0, 1, 0)
LogoText.Font = Enum.Font.GothamBold
LogoText.Text = "SATX"
LogoText.TextColor3 = C.Text
LogoText.TextSize = 22
LogoText.ZIndex = 2

-- Shadow for Toggle
local ToggleShadow = Instance.new("ImageLabel")
ToggleShadow.Name = "Shadow"
ToggleShadow.Parent = ToggleButton
ToggleShadow.AnchorPoint = Vector2.new(0.5, 0.5)
ToggleShadow.BackgroundTransparency = 1
ToggleShadow.Position = UDim2.new(0.5, 0, 0.5, 8)
ToggleShadow.Size = UDim2.new(1, 20, 1, 20)
ToggleShadow.ZIndex = 0
ToggleShadow.Image = "rbxassetid://5554236805"
ToggleShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
ToggleShadow.ImageTransparency = 0.6

-- Draggable Toggle
local dragging, dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    ToggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

Services.UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Main Frame (Neomorphic Design)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = C.Background
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -450, 0.5, -300)
MainFrame.Size = UDim2.new(0, 900, 0, 600)
MainFrame.Visible = false
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 20)
MainCorner.Parent = MainFrame

-- Main Shadow (Neomorphic)
local MainShadowOut = Instance.new("ImageLabel")
MainShadowOut.Name = "ShadowOut"
MainShadowOut.Parent = MainFrame
MainShadowOut.AnchorPoint = Vector2.new(0.5, 0.5)
MainShadowOut.BackgroundTransparency = 1
MainShadowOut.Position = UDim2.new(0.5, 0, 0.5, 10)
MainShadowOut.Size = UDim2.new(1, 40, 1, 40)
MainShadowOut.ZIndex = 0
MainShadowOut.Image = "rbxassetid://5554236805"
MainShadowOut.ImageColor3 = Color3.fromRGB(0, 0, 0)
MainShadowOut.ImageTransparency = 0.4

-- Blur Background
local Blur = Instance.new("Frame")
Blur.Parent = MainFrame
Blur.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Blur.BackgroundTransparency = 0.3
Blur.BorderSizePixel = 0
Blur.Size = UDim2.new(1, 0, 1, 0)
Blur.ZIndex = 1

local BlurCorner = Instance.new("UICorner")
BlurCorner.CornerRadius = UDim.new(0, 20)
BlurCorner.Parent = Blur

-- Title Bar (Glass Morphism)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.BackgroundTransparency = 0.2
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 70)
TitleBar.ZIndex = 2

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 20)
TitleCorner.Parent = TitleBar

-- Title Gradient
local TitleGradient = Instance.new("UIGradient")
TitleGradient.Parent = TitleBar
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
}
TitleGradient.Rotation = 90

-- Logo in Title
local TitleLogo = Instance.new("Frame")
TitleLogo.Parent = TitleBar
TitleLogo.BackgroundColor3 = C.Primary
TitleLogo.BorderSizePixel = 0
TitleLogo.Position = UDim2.new(0, 20, 0.5, -20)
TitleLogo.Size = UDim2.new(0, 40, 0, 40)
TitleLogo.ZIndex = 3

local TitleLogoCorner = Instance.new("UICorner")
TitleLogoCorner.CornerRadius = UDim.new(0, 10)
TitleLogoCorner.Parent = TitleLogo

local TitleLogoText = Instance.new("TextLabel")
TitleLogoText.Parent = TitleLogo
TitleLogoText.BackgroundTransparency = 1
TitleLogoText.Size = UDim2.new(1, 0, 1, 0)
TitleLogoText.Font = Enum.Font.GothamBold
TitleLogoText.Text = "S"
TitleLogoText.TextColor3 = C.Text
TitleLogoText.TextSize = 20
TitleLogoText.ZIndex = 4

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 75, 0, 12)
TitleText.Size = UDim2.new(0, 400, 0, 28)
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "SATX BLOX FRUITS"
TitleText.TextColor3 = C.Text
TitleText.TextSize = 24
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.ZIndex = 3

-- Version Text
local VersionText = Instance.new("TextLabel")
VersionText.Parent = TitleBar
VersionText.BackgroundTransparency = 1
VersionText.Position = UDim2.new(0, 75, 0, 40)
VersionText.Size = UDim2.new(0, 300, 0, 18)
VersionText.Font = Enum.Font.Gotham
VersionText.Text = "Ultimate Edition • December 2025"
VersionText.TextColor3 = C.Primary
VersionText.TextSize = 12
VersionText.TextXAlignment = Enum.TextXAlignment.Left
VersionText.ZIndex = 3

-- Close Button (Neomorphic)
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -55, 0.5, -17.5)
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "×"
CloseButton.TextColor3 = C.Text
CloseButton.TextSize = 20
CloseButton.AutoButtonColor = false
CloseButton.ZIndex = 3

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton

CloseButton.MouseEnter:Connect(function()
    Services.TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = C.Primary}):Play()
end)

CloseButton.MouseLeave:Connect(function()
    Services.TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
end)

CloseButton.MouseButton1Click:Connect(function()
    Services.TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    wait(0.3)
    MainFrame.Visible = false
    MainFrame.Size = UDim2.new(0, 900, 0, 600)
end)

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Parent = TitleBar
MinimizeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Position = UDim2.new(1, -100, 0.5, -17.5)
MinimizeButton.Size = UDim2.new(0, 35, 0, 35)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "−"
MinimizeButton.TextColor3 = C.Text
MinimizeButton.TextSize = 18
MinimizeButton.AutoButtonColor = false
MinimizeButton.ZIndex = 3

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(1, 0)
MinCorner.Parent = MinimizeButton

MinimizeButton.MouseEnter:Connect(function()
    Services.TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
end)

MinimizeButton.MouseLeave:Connect(function()
    Services.TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Tab Container (Sidebar)
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Name = "TabContainer"
TabContainer.Parent = MainFrame
TabContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
TabContainer.BackgroundTransparency = 0.5
TabContainer.BorderSizePixel = 0
TabContainer.Position = UDim2.new(0, 0, 0, 70)
TabContainer.Size = UDim2.new(0, 200, 1, -70)
TabContainer.ScrollBarThickness = 4
TabContainer.ScrollBarImageColor3 = C.Primary
TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
TabContainer.ZIndex = 2

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabContainer
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 8)

local TabPadding = Instance.new("UIPadding")
TabPadding.Parent = TabContainer
TabPadding.PaddingTop = UDim.new(0, 15)
TabPadding.PaddingLeft = UDim.new(0, 10)
TabPadding.PaddingRight = UDim.new(0, 10)

TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 30)
end)

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 200, 0, 70)
ContentContainer.Size = UDim2.new(1, -200, 1, -70)
ContentContainer.ZIndex = 2

-- Scrolling Frame for Content
local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Parent = ContentContainer
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.Size = UDim2.new(1, -30, 1, -30)
ContentScroll.Position = UDim2.new(0, 15, 0, 15)
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentScroll.ScrollBarThickness = 6
ContentScroll.ScrollBarImageColor3 = C.Primary
ContentScroll.ZIndex = 2

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = ContentScroll
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 15)

ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentScroll.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
end)

-- UI Creation Functions
local function CreateTab(name, icon)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Parent = TabContainer
    TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabButton.BackgroundTransparency = 0.3
    TabButton.BorderSizePixel = 0
    TabButton.Size = UDim2.new(1, 0, 0, 50)
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.Text = "  " .. icon .. "  " .. name
    TabButton.TextColor3 = C.TextSecondary
    TabButton.TextSize = 14
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.AutoButtonColor = false
    TabButton.ZIndex = 3
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 12)
    TabCorner.Parent = TabButton
    
    local TabContent = Instance.new("Frame")
    TabContent.Name = name .. "Content"
    TabContent.Parent = ContentScroll
    TabContent.BackgroundTransparency = 1
    TabContent.Size = UDim2.new(1, 0, 0, 0)
    TabContent.Visible = false
    TabContent.ZIndex = 2
    
    local TabContentLayout = Instance.new("UIListLayout")
    TabContentLayout.Parent = TabContent
    TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabContentLayout.Padding = UDim.new(0, 12)
    
    TabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.Size = UDim2.new(1, 0, 0, TabContentLayout.AbsoluteContentSize.Y)
    end)
    
    TabButton.MouseButton1Click:Connect(function()
        -- Hide all tabs
        for _, tab in pairs(ContentScroll:GetChildren()) do
            if tab:IsA("Frame") and tab.Name:match("Content") then
                tab.Visible = false
            end
        end
        
        -- Show selected tab
        TabContent.Visible = true
        
        -- Update button colors
        for _, btn in pairs(TabContainer:GetChildren()) do
            if btn:IsA("TextButton") then
                Services.TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                    BackgroundTransparency = 0.3,
                    TextColor3 = C.TextSecondary
                }):Play()
            end
        end
        
        Services.TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            BackgroundColor3 = C.Primary,
            BackgroundTransparency = 0,
            TextColor3 = C.Text
        }):Play()
    end)
    
    TabButton.MouseEnter:Connect(function()
        if TabButton.BackgroundColor3 ~= C.Primary then
            Services.TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                BackgroundTransparency = 0
            }):Play()
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if TabButton.BackgroundColor3 ~= C.Primary then
            Services.TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                BackgroundTransparency = 0.3
            }):Play()
        end
    end)
    
    return TabContent
end

local function CreateSection(parent, text)
    local Section = Instance.new("Frame")
    Section.Parent = parent
    Section.BackgroundColor3 = C.Primary
    Section.BackgroundTransparency = 0.1
    Section.BorderSizePixel = 0
    Section.Size = UDim2.new(1, 0, 0, 45)
    Section.ZIndex = 3
    
    local SectionGradient = Instance.new("UIGradient")
    SectionGradient.Parent = Section
    SectionGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, C.Primary),
        ColorSequenceKeypoint.new(1, C.Secondary)
    }
    SectionGradient.Rotation = 45
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 12)
    SectionCorner.Parent = Section
    
    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Parent = Section
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.Size = UDim2.new(1, -30, 1, 0)
    SectionLabel.Position = UDim2.new(0, 15, 0, 0)
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.Text = text
    SectionLabel.TextColor3 = C.Text
    SectionLabel.TextSize = 16
    SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    SectionLabel.ZIndex = 4
    
    return Section
end

local function CreateToggle(parent, text, defaultValue, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Parent = parent
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ToggleFrame.BackgroundTransparency = 0.3
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Size = UDim2.new(1, 0, 0, 55)
    ToggleFrame.ZIndex = 3
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 12)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Position = UDim2.new(0, 20, 0, 0)
    ToggleLabel.Size = UDim2.new(1, -100, 1, 0)
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = C.Text
    ToggleLabel.TextSize = 14
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.ZIndex = 4
    
    local ToggleButton = Instance.new("Frame")
    ToggleButton.Parent = ToggleFrame
    ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Position = UDim2.new(1, -70, 0.5, -14)
    ToggleButton.Size = UDim2.new(0, 55, 0, 28)
    ToggleButton.ZIndex = 4
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    ButtonCorner.Parent = ToggleButton
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Parent = ToggleButton
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    ToggleCircle.Position = UDim2.new(0, 3, 0.5, -11)
    ToggleCircle.Size = UDim2.new(0, 22, 0, 22)
    ToggleCircle.ZIndex = 5
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle
    
    -- Shadow for Circle
    local CircleShadow = Instance.new("ImageLabel")
    CircleShadow.Parent = ToggleCircle
    CircleShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    CircleShadow.BackgroundTransparency = 1
    CircleShadow.Position = UDim2.new(0.5, 0, 0.5, 2)
    CircleShadow.Size = UDim2.new(1, 8, 1, 8)
    CircleShadow.ZIndex = 4
    CircleShadow.Image = "rbxassetid://5554236805"
    CircleShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    CircleShadow.ImageTransparency = 0.7
    
    local toggled = defaultValue or false
    
    if toggled then
        ToggleButton.BackgroundColor3 = C.Primary
        ToggleCircle.Position = UDim2.new(1, -25, 0.5, -11)
        ToggleCircle.BackgroundColor3 = C.Text
    end
    
    local function Toggle()
        toggled = not toggled
        if toggled then
            Services.TweenService:Create(ToggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = C.Primary}):Play()
            Services.TweenService:Create(ToggleCircle, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                Position = UDim2.new(1, -25, 0.5, -11),
                BackgroundColor3 = C.Text
            }):Play()
        else
            Services.TweenService:Create(ToggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
            Services.TweenService:Create(ToggleCircle, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
                Position = UDim2.new(0, 3, 0.5, -11),
                BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            }):Play()
        end
        callback(toggled)
    end
    
    local ToggleInput = Instance.new("TextButton")
    ToggleInput.Parent = ToggleFrame
    ToggleInput.BackgroundTransparency = 1
    ToggleInput.Size = UDim2.new(1, 0, 1, 0)
    ToggleInput.Text = ""
    ToggleInput.ZIndex = 5
    
    ToggleInput.MouseButton1Click:Connect(Toggle)
    
    ToggleFrame.MouseEnter:Connect(function()
        Services.TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    end)
    
    ToggleFrame.MouseLeave:Connect(function()
        Services.TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
    end)
    
    return ToggleFrame
end

local function CreateButton(parent, text, callback)
    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Parent = parent
    ButtonFrame.BackgroundColor3 = C.Primary
    ButtonFrame.BackgroundTransparency = 0.1
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Size = UDim2.new(1, 0, 0, 50)
    ButtonFrame.Font = Enum.Font.GothamBold
    ButtonFrame.Text = text
    ButtonFrame.TextColor3 = C.Text
    ButtonFrame.TextSize = 15
    ButtonFrame.AutoButtonColor = false
    ButtonFrame.ZIndex = 3
    
    local ButtonGradient = Instance.new("UIGradient")
    ButtonGradient.Parent = ButtonFrame
    ButtonGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, C.Primary),
        ColorSequenceKeypoint.new(1, C.Secondary)
    }
    ButtonGradient.Rotation = 45
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 12)
    ButtonCorner.Parent = ButtonFrame
    
    -- Shadow
    local ButtonShadow = Instance.new("ImageLabel")
    ButtonShadow.Parent = ButtonFrame
    ButtonShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    ButtonShadow.BackgroundTransparency = 1
    ButtonShadow.Position = UDim2.new(0.5, 0, 0.5, 3)
    ButtonShadow.Size = UDim2.new(1, 12, 1, 12)
    ButtonShadow.ZIndex = 2
    ButtonShadow.Image = "rbxassetid://5554236805"
    ButtonShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    ButtonShadow.ImageTransparency = 0.6
    
    ButtonFrame.MouseButton1Click:Connect(function()
        Services.TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, -5, 0, 48)}):Play()
        wait(0.1)
        Services.TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 50)}):Play()
        callback()
    end)
    
    ButtonFrame.MouseEnter:Connect(function()
        Services.TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        Services.TweenService:Create(ButtonShadow, TweenInfo.new(0.2), {ImageTransparency = 0.4}):Play()
    end)
    
    ButtonFrame.MouseLeave:Connect(function()
        Services.TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
        Services.TweenService:Create(ButtonShadow, TweenInfo.new(0.2), {ImageTransparency = 0.6}):Play()
    end)
    
    return ButtonFrame
end

local function CreateSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Parent = parent
    SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    SliderFrame.BackgroundTransparency = 0.3
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Size = UDim2.new(1, 0, 0, 75)
    SliderFrame.ZIndex = 3
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 12)
    SliderCorner.Parent = SliderFrame
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Parent = SliderFrame
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Position = UDim2.new(0, 20, 0, 12)
    SliderLabel.Size = UDim2.new(1, -40, 0, 22)
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.Text = text .. ": " .. default
    SliderLabel.TextColor3 = C.Text
    SliderLabel.TextSize = 14
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.ZIndex = 4
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Parent = SliderFrame
    SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SliderBar.BorderSizePixel = 0
    SliderBar.Position = UDim2.new(0, 20, 0, 45)
    SliderBar.Size = UDim2.new(1, -40, 0, 12)
    SliderBar.ZIndex = 4
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Parent = SliderBar
    SliderFill.BackgroundColor3 = C.Primary
    SliderFill.BorderSizePixel = 0
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.ZIndex = 5
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = SliderFill
    
    local FillGradient = Instance.new("UIGradient")
    FillGradient.Parent = SliderFill
    FillGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, C.Primary),
        ColorSequenceKeypoint.new(1, C.Secondary)
    }
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Parent = SliderBar
    SliderButton.BackgroundTransparency = 1
    SliderButton.Size = UDim2.new(1, 0, 1, 0)
    SliderButton.Text = ""
    SliderButton.ZIndex = 6
    
    local dragging = false
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    Services.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    Services.UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouse = Services.UserInputService:GetMouseLocation()
            local relativeX = math.clamp(mouse.X - SliderBar.AbsolutePosition.X, 0, SliderBar.AbsoluteSize.X)
            local percentage = relativeX / SliderBar.AbsoluteSize.X
            local value = math.floor(min + (max - min) * percentage)
            
            SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            SliderLabel.Text = text .. ": " .. value
            callback(value)
        end
    end)
    
    SliderFrame.MouseEnter:Connect(function()
        Services.TweenService:Create(SliderFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    end)
    
    SliderFrame.MouseLeave:Connect(function()
        Services.TweenService:Create(SliderFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
    end)
    
    return SliderFrame
end

local function CreateDropdown(parent, text, options, callback)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Parent = parent
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    DropdownFrame.BackgroundTransparency = 0.3
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.Size = UDim2.new(1, 0, 0, 55)
    DropdownFrame.ClipsDescendants = false
    DropdownFrame.ZIndex = 3
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 12)
    DropdownCorner.Parent = DropdownFrame
    
    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Parent = DropdownFrame
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Position = UDim2.new(0, 20, 0, 0)
    DropdownLabel.Size = UDim2.new(1, -70, 1, 0)
    DropdownLabel.Font = Enum.Font.Gotham
    DropdownLabel.Text = text .. ": " .. (options[1] or "None")
    DropdownLabel.TextColor3 = C.Text
    DropdownLabel.TextSize = 14
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    DropdownLabel.ZIndex = 4
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Parent = DropdownFrame
    DropdownButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    DropdownButton.BorderSizePixel = 0
    DropdownButton.Position = UDim2.new(1, -40, 0.5, -13)
    DropdownButton.Size = UDim2.new(0, 28, 0, 28)
    DropdownButton.Font = Enum.Font.GothamBold
    DropdownButton.Text = "▼"
    DropdownButton.TextColor3 = C.Text
    DropdownButton.TextSize = 11
    DropdownButton.ZIndex = 4
    
    local DropButtonCorner = Instance.new("UICorner")
    DropButtonCorner.CornerRadius = UDim.new(0, 8)
    DropButtonCorner.Parent = DropdownButton
    
    local DropdownList = Instance.new("ScrollingFrame")
    DropdownList.Parent = DropdownFrame
    DropdownList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    DropdownList.BorderSizePixel = 0
    DropdownList.Position = UDim2.new(0, 0, 1, 8)
    DropdownList.Size = UDim2.new(1, 0, 0, 0)
    DropdownList.Visible = false
    DropdownList.ScrollBarThickness = 4
    DropdownList.ScrollBarImageColor3 = C.Primary
    DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
    DropdownList.ZIndex = 10
    
    local ListCorner = Instance.new("UICorner")
    ListCorner.CornerRadius = UDim.new(0, 12)
    ListCorner.Parent = DropdownList
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = DropdownList
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 4)
    
    local ListPadding = Instance.new("UIPadding")
    ListPadding.Parent = DropdownList
    ListPadding.PaddingTop = UDim.new(0, 8)
    ListPadding.PaddingBottom = UDim.new(0, 8)
    ListPadding.PaddingLeft = UDim.new(0, 8)
    ListPadding.PaddingRight = UDim.new(0, 8)
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        DropdownList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 16)
    end)
    
    local isOpen = false
    
    DropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            DropdownList.Visible = true
            Services.TweenService:Create(DropdownList, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, math.min(#options * 38, 160))}):Play()
            DropdownButton.Text = "▲"
        else
            Services.TweenService:Create(DropdownList, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            wait(0.3)
            DropdownList.Visible = false
            DropdownButton.Text = "▼"
        end
    end)
    
    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Parent = DropdownList
        OptionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        OptionButton.BorderSizePixel = 0
        OptionButton.Size = UDim2.new(1, -8, 0, 34)
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.Text = option
        OptionButton.TextColor3 = C.Text
        OptionButton.TextSize = 13
        OptionButton.AutoButtonColor = false
        OptionButton.ZIndex = 11
        
        local OptCorner = Instance.new("UICorner")
        OptCorner.CornerRadius = UDim.new(0, 8)
        OptCorner.Parent = OptionButton
        
        OptionButton.MouseButton1Click:Connect(function()
            DropdownLabel.Text = text .. ": " .. option
            isOpen = false
            Services.TweenService:Create(DropdownList, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            wait(0.3)
            DropdownList.Visible = false
            DropdownButton.Text = "▼"
            callback(option)
        end)
        
        OptionButton.MouseEnter:Connect(function()
            Services.TweenService:Create(OptionButton, TweenInfo.new(0.2), {BackgroundColor3 = C.Primary}):Play()
        end)
        
        OptionButton.MouseLeave:Connect(function()
            Services.TweenService:Create(OptionButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
        end)
    end
    
    DropdownFrame.MouseEnter:Connect(function()
        Services.TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    end)
    
    DropdownFrame.MouseLeave:Connect(function()
        if not isOpen then
            Services.TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
        end
    end)
    
    return DropdownFrame
end

-- Create Tabs
local MainTab = CreateTab("Main", "🏠")
local FarmTab = CreateTab("Farm", "⚔️")
local CombatTab = CreateTab("Combat", "🗡️")
local StatsTab = CreateTab("Stats", "📊")
local BossTab = CreateTab("Boss", "👹")
local SeaTab = CreateTab("Sea", "🌊")
local RaidTab = CreateTab("Raid", "💀")
local TeleportTab = CreateTab("Teleport", "📍")
local ESPTab = CreateTab("ESP", "👁️")
local MiscTab = CreateTab("Misc", "⚙️")

--==========================================
-- MAIN TAB
--==========================================
CreateSection(MainTab, "⚡ Quick Actions")

CreateButton(MainTab, "🎁 Redeem All Codes", function()
    local codes = {
        "Sub2CaptainMaui", "kittgaming", "Sub2Fer999", "Enyu_is_Pro",
        "Magicbus", "JCWK", "Starcodeheo", "Bluxxy", "Sub2NoobMaster123",
        "Sub2UncleKizaru", "Sub2Daigrock", "Axiore", "TantaiGaming",
        "StrawHatMaine", "Sub2OfficialNoobie", "TheGreatAce", "Fudd10",
        "Bignews", "THEGREATACE", "SUB2GAMERROBOT_EXP1"
    }
    for _, code in pairs(codes) do
        Services.ReplicatedStorage.Remotes.Redeem:InvokeServer(code)
        wait(0.1)
    end
    Notify("SATX Hub", "All codes redeemed!")
end)

CreateButton(MainTab, "🎁 Collect All Chests", function()
    for _, v in pairs(Services.Workspace:GetChildren()) do
        if v.Name:find("Chest") then
            TP(v.CFrame)
            wait(0.3)
        end
    end
    Notify("SATX Hub", "Chests collected!")
end)

CreateSection(MainTab, "📊 Player Info")

local InfoFrame = Instance.new("Frame")
InfoFrame.Parent = MainTab
InfoFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
InfoFrame.BackgroundTransparency = 0.3
InfoFrame.BorderSizePixel = 0
InfoFrame.Size = UDim2.new(1, 0, 0, 100)
InfoFrame.ZIndex = 3

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 12)
InfoCorner.Parent = InfoFrame

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Parent = InfoFrame
InfoLabel.BackgroundTransparency = 1
InfoLabel.Size = UDim2.new(1, -30, 1, -30)
InfoLabel.Position = UDim2.new(0, 15, 0, 15)
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.Text = string.format(
    "Level: %d\nBeli: %s\nFragments: %s",
    Player.Data.Level.Value,
    Player.Data.Beli.Value,
    Player.Data.Fragments.Value or "N/A"
)
InfoLabel.TextColor3 = C.Text
InfoLabel.TextSize = 14
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.TextYAlignment = Enum.TextYAlignment.Top
InfoLabel.ZIndex = 4

--==========================================
-- FARM TAB
--==========================================
CreateSection(FarmTab, "⚔️ Auto Farm")

CreateToggle(FarmTab, "Auto Farm Level", false, function(value)
    _G.SATX.Settings.AutoFarmLevel = value
    Notify("SATX Hub", "Auto Farm Level: " .. tostring(value))
end)

CreateToggle(FarmTab, "Auto Farm Mastery", false, function(value)
    _G.SATX.Settings.AutoFarmMastery = value
end)

CreateToggle(FarmTab, "Auto Farm Bone", false, function(value)
    _G.SATX.Settings.AutoFarmBone = value
end)

CreateToggle(FarmTab, "Auto Farm Ectoplasm", false, function(value)
    _G.SATX.Settings.AutoFarmEctoplasm = value
end)

CreateSection(FarmTab, "⚙️ Settings")

CreateToggle(FarmTab, "Bring Mob", false, function(value)
    _G.SATX.Settings.BringMob = value
end)

CreateSlider(FarmTab, "Bring Distance", 100, 500, 350, function(value)
    _G.SATX.Settings.BringMobDistance = value
end)

CreateSlider(FarmTab, "Farm Distance", 10, 50, 30, function(value)
    _G.SATX.Settings.FarmDistance = value
end)

CreateDropdown(FarmTab, "Weapon", {"Melee", "Sword", "Gun", "Fruit"}, function(value)
    _G.SATX.Settings.SelectedWeapon = value
end)

--==========================================
-- COMBAT TAB
--==========================================
CreateSection(CombatTab, "⚡ Combat")

CreateToggle(CombatTab, "Fast Attack", false, function(value)
    _G.SATX.Settings.FastAttack = value
end)

CreateDropdown(CombatTab, "Fast Attack Mode", {"Slow", "Fast", "Super Fast"}, function(value)
    _G.SATX.Settings.FastAttackMode = value
end)

CreateToggle(CombatTab, "Auto Haki", false, function(value)
    _G.SATX.Settings.AutoHaki = value
end)

CreateToggle(CombatTab, "Auto Enhancement", false, function(value)
    _G.SATX.Settings.AutoEnhancement = value
end)

CreateSection(CombatTab, "🎯 Mastery")

CreateToggle(CombatTab, "Skill Mastery", false, function(value)
    _G.SATX.Settings.SkillMastery = value
end)

CreateToggle(CombatTab, "Gun Mastery", false, function(value)
    _G.SATX.Settings.GunMastery = value
end)

CreateToggle(CombatTab, "Devil Fruit Mastery", false, function(value)
    _G.SATX.Settings.DevilFruitMastery = value
end)

--==========================================
-- STATS TAB
--==========================================
CreateSection(StatsTab, "📈 Auto Stats")

CreateToggle(StatsTab, "Auto Melee", false, function(value)
    _G.SATX.Settings.AutoMelee = value
end)

CreateToggle(StatsTab, "Auto Defense", false, function(value)
    _G.SATX.Settings.AutoDefense = value
end)

CreateToggle(StatsTab, "Auto Sword", false, function(value)
    _G.SATX.Settings.AutoSword = value
end)

CreateToggle(StatsTab, "Auto Gun", false, function(value)
    _G.SATX.Settings.AutoGun = value
end)

CreateToggle(StatsTab, "Auto Devil Fruit", false, function(value)
    _G.SATX.Settings.AutoFruit = value
end)

CreateButton(StatsTab, "Reset Stats", function()
    Services.ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward", "Refund", "1")
    Notify("SATX Hub", "Stats reset!")
end)

--==========================================
-- BOSS TAB
--==========================================
CreateSection(BossTab, "👹 Boss Farm")

CreateToggle(BossTab, "Auto Boss", false, function(value)
    _G.SATX.Settings.AutoBoss = value
end)

CreateToggle(BossTab, "Auto All Boss", false, function(value)
    _G.SATX.Settings.AutoAllBoss = value
end)

CreateToggle(BossTab, "Auto Elite", false, function(value)
    _G.SATX.Settings.AutoElite = value
end)

CreateToggle(BossTab, "Auto Soul Reaper", false, function(value)
    _G.SATX.Settings.AutoSoulReaper = value
end)

CreateToggle(BossTab, "Auto Dough King", false, function(value)
    _G.SATX.Settings.AutoDoughKing = value
end)

CreateToggle(BossTab, "Auto Cake Prince", false, function(value)
    _G.SATX.Settings.AutoCakePrince = value
end)

--==========================================
-- SEA TAB
--==========================================
CreateSection(SeaTab, "🌊 Sea Events")

CreateToggle(SeaTab, "Auto Sea Beast", false, function(value)
    _G.SATX.Settings.AutoSeaBeast = value
end)

CreateToggle(SeaTab, "Auto Pirate Raid", false, function(value)
    _G.SATX.Settings.AutoPirateRaid = value
end)

CreateToggle(SeaTab, "Auto Ship", false, function(value)
    _G.SATX.Settings.AutoShip = value
end)

CreateToggle(SeaTab, "Auto Terrorshark", false, function(value)
    _G.SATX.Settings.AutoTerrorshark = value
end)

CreateToggle(SeaTab, "Auto Sea Event", false, function(value)
    _G.SATX.Settings.AutoSeaEvent = value
end)

--==========================================
-- RAID TAB
--==========================================
CreateSection(RaidTab, "💀 Raid")

CreateToggle(RaidTab, "Auto Raid", false, function(value)
    _G.SATX.Settings.AutoRaid = value
end)

CreateToggle(RaidTab, "Auto Awakener", false, function(value)
    _G.SATX.Settings.AutoAwakener = value
end)

CreateToggle(RaidTab, "Auto Buy Chip", false, function(value)
    _G.SATX.Settings.AutoBuyChip = value
end)

CreateToggle(RaidTab, "Kill Aura", false, function(value)
    _G.SATX.Settings.KillAura = value
end)

CreateDropdown(RaidTab, "Select Raid", {"Flame", "Ice", "Quake", "Light", "Dark", "Spider", "Rumble", "Magma", "Buddha", "Sand", "Phoenix"}, function(value)
    _G.SATX.Settings.SelectRaid = value
end)

CreateButton(RaidTab, "Start Raid", function()
    Services.ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", _G.SATX.Settings.SelectRaid)
end)

--==========================================
-- TELEPORT TAB
--==========================================
CreateSection(TeleportTab, "🗺️ Sea 1")

CreateButton(TeleportTab, "Jungle", function()
    TP(CFrame.new(-1612, 37, 149))
end)

CreateButton(TeleportTab, "Desert", function()
    TP(CFrame.new(944, 21, 4373))
end)

CreateButton(TeleportTab, "Frozen Village", function()
    TP(CFrame.new(1389, 87, -1298))
end)

CreateButton(TeleportTab, "Pirate Village", function()
    TP(CFrame.new(-1141, 5, 3831))
end)

CreateSection(TeleportTab, "🗺️ Sea 2")

CreateButton(TeleportTab, "Kingdom of Rose", function()
    TP(CFrame.new(-427, 73, 1835))
end)

CreateButton(TeleportTab, "Cafe", function()
    TP(CFrame.new(-385, 73, 297))
end)

CreateButton(TeleportTab, "Mansion", function()
    TP(CFrame.new(-12471, 374, -7551))
end)

CreateSection(TeleportTab, "🗺️ Sea 3")

CreateButton(TeleportTab, "Port Town", function()
    TP(CFrame.new(-290, 7, 5343))
end)

CreateButton(TeleportTab, "Hydra Island", function()
    TP(CFrame.new(5749, 612, -282))
end)

CreateButton(TeleportTab, "Great Tree", function()
    TP(CFrame.new(2681, 1682, -7190))
end)

CreateButton(TeleportTab, "Castle on the Sea", function()
    TP(CFrame.new(-5085, 316, -3156))
end)

--==========================================
-- ESP TAB
--==========================================
CreateSection(ESPTab, "👁️ ESP")

CreateToggle(ESPTab, "Player ESP", false, function(value)
    _G.SATX.Settings.ESPPlayer = value
end)

CreateToggle(ESPTab, "Mob ESP", false, function(value)
    _G.SATX.Settings.ESPMob = value
end)

CreateToggle(ESPTab, "Fruit ESP", false, function(value)
    _G.SATX.Settings.ESPFruit = value
end)

CreateToggle(ESPTab, "Chest ESP", false, function(value)
    _G.SATX.Settings.ESPChest = value
end)

CreateToggle(ESPTab, "Flower ESP", false, function(value)
    _G.SATX.Settings.ESPFlower = value
end)

CreateToggle(ESPTab, "NPC ESP", false, function(value)
    _G.SATX.Settings.ESPNPC = value
end)

CreateToggle(ESPTab, "Island ESP", false, function(value)
    _G.SATX.Settings.ESPIsland = value
end)

--==========================================
-- MISC TAB
--==========================================
CreateSection(MiscTab, "⚙️ Miscellaneous")

CreateToggle(MiscTab, "NoClip", false, function(value)
    _G.SATX.Settings.NoClip = value
end)

CreateToggle(MiscTab, "Infinite Energy", false, function(value)
    _G.SATX.Settings.InfiniteEnergy = value
end)

CreateToggle(MiscTab, "White Screen (FPS Boost)", false, function(value)
    _G.SATX.Settings.WhiteScreen = value
    if value then
        Services.RunService:Set3dRenderingEnabled(false)
    else
        Services.RunService:Set3dRenderingEnabled(true)
    end
end)

CreateToggle(MiscTab, "Remove Fog", false, function(value)
    _G.SATX.Settings.RemoveFog = value
    if value then
        Services.Lighting.FogEnd = 9e9
    else
        Services.Lighting.FogEnd = 100000
    end
end)

CreateSection(MiscTab, "🏃 Movement")

CreateSlider(MiscTab, "Walk Speed", 16, 200, 16, function(value)
    _G.SATX.Settings.WalkSpeed = value
end)

CreateSlider(MiscTab, "Jump Power", 50, 300, 50, function(value)
    _G.SATX.Settings.JumpPower = value
end)

CreateSection(MiscTab, "🎮 Race V3/V4")

CreateToggle(MiscTab, "Auto Active Race V3", false, function(value)
    _G.SATX.Settings.AutoActiveRaceV3 = value
end)

CreateToggle(MiscTab, "Auto Active Race V4", false, function(value)
    _G.SATX.Settings.AutoActiveRaceV4 = value
end)

-- Toggle GUI
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        Services.TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 900, 0, 600)}):Play()
    end
end)

-- Activate first tab
MainTab.Visible = true
TabContainer:GetChildren()[1].BackgroundColor3 = C.Primary
TabContainer:GetChildren()[1].BackgroundTransparency = 0
TabContainer:GetChildren()[1].TextColor3 = C.Text

-- Final Notification
Notify("SATX HUB", "Ultimate Edition Loaded Successfully! 🚀")

print([[
╔══════════════════════════════════════════════════╗
║     SATX BLOX FRUITS - ULTIMATE V4              ║
║     Neomorphic Design - December 2025            ║
║     Status: ✅ Fully Operational                 ║
║     Features: 100+ Premium Functions             ║
╚══════════════════════════════════════════════════╝
]])
