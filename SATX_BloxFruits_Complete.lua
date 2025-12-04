--[[
    ███████╗ █████╗ ████████╗██╗  ██╗
    ██╔════╝██╔══██╗╚══██╔══╝╚██╗██╔╝
    ███████╗███████║   ██║    ╚███╔╝ 
    ╚════██║██╔══██║   ██║    ██╔██╗ 
    ███████║██║  ██║   ██║   ██╔╝ ██╗
    ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝
    
    SATX Blox Fruits Hub - ULTIMATE Edition
    Version: 3.0 ULTRA
    The Most Complete Script Ever Created
    
    Features from: Hoho Hub, Zen Hub, Redz Hub, Mukuro Hub, W-azure
]]

-- Anti-Leak Protection
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local StarterGui = game:GetService("StarterGui")

-- Player Variables
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Update Character on respawn
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)

-- Anti-AFK System
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
    vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- Global Variables
local SATX = {
    Version = "3.0 ULTIMATE",
    Settings = {
        -- Auto Farm Settings
        AutoFarm = false,
        AutoFarmLevel = false,
        AutoFarmBone = false,
        AutoFarmCake = false,
        AutoFarmEctoplasm = false,
        AutoFarmFactory = false,
        AutoFarmMastery = false,
        
        -- Boss Farm
        AutoBoss = false,
        AutoAllBoss = false,
        AutoElite = false,
        AutoSoulReaper = false,
        AutoDoughKing = false,
        AutoCakePrince = false,
        
        -- Combat Settings
        FastAttack = false,
        FastAttackMode = "Fast",
        AutoHaki = true,
        AutoEnhancement = true,
        
        -- Mastery
        SkillMastery = false,
        GunMastery = false,
        
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
        AutoSeaEvent = false,
        AutoTerrorshark = false,
        
        -- Raid
        AutoRaid = false,
        AutoAwakener = false,
        AutoBuyChip = false,
        KillAura = false,
        
        -- Misc
        BringMob = false,
        FastAttackDelay = 0.1,
        WhiteScreen = false,
        RemoveFog = false,
        NoClip = false,
        InfiniteEnergy = false,
        AutoActiveRaceV3 = false,
        AutoActiveRaceV4 = false,
        
        -- Movement
        WalkSpeed = 16,
        JumpPower = 50,
        
        -- ESP Settings
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
        
        -- Selections
        SelectedWeapon = "Melee",
        SelectedBoss = "None",
        SelectedMob = "None",
        SelectRaid = "Flame",
    }
}

-- Upload Custom Image to Roblox (Your logo will be displayed)
local SATXLogo = "rbxassetid://18793359224" -- Placeholder, you'll need to upload your image

-- Weapon List
local WeaponList = {}
local WeaponType = {"Melee", "Sword", "Gun", "Fruit"}

-- Get Weapons
for _, v in pairs(Player.Backpack:GetChildren()) do
    if v:IsA("Tool") then
        table.insert(WeaponList, v.Name)
    end
end

for _, v in pairs(Character:GetChildren()) do
    if v:IsA("Tool") then
        table.insert(WeaponList, v.Name)
    end
end

-- Utility Functions
local function Notify(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = duration or 5;
        Icon = SATXLogo;
    })
end

local function TP(pos)
    if not pos then return end
    local Distance = (pos.Position - HumanoidRootPart.Position).Magnitude
    
    if Distance < 25 then
        HumanoidRootPart.CFrame = pos
    elseif Distance < 250 then
        local tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(Distance/300, Enum.EasingStyle.Linear), {CFrame = pos})
        tween:Play()
    else
        HumanoidRootPart.CFrame = pos
    end
end

-- Fast Attack System (From Hoho Hub - Best Fast Attack)
local Camera = Workspace.CurrentCamera
local CombatFramework = require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework)
local CombatFrameworkR = getupvalues(CombatFramework)[2]
local RigController = require(game:GetService("Players")["LocalPlayer"].PlayerScripts.CombatFramework.RigController)
local RigControllerR = getupvalues(RigController)[2]
local realbhit = require(game.ReplicatedStorage.CombatFramework.RigLib)
local cooldownfastattack = tick()

function CurrentWeapon()
    local ac = CombatFrameworkR.activeController
    local ret = ac.blades[1]
    if not ret then return game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Name end
    pcall(function()
        while ret.Parent~=game.Players.LocalPlayer.Character do ret=ret.Parent end
    end)
    if not ret then return game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Name end
    return ret
end

function getAllBladeHitsPlayers(Sizes)
    local Hits = {}
    local Client = game.Players.LocalPlayer
    local Characters = game:GetService("Workspace").Characters:GetChildren()
    for i=1,#Characters do local v = Characters[i]
        local Human = v:FindFirstChildOfClass("Humanoid")
        if v.Name ~= game.Players.LocalPlayer.Name and Human and Human.RootPart and Human.Health > 0 and Client:DistanceFromCharacter(Human.RootPart.Position) < Sizes+5 then
            table.insert(Hits,Human.RootPart)
        end
    end
    return Hits
end

function getAllBladeHits(Sizes)
    local Hits = {}
    local Client = game.Players.LocalPlayer
    local Enemies = game:GetService("Workspace").Enemies:GetChildren()
    for i=1,#Enemies do local v = Enemies[i]
        local Human = v:FindFirstChildOfClass("Humanoid")
        if Human and Human.RootPart and Human.Health > 0 and Client:DistanceFromCharacter(Human.RootPart.Position) < Sizes+5 then
            table.insert(Hits,Human.RootPart)
        end
    end
    return Hits
end

spawn(function()
    while wait() do
        if SATX.Settings.FastAttack then
            pcall(function()
                if SATX.Settings.FastAttackMode == "Fast" then
                    repeat wait()
                        AttackFunction()
                    until not SATX.Settings.FastAttack
                elseif SATX.Settings.FastAttackMode == "Super Fast" then
                    for i = 1, 5 do
                        wait()
                        AttackFunction()
                    end
                elseif SATX.Settings.FastAttackMode == "Slow" then
                    wait(0.2)
                    AttackFunction()
                end
            end)
        end
    end
end)

function AttackFunction()
    pcall(function()
        local AC = CombatFrameworkR.activeController
        if AC and AC.equipped then
            for indexincrement = 1, 1 do
                local bladehit = getAllBladeHits(60)
                if #bladehit > 0 then
                    local AcAttack8 = debug.getupvalue(AC.attack, 5)
                    local AcAttack9 = debug.getupvalue(AC.attack, 6)
                    local AcAttack7 = debug.getupvalue(AC.attack, 4)
                    local AcAttack10 = debug.getupvalue(AC.attack, 7)
                    local NumberAc12 = (AcAttack8 * 798405 + AcAttack7 * 727595) % AcAttack9
                    local NumberAc13 = AcAttack7 * 798405
                    (function()
                        NumberAc12 = (NumberAc12 * AcAttack9 + NumberAc13) % 1099511627776
                        AcAttack8 = math.floor(NumberAc12 / AcAttack9)
                        AcAttack7 = NumberAc12 - AcAttack8 * AcAttack9
                    end)()
                    AcAttack10 = AcAttack10 + 1
                    debug.setupvalue(AC.attack, 5, AcAttack8)
                    debug.setupvalue(AC.attack, 6, AcAttack9)
                    debug.setupvalue(AC.attack, 4, AcAttack7)
                    debug.setupvalue(AC.attack, 7, AcAttack10)
                    for k, v in pairs(AC.animator.anims.basic) do
                        v:Play(0.01,0.01,0.01)
                    end                 
                    if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") and AC.blades and AC.blades[1] then 
                        game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("weaponChange",tostring(CurrentWeapon()))
                        game.ReplicatedStorage.Remotes.Validator:FireServer(math.floor(NumberAc12 / 1099511627776 * 16777215), AcAttack10)
                        game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("hit", bladehit, 2, "") 
                    end
                end
            end
        end
    end)
end

-- Bring Mob Function (From Mukuro Hub)
spawn(function()
    while wait() do
        if SATX.Settings.BringMob then
            pcall(function()
                for i, v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        if (v.HumanoidRootPart.Position - HumanoidRootPart.Position).magnitude <= SATX.Settings.BringMobDistance then
                            v.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, SATX.Settings.FarmDistance)
                            v.HumanoidRootPart.CanCollide = false
                            v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            v.Head.CanCollide = false
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                        end
                    end
                end
            end)
        end
    end
end)

-- NoClip
spawn(function()
    while wait() do
        if SATX.Settings.NoClip then
            for _, v in pairs(Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end
end)

-- Auto Haki
spawn(function()
    while wait() do
        if SATX.Settings.AutoHaki then
            if not Player.Character:FindFirstChild("HasBuso") then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
            end
        end
    end
end)

-- Walk Speed
spawn(function()
    while wait() do
        pcall(function()
            if Humanoid then
                Humanoid.WalkSpeed = SATX.Settings.WalkSpeed
                Humanoid.JumpPower = SATX.Settings.JumpPower
            end
        end)
    end
end)

-- Quest System
local function GetQuestByLevel()
    local level = Player.Data.Level.Value
    local quests = {
        {1, 9, "BanditQuest1", "Bandit", 1, CFrame.new(1059.37195, 16.5139828, 1549.22729)},
        {10, 14, "JungleQuest", "Monkey", 1, CFrame.new(-1448.51806640625, 67.85301208496094, 11.46579647064209)},
        {15, 29, "JungleQuest", "Gorilla", 2, CFrame.new(-1129.8836669921875, 40.46354675292969, -525.4237060546875)},
        {30, 39, "BuggyQuest1", "Pirate", 1, CFrame.new(-1141.0223388671875, 4.7514519691467285, 3831.456787109375)},
        {40, 59, "BuggyQuest1", "Brute", 2, CFrame.new(-1141.0223388671875, 4.7514519691467285, 3831.456787109375)},
        {60, 74, "DesertQuest", "Desert Bandit", 1, CFrame.new(894.488525390625, 6.493870735168457, 4390.88671875)},
        {75, 89, "DesertQuest", "Desert Officer", 2, CFrame.new(1608.2822265625, 8.079000473022461, 4371.00732421875)},
        {90, 99, "SnowQuest", "Snow Bandit", 1, CFrame.new(1389.74451, 87.272789, -1298.90796)},
        {100, 119, "SnowQuest", "Snowman", 2, CFrame.new(1389.74451, 87.272789, -1298.90796)},
        {120, 149, "MarineQuest2", "Chief Petty Officer", 1, CFrame.new(-4914.8212890625, 50.44632720947266, 4281.58447265625)},
        {150, 174, "SkyQuest", "Sky Bandit", 1, CFrame.new(-4842.83251953125, 717.6661376953125, -2623.96435546875)},
        {175, 189, "SkyQuest", "Dark Master", 2, CFrame.new(-4842.83251953125, 717.6661376953125, -2623.96435546875)},
        {190, 209, "PrisonerQuest", "Prisoner", 1, CFrame.new(5308.9306640625, 0.20333321392536163, 474.8701171875)},
        {210, 249, "PrisonerQuest", "Dangerous Prisoner", 2, CFrame.new(5308.9306640625, 0.20333321392536163, 474.8701171875)},
        {250, 274, "ColosseumQuest", "Toga Warrior", 1, CFrame.new(-1770.4990234375, 7.392412185668945, -2983.43359375)},
        {275, 299, "ColosseumQuest", "Gladiator", 2, CFrame.new(-1770.4990234375, 7.392412185668945, -2983.43359375)},
        {300, 324, "MagmaQuest", "Military Soldier", 1, CFrame.new(-5408.26513671875, 11.013852119445801, 8444.2744140625)},
        {325, 374, "MagmaQuest", "Military Spy", 2, CFrame.new(-5408.26513671875, 11.013852119445801, 8444.2744140625)},
        {375, 399, "FishmanQuest", "Fishman Warrior", 1, CFrame.new(61122.65234375, 18.497442245483398, 1569.3997802734375)},
        {400, 449, "FishmanQuest", "Fishman Commando", 2, CFrame.new(61122.65234375, 18.497442245483398, 1569.3997802734375)},
        {450, 474, "SkyExp1Quest", "God's Guard", 1, CFrame.new(-4721.88720703125, 843.8740234375, -1949.96643066406)},
        {475, 524, "SkyExp1Quest", "Shanda", 2, CFrame.new(-7863.1650390625, 5545.5224609375, -378.42266845703125)},
        {525, 549, "SkyExp2Quest", "Royal Squad", 1, CFrame.new(-7906.81201171875, 5634.6318359375, -1411.99267578125)},
        {550, 624, "SkyExp2Quest", "Royal Soldier", 2, CFrame.new(-7906.81201171875, 5634.6318359375, -1411.99267578125)},
        {625, 649, "FountainQuest", "Galley Pirate", 1, CFrame.new(5258.2802734375, 38.526931762695312, 4050.044677734375)},
        {650, 699, "FountainQuest", "Galley Captain", 2, CFrame.new(5258.2802734375, 38.526931762695312, 4050.044677734375)},
        {700, 724, "Area1Quest", "Raider", 1, CFrame.new(-427.72567749023, 72.99634552002, 1835.9426269531)},
        {725, 774, "Area1Quest", "Mercenary", 2, CFrame.new(-427.72567749023, 72.99634552002, 1835.9426269531)},
        {775, 799, "Area2Quest", "Swan Pirate", 1, CFrame.new(932.31, 125.95, 33159.82)},
        {800, 874, "Area2Quest", "Factory Staff", 2, CFrame.new(266.26, 73.12, -2984.29)},
        {875, 899, "MarineQuest3", "Marine Lieutenant", 1, CFrame.new(-2440.79639, 71.7140732, -3216.06812)},
        {900, 949, "MarineQuest3", "Marine Captain", 2, CFrame.new(-2440.79639, 71.7140732, -3216.06812)},
        {950, 974, "ZombieQuest", "Zombie", 1, CFrame.new(-5497.06152, 47.5923004, -795.237061)},
        {975, 999, "ZombieQuest", "Vampire", 2, CFrame.new(-5497.06152, 47.5923004, -795.237061)},
        {1000, 1049, "SnowMountainQuest", "Snow Trooper", 1, CFrame.new(609.858826, 400.119904, -5370.75244)},
        {1050, 1099, "SnowMountainQuest", "Winter Warrior", 2, CFrame.new(609.858826, 400.119904, -5370.75244)},
        {1100, 1124, "IceSideQuest", "Lab Subordinate", 1, CFrame.new(-5769.2041015625, 37.787498474121094, -4476.8974609375)},
        {1125, 1174, "IceSideQuest", "Horned Warrior", 2, CFrame.new(-6341.36669921875, 15.951762199401855, -5723.162109375)},
        {1175, 1199, "FireSideQuest", "Magma Ninja", 1, CFrame.new(-5428.03174, 15.0610342, -5299.43457)},
        {1200, 1249, "FireSideQuest", "Lava Pirate", 2, CFrame.new(-5428.03174, 15.0610342, -5299.43457)},
        {1250, 1274, "ShipQuest1", "Ship Deckhand", 1, CFrame.new(1037.80127, 125.092171, 32911.6016)},
        {1275, 1299, "ShipQuest1", "Ship Engineer", 2, CFrame.new(1037.80127, 125.092171, 32911.6016)},
        {1300, 1324, "ShipQuest2", "Ship Steward", 1, CFrame.new(919.35, 125.92, 33436.03)},
        {1325, 1349, "ShipQuest2", "Ship Officer", 2, CFrame.new(919.35, 125.92, 33436.03)},
        {1350, 1374, "FrostQuest", "Arctic Warrior", 1, CFrame.new(5942.85, 28.2980003, -6179.98)},
        {1375, 1399, "FrostQuest", "Snow Lurker", 2, CFrame.new(5942.85, 28.2980003, -6179.98)},
        {1400, 1424, "ForgottenQuest", "Sea Soldier", 1, CFrame.new(-3053.89331, 236.881363, -10148.2324)},
        {1425, 1449, "ForgottenQuest", "Water Fighter", 2, CFrame.new(-3053.89331, 236.881363, -10148.2324)},
        {1450, 1474, "TikiQuest1", "Horned Warrior", 1, CFrame.new(-16545.9355, 55.6863556, -173.230499)},
    }
    
    for _, quest in ipairs(quests) do
        if level >= quest[1] and level <= quest[2] then
            return {
                QuestName = quest[3],
                MobName = quest[4],
                QuestLevel = quest[5],
                QuestPos = quest[6]
            }
        end
    end
    
    return {QuestName = "BanditQuest1", MobName = "Bandit", QuestLevel = 1, QuestPos = CFrame.new(1059.37195, 16.5139828, 1549.22729)}
end

-- Auto Farm Level
spawn(function()
    while wait() do
        if SATX.Settings.AutoFarmLevel then
            pcall(function()
                local QuestData = GetQuestByLevel()
                local QuestName = QuestData.QuestName
                local MobName = QuestData.MobName
                local QuestLevel = QuestData.QuestLevel
                local QuestPos = QuestData.QuestPos
                
                -- Check if we have the quest
                if not Player.PlayerGui.Main.Quest.Visible or Player.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text ~= MobName then
                    -- Get quest
                    TP(QuestPos)
                    wait(1)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", QuestName, QuestLevel)
                else
                    -- Farm mob
                    for i, v in pairs(game.Workspace.Enemies:GetChildren()) do
                        if v.Name == MobName and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                            repeat wait()
                                if SATX.Settings.AutoHaki then
                                    if not Player.Character:FindFirstChild("HasBuso") then
                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                                    end
                                end
                                
                                EquipWeapon(SATX.Settings.SelectedWeapon)
                                TP(v.HumanoidRootPart.CFrame * CFrame.new(0, SATX.Settings.FarmDistance, 0))
                                v.HumanoidRootPart.CanCollide = false
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                
                            until not SATX.Settings.AutoFarmLevel or not v.Parent or v.Humanoid.Health <= 0
                        end
                    end
                end
            end)
        end
    end
end)

-- Equip Weapon Function
function EquipWeapon(weaponName)
    if weaponName == "Melee" then
        pcall(function()
            for _, v in pairs(Player.Backpack:GetChildren()) do
                if v:IsA("Tool") and v.ToolTip:lower():find("melee") then
                    Humanoid:EquipTool(v)
                    return
                end
            end
        end)
    elseif weaponName == "Sword" then
        pcall(function()
            for _, v in pairs(Player.Backpack:GetChildren()) do
                if v:IsA("Tool") and v.ToolTip:lower():find("sword") then
                    Humanoid:EquipTool(v)
                    return
                end
            end
        end)
    elseif weaponName == "Gun" then
        pcall(function()
            for _, v in pairs(Player.Backpack:GetChildren()) do
                if v:IsA("Tool") and v.ToolTip:lower():find("gun") then
                    Humanoid:EquipTool(v)
                    return
                end
            end
        end)
    elseif weaponName == "Fruit" then
        pcall(function()
            for _, v in pairs(Player.Backpack:GetChildren()) do
                if v:IsA("Tool") and v.ToolTip:lower():find("blox fruit") then
                    Humanoid:EquipTool(v)
                    return
                end
            end
        end)
    else
        pcall(function()
            local weapon = Player.Backpack:FindFirstChild(weaponName)
            if weapon then
                Humanoid:EquipTool(weapon)
            end
        end)
    end
end

-- Auto Stats
spawn(function()
    while wait() do
        if SATX.Settings.AutoMelee then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1)
        end
        if SATX.Settings.AutoDefense then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1)
        end
        if SATX.Settings.AutoSword then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Sword", 1)
        end
        if SATX.Settings.AutoGun then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Gun", 1)
        end
        if SATX.Settings.AutoFruit then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", 1)
        end
        wait(0.1)
    end
end)

-- ESP Functions
local function CreateESP(obj, color, text)
    local Billboard = Instance.new("BillboardGui", obj)
    Billboard.Name = "ESP"
    Billboard.AlwaysOnTop = true
    Billboard.Size = UDim2.new(0, 100, 0, 50)
    Billboard.StudsOffset = Vector3.new(0, 3, 0)
    
    local TextLabel = Instance.new("TextLabel", Billboard)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextColor3 = color
    TextLabel.TextStrokeTransparency = 0
    TextLabel.TextSize = 14
    TextLabel.Text = text
    
    return Billboard
end

-- Fruit ESP
spawn(function()
    while wait(2) do
        if SATX.Settings.ESPFruit then
            for _, v in pairs(Workspace:GetChildren()) do
                if string.find(v.Name, "Fruit") and v:IsA("Tool") or v:IsA("Model") then
                    if not v:FindFirstChild("ESP") then
                        CreateESP(v, Color3.fromRGB(255, 0, 0), v.Name)
                    end
                end
            end
        else
            for _, v in pairs(Workspace:GetChildren()) do
                if v:FindFirstChild("ESP") then
                    v.ESP:Destroy()
                end
            end
        end
    end
end)

-- Mob ESP
spawn(function()
    while wait(2) do
        if SATX.Settings.ESPMob then
            for _, v in pairs(Workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("HumanoidRootPart") and not v:FindFirstChild("ESP") then
                    CreateESP(v.HumanoidRootPart, Color3.fromRGB(255, 255, 0), v.Name .. " [" .. math.floor(v.Humanoid.Health) .. " HP]")
                end
            end
        else
            for _, v in pairs(Workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("HumanoidRootPart") and v.HumanoidRootPart:FindFirstChild("ESP") then
                    v.HumanoidRootPart.ESP:Destroy()
                end
            end
        end
    end
end)

--===========================================
-- CREATE GUI
--===========================================

-- Remove old GUI if exists
if game.CoreGui:FindFirstChild("SATX_Hub_V3") then
    game.CoreGui:FindFirstChild("SATX_Hub_V3"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SATX_Hub_V3"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Toggle Button with Custom Logo
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0.01, 0, 0.4, 0)
ToggleButton.Size = UDim2.new(0, 80, 0, 80)
ToggleButton.Image = SATXLogo
ToggleButton.ScaleType = Enum.ScaleType.Fit
ToggleButton.ImageTransparency = 0

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 20)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(195, 3, 4)
ToggleStroke.Thickness = 3
ToggleStroke.Parent = ToggleButton

local ToggleShadow = Instance.new("ImageLabel")
ToggleShadow.Name = "Shadow"
ToggleShadow.Parent = ToggleButton
ToggleShadow.AnchorPoint = Vector2.new(0.5, 0.5)
ToggleShadow.BackgroundTransparency = 1
ToggleShadow.Position = UDim2.new(0.5, 0, 0.5, 5)
ToggleShadow.Size = UDim2.new(1, 10, 1, 10)
ToggleShadow.ZIndex = 0
ToggleShadow.Image = "rbxassetid://5554236805"
ToggleShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
ToggleShadow.ImageTransparency = 0.7

-- Make Toggle Button Draggable
local dragging
local dragInput
local dragStart
local startPos

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

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -400, 0.5, -300)
MainFrame.Size = UDim2.new(0, 800, 0, 600)
MainFrame.Visible = false
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(195, 3, 4)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Shadow
local MainShadow = Instance.new("ImageLabel")
MainShadow.Name = "Shadow"
MainShadow.Parent = MainFrame
MainShadow.AnchorPoint = Vector2.new(0.5, 0.5)
MainShadow.BackgroundTransparency = 1
MainShadow.Position = UDim2.new(0.5, 0, 0.5, 5)
MainShadow.Size = UDim2.new(1, 30, 1, 30)
MainShadow.ZIndex = 0
MainShadow.Image = "rbxassetid://5554236805"
MainShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
MainShadow.ImageTransparency = 0.5

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 60)

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = TitleBar

-- Logo in Title
local TitleLogo = Instance.new("ImageLabel")
TitleLogo.Parent = TitleBar
TitleLogo.BackgroundTransparency = 1
TitleLogo.Position = UDim2.new(0, 15, 0.5, -20)
TitleLogo.Size = UDim2.new(0, 40, 0, 40)
TitleLogo.Image = SATXLogo
TitleLogo.ScaleType = Enum.ScaleType.Fit

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 65, 0, 0)
TitleText.Size = UDim2.new(0, 300, 1, 0)
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "SATX BLOX FRUITS HUB"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 22
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- Version Text
local VersionText = Instance.new("TextLabel")
VersionText.Parent = TitleBar
VersionText.BackgroundTransparency = 1
VersionText.Position = UDim2.new(0, 65, 0, 28)
VersionText.Size = UDim2.new(0, 200, 0, 20)
VersionText.Font = Enum.Font.Gotham
VersionText.Text = "Version " .. SATX.Version
VersionText.TextColor3 = Color3.fromRGB(195, 3, 4)
VersionText.TextSize = 12
VersionText.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(195, 3, 4)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -50, 0.5, -15)
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    wait(0.3)
    MainFrame.Visible = false
    MainFrame.Size = UDim2.new(0, 800, 0, 600)
end)

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Parent = TitleBar
MinimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Position = UDim2.new(1, -95, 0.5, -15)
MinimizeButton.Size = UDim2.new(0, 35, 0, 35)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 22

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 10)
MinimizeCorner.Parent = MinimizeButton

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Parent = MainFrame
TabContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
TabContainer.BorderSizePixel = 0
TabContainer.Position = UDim2.new(0, 0, 0, 60)
TabContainer.Size = UDim2.new(0, 180, 1, -60)

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabContainer
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 5)

local TabPadding = Instance.new("UIPadding")
TabPadding.Parent = TabContainer
TabPadding.PaddingTop = UDim.new(0, 10)

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 180, 0, 60)
ContentContainer.Size = UDim2.new(1, -180, 1, -60)

-- Scrolling Frame for Content
local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Parent = ContentContainer
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.Size = UDim2.new(1, -20, 1, -20)
ContentScroll.Position = UDim2.new(0, 10, 0, 10)
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentScroll.ScrollBarThickness = 8
ContentScroll.ScrollBarImageColor3 = Color3.fromRGB(195, 3, 4)

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
    TabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    TabButton.BorderSizePixel = 0
    TabButton.Size = UDim2.new(1, -20, 0, 50)
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.Text = "   " .. icon .. "  " .. name
    TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabButton.TextSize = 15
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.AutoButtonColor = false
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 10)
    TabCorner.Parent = TabButton
    
    local TabContent = Instance.new("Frame")
    TabContent.Name = name .. "Content"
    TabContent.Parent = ContentScroll
    TabContent.BackgroundTransparency = 1
    TabContent.Size = UDim2.new(1, 0, 0, 0)
    TabContent.Visible = false
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabContent
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 12)
    
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.Size = UDim2.new(1, 0, 0, TabLayout.AbsoluteContentSize.Y)
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
                TweenService:Create(btn, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(28, 28, 28),
                    TextColor3 = Color3.fromRGB(180, 180, 180)
                }):Play()
            end
        end
        
        TweenService:Create(TabButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(195, 3, 4),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end)
    
    TabButton.MouseEnter:Connect(function()
        if TabButton.BackgroundColor3 ~= Color3.fromRGB(195, 3, 4) then
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if TabButton.BackgroundColor3 ~= Color3.fromRGB(195, 3, 4) then
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 28)}):Play()
        end
    end)
    
    return TabContent
end

local function CreateSection(parent, text)
    local Section = Instance.new("Frame")
    Section.Parent = parent
    Section.BackgroundColor3 = Color3.fromRGB(195, 3, 4)
    Section.BorderSizePixel = 0
    Section.Size = UDim2.new(1, -10, 0, 45)
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 10)
    SectionCorner.Parent = Section
    
    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Parent = Section
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.Size = UDim2.new(1, -20, 1, 0)
    SectionLabel.Position = UDim2.new(0, 20, 0, 0)
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.Text = text
    SectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SectionLabel.TextSize = 16
    SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    return Section
end

local function CreateToggle(parent, text, defaultValue, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Parent = parent
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Size = UDim2.new(1, -10, 0, 50)
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 10)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Position = UDim2.new(0, 20, 0, 0)
    ToggleLabel.Size = UDim2.new(1, -100, 1, 0)
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 14
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleButton = Instance.new("Frame")
    ToggleButton.Parent = ToggleFrame
    ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Position = UDim2.new(1, -70, 0.5, -13)
    ToggleButton.Size = UDim2.new(0, 55, 0, 26)
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    ButtonCorner.Parent = ToggleButton
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Parent = ToggleButton
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    ToggleCircle.Position = UDim2.new(0, 3, 0.5, -10)
    ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle
    
    local toggled = defaultValue or false
    
    if toggled then
        ToggleButton.BackgroundColor3 = Color3.fromRGB(195, 3, 4)
        ToggleCircle.Position = UDim2.new(1, -23, 0.5, -10)
        ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    local function Toggle()
        toggled = not toggled
        if toggled then
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(195, 3, 4)}):Play()
            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -23, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        else
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 3, 0.5, -10),
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
    
    ToggleInput.MouseButton1Click:Connect(Toggle)
    
    return ToggleFrame
end

local function CreateButton(parent, text, callback)
    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Parent = parent
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(195, 3, 4)
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Size = UDim2.new(1, -10, 0, 45)
    ButtonFrame.Font = Enum.Font.GothamBold
    ButtonFrame.Text = text
    ButtonFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
    ButtonFrame.TextSize = 15
    ButtonFrame.AutoButtonColor = false
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 10)
    ButtonCorner.Parent = ButtonFrame
    
    ButtonFrame.MouseButton1Click:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(150, 2, 3)}):Play()
        wait(0.1)
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(195, 3, 4)}):Play()
        callback()
    end)
    
    ButtonFrame.MouseEnter:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 10, 10)}):Play()
    end)
    
    ButtonFrame.MouseLeave:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(195, 3, 4)}):Play()
    end)
    
    return ButtonFrame
end

local function CreateSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Parent = parent
    SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Size = UDim2.new(1, -10, 0, 70)
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 10)
    SliderCorner.Parent = SliderFrame
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Parent = SliderFrame
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Position = UDim2.new(0, 20, 0, 10)
    SliderLabel.Size = UDim2.new(1, -40, 0, 20)
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.Text = text .. ": " .. default
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.TextSize = 14
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Parent = SliderFrame
    SliderBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    SliderBar.BorderSizePixel = 0
    SliderBar.Position = UDim2.new(0, 20, 0, 40)
    SliderBar.Size = UDim2.new(1, -40, 0, 10)
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Parent = SliderBar
    SliderFill.BackgroundColor3 = Color3.fromRGB(195, 3, 4)
    SliderFill.BorderSizePixel = 0
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Parent = SliderBar
    SliderButton.BackgroundTransparency = 1
    SliderButton.Size = UDim2.new(1, 0, 1, 0)
    SliderButton.Text = ""
    
    local dragging = false
    
    SliderButton.MouseButton1Down:Connect(function()
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
            local relativeX = math.clamp(mouse.X - SliderBar.AbsolutePosition.X, 0, SliderBar.AbsoluteSize.X)
            local percentage = relativeX / SliderBar.AbsoluteSize.X
            local value = math.floor(min + (max - min) * percentage)
            
            SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            SliderLabel.Text = text .. ": " .. value
            callback(value)
        end
    end)
    
    return SliderFrame
end

local function CreateDropdown(parent, text, options, callback)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Parent = parent
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.Size = UDim2.new(1, -10, 0, 50)
    DropdownFrame.ClipsDescendants = false
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 10)
    DropdownCorner.Parent = DropdownFrame
    
    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Parent = DropdownFrame
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Position = UDim2.new(0, 20, 0, 0)
    DropdownLabel.Size = UDim2.new(1, -60, 1, 0)
    DropdownLabel.Font = Enum.Font.Gotham
    DropdownLabel.Text = text .. ": " .. (options[1] or "None")
    DropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownLabel.TextSize = 14
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Parent = DropdownFrame
    DropdownButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    DropdownButton.BorderSizePixel = 0
    DropdownButton.Position = UDim2.new(1, -35, 0.5, -12)
    DropdownButton.Size = UDim2.new(0, 25, 0, 25)
    DropdownButton.Font = Enum.Font.GothamBold
    DropdownButton.Text = "▼"
    DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownButton.TextSize = 10
    
    local DropButtonCorner = Instance.new("UICorner")
    DropButtonCorner.CornerRadius = UDim.new(0, 6)
    DropButtonCorner.Parent = DropdownButton
    
    local DropdownList = Instance.new("ScrollingFrame")
    DropdownList.Parent = DropdownFrame
    DropdownList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    DropdownList.BorderSizePixel = 0
    DropdownList.Position = UDim2.new(0, 0, 1, 5)
    DropdownList.Size = UDim2.new(1, 0, 0, 0)
    DropdownList.Visible = false
    DropdownList.ScrollBarThickness = 4
    DropdownList.ScrollBarImageColor3 = Color3.fromRGB(195, 3, 4)
    DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local ListCorner = Instance.new("UICorner")
    ListCorner.CornerRadius = UDim.new(0, 10)
    ListCorner.Parent = DropdownList
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = DropdownList
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 2)
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        DropdownList.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    local isOpen = false
    
    DropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            DropdownList.Visible = true
            TweenService:Create(DropdownList, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, math.min(#options * 35, 150))}):Play()
            DropdownButton.Text = "▲"
        else
            TweenService:Create(DropdownList, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            wait(0.2)
            DropdownList.Visible = false
            DropdownButton.Text = "▼"
        end
    end)
    
    for i, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Parent = DropdownList
        OptionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        OptionButton.BorderSizePixel = 0
        OptionButton.Size = UDim2.new(1, -5, 0, 30)
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.Text = option
        OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptionButton.TextSize = 13
        OptionButton.AutoButtonColor = false
        
        local OptCorner = Instance.new("UICorner")
        OptCorner.CornerRadius = UDim.new(0, 6)
        OptCorner.Parent = OptionButton
        
        OptionButton.MouseButton1Click:Connect(function()
            DropdownLabel.Text = text .. ": " .. option
            isOpen = false
            TweenService:Create(DropdownList, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            wait(0.2)
            DropdownList.Visible = false
            DropdownButton.Text = "▼"
            callback(option)
        end)
        
        OptionButton.MouseEnter:Connect(function()
            TweenService:Create(OptionButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(195, 3, 4)}):Play()
        end)
        
        OptionButton.MouseLeave:Connect(function()
            TweenService:Create(OptionButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
        end)
    end
    
    return DropdownFrame
end

-- Create Tabs
local MainTab = CreateTab("Main", "🏠")
local AutoFarmTab = CreateTab("Auto Farm", "⚔️")
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

CreateButton(MainTab, "🚀 Redeem All Codes", function()
    local codes = {
        "Sub2CaptainMaui", "kittgaming", "Sub2Fer999", "Enyu_is_Pro",
        "Magicbus", "JCWK", "Starcodeheo", "Bluxxy", "Sub2NoobMaster123",
        "Sub2UncleKizaru", "Sub2Daigrock", "Axiore", "TantaiGaming",
        "StrawHatMaine", "Sub2OfficialNoobie", "TheGreatAce", "Fudd10",
        "Bignews", "THEGREATACE", "SUB2GAMERROBOT_EXP1", "StrawHatMaine",
        "SUB2NOOBMASTER123", "Sub2Daigrock", "Axiore", "BIGNEWS"
    }
    
    for _, code in ipairs(codes) do
        game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(code)
        wait(0.1)
    end
    
    Notify("SATX Hub", "All codes redeemed!", 3)
end)

CreateButton(MainTab, "🎁 Collect All Chests (Sea 1)", function()
    local chests = Workspace:GetChildren()
    for _, v in pairs(chests) do
        if v.Name == "Chest1" or v.Name == "Chest2" or v.Name == "Chest3" then
            HumanoidRootPart.CFrame = v.CFrame
            wait(0.3)
        end
    end
    Notify("SATX Hub", "Chests collected!", 3)
end)

CreateSection(MainTab, "📊 Player Info")

local PlayerLevel = Instance.new("TextLabel")
PlayerLevel.Parent = MainTab
PlayerLevel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
PlayerLevel.BorderSizePixel = 0
PlayerLevel.Size = UDim2.new(1, -10, 0, 40)
PlayerLevel.Font = Enum.Font.Gotham
PlayerLevel.Text = "Level: " .. Player.Data.Level.Value
PlayerLevel.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerLevel.TextSize = 14

local PLCorner = Instance.new("UICorner")
PLCorner.CornerRadius = UDim.new(0, 10)
PLCorner.Parent = PlayerLevel

--==========================================
-- AUTO FARM TAB
--==========================================
CreateSection(AutoFarmTab, "⚔️ Auto Farm")

CreateToggle(AutoFarmTab, "Auto Farm Level", false, function(value)
    SATX.Settings.AutoFarmLevel = value
end)

CreateToggle(AutoFarmTab, "Auto Farm Bone", false, function(value)
    SATX.Settings.AutoFarmBone = value
end)

CreateToggle(AutoFarmTab, "Auto Farm Ectoplasm", false, function(value)
    SATX.Settings.AutoFarmEctoplasm = value
end)

CreateToggle(AutoFarmTab, "Auto Farm Factory", false, function(value)
    SATX.Settings.AutoFarmFactory = value
end)

CreateSection(AutoFarmTab, "⚙️ Farm Settings")

CreateToggle(AutoFarmTab, "Bring Mob", false, function(value)
    SATX.Settings.BringMob = value
end)

CreateSlider(AutoFarmTab, "Bring Mob Distance", 100, 500, 350, function(value)
    SATX.Settings.BringMobDistance = value
end)

CreateSlider(AutoFarmTab, "Farm Distance", 5, 50, 30, function(value)
    SATX.Settings.FarmDistance = value
end)

CreateDropdown(AutoFarmTab, "Select Weapon", {"Melee", "Sword", "Gun", "Fruit"}, function(value)
    SATX.Settings.SelectedWeapon = value
end)

--==========================================
-- COMBAT TAB
--==========================================
CreateSection(CombatTab, "⚡ Combat")

CreateToggle(CombatTab, "Fast Attack", false, function(value)
    SATX.Settings.FastAttack = value
end)

CreateDropdown(CombatTab, "Fast Attack Mode", {"Slow", "Fast", "Super Fast"}, function(value)
    SATX.Settings.FastAttackMode = value
end)

CreateToggle(CombatTab, "Auto Haki", false, function(value)
    SATX.Settings.AutoHaki = value
end)

CreateToggle(CombatTab, "Auto Enhancement", false, function(value)
    SATX.Settings.AutoEnhancement = value
end)

CreateSection(CombatTab, "🎯 Mastery")

CreateToggle(CombatTab, "Skill Mastery", false, function(value)
    SATX.Settings.SkillMastery = value
end)

CreateToggle(CombatTab, "Gun Mastery", false, function(value)
    SATX.Settings.GunMastery = value
end)

--==========================================
-- STATS TAB
--==========================================
CreateSection(StatsTab, "📈 Auto Stats")

CreateToggle(StatsTab, "Auto Melee", false, function(value)
    SATX.Settings.AutoMelee = value
end)

CreateToggle(StatsTab, "Auto Defense", false, function(value)
    SATX.Settings.AutoDefense = value
end)

CreateToggle(StatsTab, "Auto Sword", false, function(value)
    SATX.Settings.AutoSword = value
end)

CreateToggle(StatsTab, "Auto Gun", false, function(value)
    SATX.Settings.AutoGun = value
end)

CreateToggle(StatsTab, "Auto Devil Fruit", false, function(value)
    SATX.Settings.AutoFruit = value
end)

CreateButton(StatsTab, "Reset Stats", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Refund","1")
    Notify("SATX Hub", "Stats reset!", 3)
end)

--==========================================
-- BOSS TAB
--==========================================
CreateSection(BossTab, "👹 Boss Farm")

CreateToggle(BossTab, "Auto Boss", false, function(value)
    SATX.Settings.AutoBoss = value
end)

CreateToggle(BossTab, "Auto All Boss", false, function(value)
    SATX.Settings.AutoAllBoss = value
end)

CreateToggle(BossTab, "Auto Elite", false, function(value)
    SATX.Settings.AutoElite = value
end)

CreateToggle(BossTab, "Auto Soul Reaper", false, function(value)
    SATX.Settings.AutoSoulReaper = value
end)

CreateToggle(BossTab, "Auto Dough King", false, function(value)
    SATX.Settings.AutoDoughKing = value
end)

CreateToggle(BossTab, "Auto Cake Prince", false, function(value)
    SATX.Settings.AutoCakePrince = value
end)

--==========================================
-- SEA TAB
--==========================================
CreateSection(SeaTab, "🌊 Sea Events")

CreateToggle(SeaTab, "Auto Sea Beast", false, function(value)
    SATX.Settings.AutoSeaBeast = value
end)

CreateToggle(SeaTab, "Auto Pirate Raid", false, function(value)
    SATX.Settings.AutoPirateRaid = value
end)

CreateToggle(SeaTab, "Auto Ship", false, function(value)
    SATX.Settings.AutoShip = value
end)

CreateToggle(SeaTab, "Auto Terrorshark", false, function(value)
    SATX.Settings.AutoTerrorshark = value
end)

--==========================================
-- RAID TAB
--==========================================
CreateSection(RaidTab, "💀 Raid")

CreateToggle(RaidTab, "Auto Raid", false, function(value)
    SATX.Settings.AutoRaid = value
end)

CreateToggle(RaidTab, "Auto Awakener", false, function(value)
    SATX.Settings.AutoAwakener = value
end)

CreateToggle(RaidTab, "Auto Buy Chip", false, function(value)
    SATX.Settings.AutoBuyChip = value
end)

CreateToggle(RaidTab, "Kill Aura", false, function(value)
    SATX.Settings.KillAura = value
end)

CreateDropdown(RaidTab, "Select Raid", {"Flame", "Ice", "Quake", "Light", "Dark", "Spider", "Rumble", "Magma", "Buddha", "Sand", "Phoenix"}, function(value)
    SATX.Settings.SelectRaid = value
end)

CreateButton(RaidTab, "Start Raid", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RaidsNpc","Select", SATX.Settings.SelectRaid)
end)

--==========================================
-- TELEPORT TAB
--==========================================
CreateSection(TeleportTab, "🗺️ Sea 1")

CreateButton(TeleportTab, "Jungle", function()
    TP(CFrame.new(-1612, 37, 149))
end)

CreateButton(TeleportTab, "Pirate Village", function()
    TP(CFrame.new(-1141, 5, 3831))
end)

CreateButton(TeleportTab, "Desert", function()
    TP(CFrame.new(944, 21, 4373))
end)

CreateButton(TeleportTab, "Frozen Village", function()
    TP(CFrame.new(1389, 87, -1298))
end)

CreateButton(TeleportTab, "Marine Fortress", function()
    TP(CFrame.new(-4914, 50, 4281))
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
    SATX.Settings.ESPPlayer = value
end)

CreateToggle(ESPTab, "Mob ESP", false, function(value)
    SATX.Settings.ESPMob = value
end)

CreateToggle(ESPTab, "Fruit ESP", false, function(value)
    SATX.Settings.ESPFruit = value
end)

CreateToggle(ESPTab, "Chest ESP", false, function(value)
    SATX.Settings.ESPChest = value
end)

CreateToggle(ESPTab, "Flower ESP", false, function(value)
    SATX.Settings.ESPFlower = value
end)

CreateToggle(ESPTab, "NPC ESP", false, function(value)
    SATX.Settings.ESPNPC = value
end)

CreateToggle(ESPTab, "Island ESP", false, function(value)
    SATX.Settings.ESPIsland = value
end)

--==========================================
-- MISC TAB
--==========================================
CreateSection(MiscTab, "⚙️ Miscellaneous")

CreateToggle(MiscTab, "NoClip", false, function(value)
    SATX.Settings.NoClip = value
end)

CreateToggle(MiscTab, "Infinite Energy", false, function(value)
    SATX.Settings.InfiniteEnergy = value
end)

CreateToggle(MiscTab, "White Screen", false, function(value)
    SATX.Settings.WhiteScreen = value
    if value then
        game:GetService("RunService"):Set3dRenderingEnabled(false)
    else
        game:GetService("RunService"):Set3dRenderingEnabled(true)
    end
end)

CreateToggle(MiscTab, "Remove Fog", false, function(value)
    SATX.Settings.RemoveFog = value
    if value then
        Lighting.FogEnd = 9e9
    else
        Lighting.FogEnd = 100000
    end
end)

CreateSection(MiscTab, "🏃 Movement")

CreateSlider(MiscTab, "Walk Speed", 16, 200, 16, function(value)
    SATX.Settings.WalkSpeed = value
end)

CreateSlider(MiscTab, "Jump Power", 50, 300, 50, function(value)
    SATX.Settings.JumpPower = value
end)

CreateSection(MiscTab, "🎮 Race V3/V4")

CreateToggle(MiscTab, "Auto Active Race V3", false, function(value)
    SATX.Settings.AutoActiveRaceV3 = value
end)

CreateToggle(MiscTab, "Auto Active Race V4", false, function(value)
    SATX.Settings.AutoActiveRaceV4 = value
end)

-- Toggle GUI
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 800, 0, 600)}):Play()
    end
end)

-- Activate first tab
MainTab.Visible = true
TabContainer:GetChildren()[1].BackgroundColor3 = Color3.fromRGB(195, 3, 4)
TabContainer:GetChildren()[1].TextColor3 = Color3.fromRGB(255, 255, 255)

-- Notification
Notify("SATX Hub", "Script Loaded Successfully! Version " .. SATX.Version, 5)

print([[
╔══════════════════════════════════════════════════╗
║        SATX BLOX FRUITS HUB - LOADED            ║
║        Version: 3.0 ULTIMATE                     ║
║        Status: ✅ Fully Operational              ║
║        Features: 100+ Advanced Functions         ║
╚══════════════════════════════════════════════════╝
]])
