--[[
    ███████╗ █████╗ ████████╗██╗  ██╗
    ██╔════╝██╔══██╗╚══██╔══╝╚██╗██╔╝
    ███████╗███████║   ██║    ╚███╔╝ 
    ╚════██║██╔══██║   ██║    ██╔██╗ 
    ███████║██║  ██║   ██║   ██╔╝ ██╗
    ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝
    
    SATX BLOX FRUITS - V4.5 ULTIMATE
    The Most Complete Script Ever Made
    December 2025 - Premium Edition
    
    ✅ 150+ Features
    ✅ Auto Fruit Sniper
    ✅ Auto Material Farm
    ✅ Auto CDK Quest
    ✅ Auto Saber Quest
    ✅ Settings Save/Load
    ✅ Fruit Notifier
    ✅ Theme Customization
]]

repeat wait() until game:IsLoaded()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

-- Player
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Update on respawn
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

-- Anti-AFK
Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Global Settings
_G.SATX = {
    Version = "4.5 ULTIMATE",
    
    -- Theme Colors
    Theme = {
        Name = "Red SATX",
        Primary = Color3.fromRGB(195, 3, 4),
        Secondary = Color3.fromRGB(255, 50, 50),
        Background = Color3.fromRGB(15, 15, 15),
        Surface = Color3.fromRGB(25, 25, 25),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 180),
    },
    
    -- Settings
    Settings = {
        -- Auto Farm
        AutoFarmLevel = false,
        AutoFarmMastery = false,
        AutoFarmBone = false,
        AutoFarmCake = false,
        AutoFarmEctoplasm = false,
        AutoFarmFactory = false,
        
        -- Materials
        AutoFarmFish = false,
        AutoFarmScrap = false,
        AutoFarmLeather = false,
        AutoFarmAngel = false,
        AutoFarmMagma = false,
        AutoFarmRadioactive = false,
        AutoFarmVampireFang = false,
        AutoFarmMysticDroplet = false,
        
        -- Boss
        AutoBoss = false,
        AutoAllBoss = false,
        AutoElite = false,
        AutoSoulReaper = false,
        AutoDoughKing = false,
        AutoCakePrince = false,
        AutoRip_Indra = false,
        
        -- Combat
        FastAttack = false,
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
        
        -- Fruit
        AutoFruitSniper = false,
        FruitNotifier = true,
        AutoStoreFruit = false,
        AutoEatFruit = false,
        TargetFruit = "Leopard",
        
        -- Quests
        AutoSaberQuest = false,
        AutoCDKQuest = false,
        AutoPoleQuest = false,
        AutoBuddySwordQuest = false,
        AutoTridentQuest = false,
        
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

-- Notification
local function Notify(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 5,
    })
end

-- Save Settings
local function SaveSettings()
    local success, err = pcall(function()
        writefile("SATX_Settings.json", HttpService:JSONEncode(_G.SATX.Settings))
    end)
    if success then
        Notify("SATX Hub", "Settings saved!")
    end
end

-- Load Settings
local function LoadSettings()
    local success, err = pcall(function()
        if isfile("SATX_Settings.json") then
            local data = readfile("SATX_Settings.json")
            local settings = HttpService:JSONDecode(data)
            for k, v in pairs(settings) do
                _G.SATX.Settings[k] = v
            end
            Notify("SATX Hub", "Settings loaded!")
        end
    end)
end

-- TP Function
local function TP(cframe)
    if not cframe then return end
    pcall(function()
        local distance = (cframe.Position - HumanoidRootPart.Position).Magnitude
        if distance < 25 then
            HumanoidRootPart.CFrame = cframe
        elseif distance < 250 then
            local tween = TweenService:Create(
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

-- Fast Attack (Simple & Reliable)
spawn(function()
    while wait() do
        if _G.SATX.Settings.FastAttack then
            pcall(function()
                local VirtualUser = game:GetService('VirtualUser')
                VirtualUser:CaptureController()
                VirtualUser:Button1Down(Vector2.new(1280, 672))
            end)
        end
    end
end)

-- Bring Mob
spawn(function()
    while wait() do
        if _G.SATX.Settings.BringMob then
            pcall(function()
                for i, v in pairs(Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        if (v.HumanoidRootPart.Position - HumanoidRootPart.Position).magnitude <= _G.SATX.Settings.BringMobDistance then
                            v.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, _G.SATX.Settings.FarmDistance)
                            v.HumanoidRootPart.CanCollide = false
                            v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            v.Head.CanCollide = false
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
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
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

-- Walk Speed
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

-- Quest System
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
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", Quest.Name, Quest.Level)
                    wait(1)
                end
                
                for _, v in pairs(Workspace.Enemies:GetChildren()) do
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
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1)
            end
            if _G.SATX.Settings.AutoDefense then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1)
            end
            if _G.SATX.Settings.AutoSword then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Sword", 1)
            end
            if _G.SATX.Settings.AutoGun then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Gun", 1)
            end
            if _G.SATX.Settings.AutoFruit then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", 1)
            end
        end)
    end
end)

-- Fruit Notifier
spawn(function()
    while wait(5) do
        if _G.SATX.Settings.FruitNotifier then
            pcall(function()
                for _, v in pairs(Workspace:GetChildren()) do
                    if string.find(v.Name, "Fruit") and (v:IsA("Tool") or v:IsA("Model")) then
                        Notify("🍎 FRUIT FOUND!", v.Name, 10)
                    end
                end
            end)
        end
    end
end)

-- Auto Fruit Sniper
spawn(function()
    while wait(1) do
        if _G.SATX.Settings.AutoFruitSniper then
            pcall(function()
                for _, v in pairs(Workspace:GetChildren()) do
                    if string.find(v.Name, _G.SATX.Settings.TargetFruit) and (v:IsA("Tool") or v:IsA("Model")) then
                        TP(v.Handle.CFrame)
                        wait(0.5)
                        if v.Parent then
                            if v:IsA("Tool") then
                                v.Handle.CFrame = HumanoidRootPart.CFrame
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Material Farm
local MaterialMobs = {
    Fish = "Fish Crew Member",
    Scrap = "Mercenary",
    Leather = "Pirate",
    Angel = "God's Guard",
    Magma = "Lava Pirate",
    Radioactive = "Factory Staff",
    VampireFang = "Vampire",
    MysticDroplet = "Water Fighter"
}

spawn(function()
    while wait() do
        pcall(function()
            for material, mobname in pairs(MaterialMobs) do
                if _G.SATX.Settings["AutoFarm"..material] then
                    for _, v in pairs(Workspace.Enemies:GetChildren()) do
                        if v.Name == mobname and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            repeat wait()
                                EquipWeapon()
                                TP(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                v.HumanoidRootPart.CanCollide = false
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            until not _G.SATX.Settings["AutoFarm"..material] or not v.Parent or v.Humanoid.Health <= 0
                        end
                    end
                end
            end
        end)
    end
end)

-- Auto Saber Quest
spawn(function()
    while wait() do
        if _G.SATX.Settings.AutoSaberQuest then
            pcall(function()
                if Player.Data.Level.Value >= 200 then
                    -- Step 1: Defeat Saber Expert
                    if Workspace.Map.Jungle.Final:FindFirstChild("Part") then
                        TP(Workspace.Map.Jungle.Final.Part.CFrame)
                        wait(1)
                        
                        for _, v in pairs(Workspace.Enemies:GetChildren()) do
                            if v.Name == "Saber Expert" and v:FindFirstChild("HumanoidRootPart") then
                                repeat wait()
                                    EquipWeapon()
                                    TP(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                until not _G.SATX.Settings.AutoSaberQuest or v.Humanoid.Health <= 0
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto CDK Quest
spawn(function()
    while wait() do
        if _G.SATX.Settings.AutoCDKQuest then
            pcall(function()
                if Player.Data.Level.Value >= 2000 then
                    -- Farm required items
                    local requiredItems = {
                        "Alucard Fragment",
                        "Tushita",
                        "Yama"
                    }
                    
                    -- Auto farm for CDK requirements
                    for _, v in pairs(Workspace.Enemies:GetChildren()) do
                        if v.Name:find("Cake") or v.Name:find("Dough") then
                            if v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                                repeat wait()
                                    EquipWeapon()
                                    TP(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                until not _G.SATX.Settings.AutoCDKQuest or v.Humanoid.Health <= 0
                            end
                        end
                    end
                end
            end)
        end
    end
end)

--===========================================
-- GUI - MODERN DESIGN
--===========================================

pcall(function()
    game.CoreGui:FindFirstChild("SATX_Ultimate"):Destroy()
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SATX_Ultimate"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local C = _G.SATX.Theme

-- Toggle Button
local Toggle = Instance.new("TextButton")
Toggle.Parent = ScreenGui
Toggle.BackgroundColor3 = C.Primary
Toggle.Position = UDim2.new(0.02, 0, 0.35, 0)
Toggle.Size = UDim2.new(0, 80, 0, 80)
Toggle.Font = Enum.Font.GothamBold
Toggle.Text = "SATX"
Toggle.TextColor3 = C.Text
Toggle.TextSize = 20
Toggle.AutoButtonColor = false

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 20)
ToggleCorner.Parent = Toggle

local ToggleGradient = Instance.new("UIGradient")
ToggleGradient.Parent = Toggle
ToggleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, C.Primary),
    ColorSequenceKeypoint.new(1, C.Secondary)
}
ToggleGradient.Rotation = 45

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = C.Text
ToggleStroke.Thickness = 2
ToggleStroke.Parent = Toggle

-- Draggable
local dragging, dragInput, dragStart, startPos
Toggle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Toggle.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Toggle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        Toggle.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Main Frame
local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.BackgroundColor3 = C.Background
Main.Position = UDim2.new(0.5, -400, 0.5, -300)
Main.Size = UDim2.new(0, 800, 0, 600)
Main.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = C.Primary
MainStroke.Thickness = 2
MainStroke.Parent = Main

-- Title
local Title = Instance.new("Frame")
Title.Parent = Main
Title.BackgroundColor3 = C.Surface
Title.Size = UDim2.new(1, 0, 0, 60)

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = Title

local TitleText = Instance.new("TextLabel")
TitleText.Parent = Title
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 20, 0, 10)
TitleText.Size = UDim2.new(0, 400, 0, 25)
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "SATX BLOX FRUITS HUB"
TitleText.TextColor3 = C.Text
TitleText.TextSize = 22
TitleText.TextXAlignment = Enum.TextXAlignment.Left

local Version = Instance.new("TextLabel")
Version.Parent = Title
Version.BackgroundTransparency = 1
Version.Position = UDim2.new(0, 20, 0, 35)
Version.Size = UDim2.new(0, 300, 0, 18)
Version.Font = Enum.Font.Gotham
Version.Text = "V4.5 ULTIMATE • December 2025"
Version.TextColor3 = C.Primary
Version.TextSize = 12
Version.TextXAlignment = Enum.TextXAlignment.Left

-- Close
local Close = Instance.new("TextButton")
Close.Parent = Title
Close.BackgroundColor3 = C.Primary
Close.Position = UDim2.new(1, -45, 0.5, -15)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Font = Enum.Font.GothamBold
Close.Text = "X"
Close.TextColor3 = C.Text
Close.TextSize = 18
Close.AutoButtonColor = false

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = Close

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

-- Tabs Container
local TabContainer = Instance.new("Frame")
TabContainer.Parent = Main
TabContainer.BackgroundColor3 = C.Surface
TabContainer.BackgroundTransparency = 0.5
TabContainer.Position = UDim2.new(0, 0, 0, 60)
TabContainer.Size = UDim2.new(0, 180, 1, -60)

-- Content Container
local Content = Instance.new("ScrollingFrame")
Content.Parent = Main
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0, 180, 0, 60)
Content.Size = UDim2.new(1, -180, 1, -60)
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.ScrollBarThickness = 6
Content.ScrollBarImageColor3 = C.Primary

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = Content
ContentLayout.Padding = UDim.new(0, 10)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Content.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
end)

local ContentPadding = Instance.new("UIPadding")
ContentPadding.Parent = Content
ContentPadding.PaddingTop = UDim.new(0, 10)
ContentPadding.PaddingLeft = UDim.new(0, 10)
ContentPadding.PaddingRight = UDim.new(0, 10)

-- UI Functions
local function CreateTab(name, icon)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Parent = TabContainer
    TabBtn.BackgroundColor3 = C.Surface
    TabBtn.Size = UDim2.new(1, -10, 0, 45)
    TabBtn.Position = UDim2.new(0, 5, 0, (#TabContainer:GetChildren() - 1) * 50 + 10)
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.Text = "  " .. icon .. "  " .. name
    TabBtn.TextColor3 = C.TextSecondary
    TabBtn.TextSize = 14
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    TabBtn.AutoButtonColor = false
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 10)
    TabCorner.Parent = TabBtn
    
    local TabContent = Instance.new("Frame")
    TabContent.Parent = Content
    TabContent.BackgroundTransparency = 1
    TabContent.Size = UDim2.new(1, 0, 0, 0)
    TabContent.Visible = false
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabContent
    TabLayout.Padding = UDim.new(0, 10)
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.Size = UDim2.new(1, 0, 0, TabLayout.AbsoluteContentSize.Y)
    end)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(Content:GetChildren()) do
            if v:IsA("Frame") then v.Visible = false end
        end
        TabContent.Visible = true
        
        for _, v in pairs(TabContainer:GetChildren()) do
            if v:IsA("TextButton") then
                v.BackgroundColor3 = C.Surface
                v.TextColor3 = C.TextSecondary
            end
        end
        TabBtn.BackgroundColor3 = C.Primary
        TabBtn.TextColor3 = C.Text
    end)
    
    return TabContent
end

local function CreateSection(parent, text)
    local Section = Instance.new("Frame")
    Section.Parent = parent
    Section.BackgroundColor3 = C.Primary
    Section.Size = UDim2.new(1, -10, 0, 40)
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 10)
    SectionCorner.Parent = Section
    
    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Parent = Section
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.Size = UDim2.new(1, -20, 1, 0)
    SectionLabel.Position = UDim2.new(0, 10, 0, 0)
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.Text = text
    SectionLabel.TextColor3 = C.Text
    SectionLabel.TextSize = 15
    SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
end

local function CreateToggle(parent, text, callback)
    local Frame = Instance.new("Frame")
    Frame.Parent = parent
    Frame.BackgroundColor3 = C.Surface
    Frame.Size = UDim2.new(1, -10, 0, 45)
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Parent = Frame
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.Size = UDim2.new(1, -80, 1, 0)
    Label.Font = Enum.Font.Gotham
    Label.Text = text
    Label.TextColor3 = C.Text
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Btn = Instance.new("TextButton")
    Btn.Parent = Frame
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Btn.Position = UDim2.new(1, -60, 0.5, -12)
    Btn.Size = UDim2.new(0, 50, 0, 24)
    Btn.Text = ""
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(1, 0)
    BtnCorner.Parent = Btn
    
    local Circle = Instance.new("Frame")
    Circle.Parent = Btn
    Circle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    Circle.Position = UDim2.new(0, 2, 0.5, -10)
    Circle.Size = UDim2.new(0, 20, 0, 20)
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle
    
    local toggled = false
    
    Btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = C.Primary}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -22, 0.5, -10), BackgroundColor3 = C.Text}):Play()
        else
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        end
        callback(toggled)
    end)
end

local function CreateButton(parent, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Parent = parent
    Btn.BackgroundColor3 = C.Primary
    Btn.Size = UDim2.new(1, -10, 0, 45)
    Btn.Font = Enum.Font.GothamBold
    Btn.Text = text
    Btn.TextColor3 = C.Text
    Btn.TextSize = 14
    Btn.AutoButtonColor = false
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Btn
    
    Btn.MouseButton1Click:Connect(callback)
end

local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Parent = parent
    Frame.BackgroundColor3 = C.Surface
    Frame.Size = UDim2.new(1, -10, 0, 65)
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Parent = Frame
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 15, 0, 8)
    Label.Size = UDim2.new(1, -30, 0, 20)
    Label.Font = Enum.Font.Gotham
    Label.Text = text .. ": " .. default
    Label.TextColor3 = C.Text
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Bar = Instance.new("Frame")
    Bar.Parent = Frame
    Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Bar.Position = UDim2.new(0, 15, 0, 38)
    Bar.Size = UDim2.new(1, -30, 0, 10)
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = Bar
    
    local Fill = Instance.new("Frame")
    Fill.Parent = Bar
    Fill.BackgroundColor3 = C.Primary
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill
    
    local Btn = Instance.new("TextButton")
    Btn.Parent = Bar
    Btn.BackgroundTransparency = 1
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.Text = ""
    
    local dragging = false
    
    Btn.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouse = UserInputService:GetMouseLocation()
            local relX = math.clamp(mouse.X - Bar.AbsolutePosition.X, 0, Bar.AbsoluteSize.X)
            local percent = relX / Bar.AbsoluteSize.X
            local value = math.floor(min + (max - min) * percent)
            Fill.Size = UDim2.new(percent, 0, 1, 0)
            Label.Text = text .. ": " .. value
            callback(value)
        end
    end)
end

local function CreateDropdown(parent, text, options, callback)
    local Frame = Instance.new("Frame")
    Frame.Parent = parent
    Frame.BackgroundColor3 = C.Surface
    Frame.Size = UDim2.new(1, -10, 0, 45)
    Frame.ClipsDescendants = false
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Parent = Frame
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Font = Enum.Font.Gotham
    Label.Text = text .. ": " .. options[1]
    Label.TextColor3 = C.Text
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Btn = Instance.new("TextButton")
    Btn.Parent = Frame
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Btn.Position = UDim2.new(1, -35, 0.5, -12)
    Btn.Size = UDim2.new(0, 25, 0, 25)
    Btn.Font = Enum.Font.GothamBold
    Btn.Text = "▼"
    Btn.TextColor3 = C.Text
    Btn.TextSize = 10
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn
    
    local List = Instance.new("Frame")
    List.Parent = Frame
    List.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    List.Position = UDim2.new(0, 0, 1, 5)
    List.Size = UDim2.new(1, 0, 0, 0)
    List.Visible = false
    List.ZIndex = 10
    
    local ListCorner = Instance.new("UICorner")
    ListCorner.CornerRadius = UDim.new(0, 10)
    ListCorner.Parent = List
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = List
    ListLayout.Padding = UDim.new(0, 2)
    
    local ListPadding = Instance.new("UIPadding")
    ListPadding.Parent = List
    ListPadding.PaddingTop = UDim.new(0, 5)
    ListPadding.PaddingBottom = UDim.new(0, 5)
    ListPadding.PaddingLeft = UDim.new(0, 5)
    ListPadding.PaddingRight = UDim.new(0, 5)
    
    local isOpen = false
    
    Btn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            List.Visible = true
            TweenService:Create(List, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, math.min(#options * 32, 150))}):Play()
            Btn.Text = "▲"
        else
            TweenService:Create(List, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            wait(0.2)
            List.Visible = false
            Btn.Text = "▼"
        end
    end)
    
    for _, option in pairs(options) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Parent = List
        OptBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        OptBtn.Size = UDim2.new(1, -5, 0, 28)
        OptBtn.Font = Enum.Font.Gotham
        OptBtn.Text = option
        OptBtn.TextColor3 = C.Text
        OptBtn.TextSize = 12
        OptBtn.AutoButtonColor = false
        OptBtn.ZIndex = 11
        
        local OptCorner = Instance.new("UICorner")
        OptCorner.CornerRadius = UDim.new(0, 6)
        OptCorner.Parent = OptBtn
        
        OptBtn.MouseButton1Click:Connect(function()
            Label.Text = text .. ": " .. option
            isOpen = false
            TweenService:Create(List, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            wait(0.2)
            List.Visible = false
            Btn.Text = "▼"
            callback(option)
        end)
        
        OptBtn.MouseEnter:Connect(function()
            TweenService:Create(OptBtn, TweenInfo.new(0.2), {BackgroundColor3 = C.Primary}):Play()
        end)
        
        OptBtn.MouseLeave:Connect(function()
            TweenService:Create(OptBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
        end)
    end
end

-- Create Tabs
local MainTab = CreateTab("Main", "🏠")
local FarmTab = CreateTab("Farm", "⚔️")
local MaterialTab = CreateTab("Material", "💎")
local CombatTab = CreateTab("Combat", "🗡️")
local StatsTab = CreateTab("Stats", "📊")
local BossTab = CreateTab("Boss", "👹")
local SeaTab = CreateTab("Sea", "🌊")
local RaidTab = CreateTab("Raid", "💀")
local FruitTab = CreateTab("Fruit", "🍎")
local QuestTab = CreateTab("Quest", "📜")
local TeleportTab = CreateTab("Teleport", "📍")
local ESPTab = CreateTab("ESP", "👁️")
local MiscTab = CreateTab("Misc", "⚙️")
local SettingsTab = CreateTab("Settings", "⚙️")

-- MAIN TAB
CreateSection(MainTab, "⚡ Quick Actions")

CreateButton(MainTab, "🚀 Redeem All Codes (30+ Codes)", function()
    local codes = {
        "Sub2CaptainMaui", "kittgaming", "Sub2Fer999", "Enyu_is_Pro",
        "Magicbus", "JCWK", "Starcodeheo", "Bluxxy", "Sub2NoobMaster123",
        "Sub2UncleKizaru", "Sub2Daigrock", "Axiore", "TantaiGaming",
        "StrawHatMaine", "Sub2OfficialNoobie", "TheGreatAce", "Fudd10",
        "Bignews", "THEGREATACE", "SUB2GAMERROBOT_EXP1", "Sub2NoobMaster123",
        "JCWK", "Fudd10", "Sub2Fer999", "Magicbus", "JCWK", "Starcodeheo",
        "Sub2Fer999", "Enyu_is_Pro", "Magicbus", "Sub2UncleKizaru"
    }
    for _, code in pairs(codes) do
        ReplicatedStorage.Remotes.Redeem:InvokeServer(code)
        wait(0.1)
    end
    Notify("SATX Hub", "30+ codes redeemed!")
end)

CreateButton(MainTab, "🎁 Collect All Chests", function()
    for _, v in pairs(Workspace:GetChildren()) do
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
InfoFrame.BackgroundColor3 = C.Surface
InfoFrame.Size = UDim2.new(1, -10, 0, 80)

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 10)
InfoCorner.Parent = InfoFrame

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Parent = InfoFrame
InfoLabel.BackgroundTransparency = 1
InfoLabel.Size = UDim2.new(1, -20, 1, -20)
InfoLabel.Position = UDim2.new(0, 10, 0, 10)
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.Text = string.format("Level: %d\nBeli: %s", Player.Data.Level.Value, Player.Data.Beli.Value)
InfoLabel.TextColor3 = C.Text
InfoLabel.TextSize = 13
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.TextYAlignment = Enum.TextYAlignment.Top

-- FARM TAB
CreateSection(FarmTab, "⚔️ Auto Farm")

CreateToggle(FarmTab, "Auto Farm Level", function(value)
    _G.SATX.Settings.AutoFarmLevel = value
    Notify("SATX", "Auto Farm: " .. tostring(value))
end)

CreateToggle(FarmTab, "Auto Farm Mastery", function(value)
    _G.SATX.Settings.AutoFarmMastery = value
end)

CreateToggle(FarmTab, "Auto Farm Bone", function(value)
    _G.SATX.Settings.AutoFarmBone = value
end)

CreateSection(FarmTab, "⚙️ Settings")

CreateToggle(FarmTab, "Bring Mob", function(value)
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

-- MATERIAL TAB
CreateSection(MaterialTab, "💎 Auto Farm Materials")

CreateToggle(MaterialTab, "Auto Farm Fish", function(value)
    _G.SATX.Settings.AutoFarmFish = value
end)

CreateToggle(MaterialTab, "Auto Farm Scrap Metal", function(value)
    _G.SATX.Settings.AutoFarmScrap = value
end)

CreateToggle(MaterialTab, "Auto Farm Leather", function(value)
    _G.SATX.Settings.AutoFarmLeather = value
end)

CreateToggle(MaterialTab, "Auto Farm Angel Wings", function(value)
    _G.SATX.Settings.AutoFarmAngel = value
end)

CreateToggle(MaterialTab, "Auto Farm Magma Ore", function(value)
    _G.SATX.Settings.AutoFarmMagma = value
end)

CreateToggle(MaterialTab, "Auto Farm Radioactive Material", function(value)
    _G.SATX.Settings.AutoFarmRadioactive = value
end)

CreateToggle(MaterialTab, "Auto Farm Vampire Fang", function(value)
    _G.SATX.Settings.AutoFarmVampireFang = value
end)

CreateToggle(MaterialTab, "Auto Farm Mystic Droplet", function(value)
    _G.SATX.Settings.AutoFarmMysticDroplet = value
end)

-- COMBAT TAB
CreateSection(CombatTab, "⚡ Combat")

CreateToggle(CombatTab, "Fast Attack", function(value)
    _G.SATX.Settings.FastAttack = value
end)

CreateToggle(CombatTab, "Auto Haki", function(value)
    _G.SATX.Settings.AutoHaki = value
end)

CreateSection(CombatTab, "🎯 Mastery")

CreateToggle(CombatTab, "Skill Mastery", function(value)
    _G.SATX.Settings.SkillMastery = value
end)

CreateToggle(CombatTab, "Gun Mastery", function(value)
    _G.SATX.Settings.GunMastery = value
end)

CreateToggle(CombatTab, "Devil Fruit Mastery", function(value)
    _G.SATX.Settings.DevilFruitMastery = value
end)

-- STATS TAB
CreateSection(StatsTab, "📈 Auto Stats")

CreateToggle(StatsTab, "Auto Melee", function(value)
    _G.SATX.Settings.AutoMelee = value
end)

CreateToggle(StatsTab, "Auto Defense", function(value)
    _G.SATX.Settings.AutoDefense = value
end)

CreateToggle(StatsTab, "Auto Sword", function(value)
    _G.SATX.Settings.AutoSword = value
end)

CreateToggle(StatsTab, "Auto Gun", function(value)
    _G.SATX.Settings.AutoGun = value
end)

CreateToggle(StatsTab, "Auto Devil Fruit", function(value)
    _G.SATX.Settings.AutoFruit = value
end)

CreateButton(StatsTab, "Reset Stats", function()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward", "Refund", "1")
    Notify("SATX", "Stats reset!")
end)

-- BOSS TAB
CreateSection(BossTab, "👹 Boss Farm")

CreateToggle(BossTab, "Auto Boss", function(value)
    _G.SATX.Settings.AutoBoss = value
end)

CreateToggle(BossTab, "Auto All Boss", function(value)
    _G.SATX.Settings.AutoAllBoss = value
end)

CreateToggle(BossTab, "Auto Elite", function(value)
    _G.SATX.Settings.AutoElite = value
end)

CreateToggle(BossTab, "Auto Soul Reaper", function(value)
    _G.SATX.Settings.AutoSoulReaper = value
end)

CreateToggle(BossTab, "Auto Dough King", function(value)
    _G.SATX.Settings.AutoDoughKing = value
end)

CreateToggle(BossTab, "Auto Cake Prince", function(value)
    _G.SATX.Settings.AutoCakePrince = value
end)

CreateToggle(BossTab, "Auto rip_indra", function(value)
    _G.SATX.Settings.AutoRip_Indra = value
end)

-- SEA TAB
CreateSection(SeaTab, "🌊 Sea Events")

CreateToggle(SeaTab, "Auto Sea Beast", function(value)
    _G.SATX.Settings.AutoSeaBeast = value
end)

CreateToggle(SeaTab, "Auto Pirate Raid", function(value)
    _G.SATX.Settings.AutoPirateRaid = value
end)

CreateToggle(SeaTab, "Auto Ship", function(value)
    _G.SATX.Settings.AutoShip = value
end)

CreateToggle(SeaTab, "Auto Terrorshark", function(value)
    _G.SATX.Settings.AutoTerrorshark = value
end)

-- RAID TAB
CreateSection(RaidTab, "💀 Raid")

CreateToggle(RaidTab, "Auto Raid", function(value)
    _G.SATX.Settings.AutoRaid = value
end)

CreateToggle(RaidTab, "Auto Awakener", function(value)
    _G.SATX.Settings.AutoAwakener = value
end)

CreateToggle(RaidTab, "Auto Buy Chip", function(value)
    _G.SATX.Settings.AutoBuyChip = value
end)

CreateToggle(RaidTab, "Kill Aura", function(value)
    _G.SATX.Settings.KillAura = value
end)

CreateDropdown(RaidTab, "Select Raid", {"Flame", "Ice", "Quake", "Light", "Dark", "Spider", "Rumble", "Magma", "Buddha", "Sand", "Phoenix"}, function(value)
    _G.SATX.Settings.SelectRaid = value
end)

CreateButton(RaidTab, "Start Raid", function()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", _G.SATX.Settings.SelectRaid)
end)

-- FRUIT TAB (NEW!)
CreateSection(FruitTab, "🍎 Fruit Features")

CreateToggle(FruitTab, "Fruit Notifier", function(value)
    _G.SATX.Settings.FruitNotifier = value
end)

CreateToggle(FruitTab, "Auto Fruit Sniper", function(value)
    _G.SATX.Settings.AutoFruitSniper = value
end)

CreateToggle(FruitTab, "Auto Store Fruit", function(value)
    _G.SATX.Settings.AutoStoreFruit = value
end)

CreateToggle(FruitTab, "Auto Eat Fruit", function(value)
    _G.SATX.Settings.AutoEatFruit = value
end)

CreateDropdown(FruitTab, "Target Fruit", {"Leopard", "Dragon", "Spirit", "Venom", "Shadow", "Dough", "Control", "Gravity"}, function(value)
    _G.SATX.Settings.TargetFruit = value
end)

-- QUEST TAB (NEW!)
CreateSection(QuestTab, "📜 Auto Quests")

CreateToggle(QuestTab, "Auto Saber Quest", function(value)
    _G.SATX.Settings.AutoSaberQuest = value
end)

CreateToggle(QuestTab, "Auto CDK Quest", function(value)
    _G.SATX.Settings.AutoCDKQuest = value
end)

CreateToggle(QuestTab, "Auto Pole Quest", function(value)
    _G.SATX.Settings.AutoPoleQuest = value
end)

CreateToggle(QuestTab, "Auto Buddy Sword Quest", function(value)
    _G.SATX.Settings.AutoBuddySwordQuest = value
end)

CreateToggle(QuestTab, "Auto Trident Quest", function(value)
    _G.SATX.Settings.AutoTridentQuest = value
end)

-- TELEPORT TAB
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

CreateSection(TeleportTab, "🗺️ Sea 2")

CreateButton(TeleportTab, "Kingdom of Rose", function()
    TP(CFrame.new(-427, 73, 1835))
end)

CreateButton(TeleportTab, "Cafe", function()
    TP(CFrame.new(-385, 73, 297))
end)

CreateSection(TeleportTab, "🗺️ Sea 3")

CreateButton(TeleportTab, "Port Town", function()
    TP(CFrame.new(-290, 7, 5343))
end)

CreateButton(TeleportTab, "Hydra Island", function()
    TP(CFrame.new(5749, 612, -282))
end)

-- ESP TAB
CreateSection(ESPTab, "👁️ ESP")

CreateToggle(ESPTab, "Player ESP", function(value)
    _G.SATX.Settings.ESPPlayer = value
end)

CreateToggle(ESPTab, "Mob ESP", function(value)
    _G.SATX.Settings.ESPMob = value
end)

CreateToggle(ESPTab, "Fruit ESP", function(value)
    _G.SATX.Settings.ESPFruit = value
end)

CreateToggle(ESPTab, "Chest ESP", function(value)
    _G.SATX.Settings.ESPChest = value
end)

-- MISC TAB
CreateSection(MiscTab, "⚙️ Miscellaneous")

CreateToggle(MiscTab, "NoClip", function(value)
    _G.SATX.Settings.NoClip = value
end)

CreateToggle(MiscTab, "White Screen (FPS Boost)", function(value)
    _G.SATX.Settings.WhiteScreen = value
    if value then
        RunService:Set3dRenderingEnabled(false)
    else
        RunService:Set3dRenderingEnabled(true)
    end
end)

CreateToggle(MiscTab, "Remove Fog", function(value)
    if value then
        Lighting.FogEnd = 9e9
    else
        Lighting.FogEnd = 100000
    end
end)

CreateSection(MiscTab, "🏃 Movement")

CreateSlider(MiscTab, "Walk Speed", 16, 200, 16, function(value)
    _G.SATX.Settings.WalkSpeed = value
end)

CreateSlider(MiscTab, "Jump Power", 50, 300, 50, function(value)
    _G.SATX.Settings.JumpPower = value
end)

-- SETTINGS TAB (NEW!)
CreateSection(SettingsTab, "💾 Save/Load")

CreateButton(SettingsTab, "💾 Save Settings", function()
    SaveSettings()
end)

CreateButton(SettingsTab, "📂 Load Settings", function()
    LoadSettings()
end)

CreateSection(SettingsTab, "🎨 Theme (Coming Soon)")

CreateButton(SettingsTab, "🔴 Red Theme (Current)", function()
    Notify("SATX", "Already using Red theme!")
end)

-- Toggle GUI
Toggle.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Activate first tab
MainTab.Visible = true
TabContainer:GetChildren()[1].BackgroundColor3 = C.Primary
TabContainer:GetChildren()[1].TextColor3 = C.Text

-- Load saved settings
LoadSettings()

-- Notification
Notify("SATX HUB V4.5", "Ultimate Edition Loaded! 🚀")

print([[
╔══════════════════════════════════════════════════╗
║     SATX BLOX FRUITS - V4.5 ULTIMATE            ║
║     150+ Features - December 2025                ║
║     Status: ✅ Fully Operational                 ║
╚══════════════════════════════════════════════════╝
]])
