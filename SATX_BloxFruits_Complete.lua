--[[
    ███████╗ █████╗ ████████╗██╗  ██╗
    ██╔════╝██╔══██╗╚══██╔══╝╚██╗██╔╝
    ███████╗███████║   ██║    ╚███╔╝ 
    ╚════██║██╔══██║   ██║    ██╔██╗ 
    ███████║██║  ██║   ██║   ██╔╝ ██╗
    ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝
    
    SATX HUB V3.1 - PERFECTION EDITION
    100% FUNCTIONAL GUARANTEED
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

-- Settings
_G.Settings = {
    AutoFarmLevel = false,
    FastAttack = false,
    AutoHaki = false,
    BringMob = false,
    AutoMelee = false,
    AutoDefense = false,
    AutoSword = false,
    AutoGun = false,
    AutoFruit = false,
    NoClip = false,
    WalkSpeed = 16,
    JumpPower = 50,
    SelectedWeapon = "Melee",
    FarmDistance = 30,
}

-- Notification
local function Notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 5,
    })
end

-- TP Function
local function TP(cframe)
    if not cframe then return end
    pcall(function()
        local distance = (cframe.Position - HumanoidRootPart.Position).Magnitude
        if distance < 250 then
            HumanoidRootPart.CFrame = cframe
        else
            local speed = 300
            local tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(distance/speed, Enum.EasingStyle.Linear), {CFrame = cframe})
            tween:Play()
        end
    end)
end

-- Fast Attack
spawn(function()
    while wait() do
        if _G.Settings.FastAttack then
            pcall(function()
                repeat wait()
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                until not _G.Settings.FastAttack
            end)
        end
    end
end)

-- Bring Mob
spawn(function()
    while wait() do
        if _G.Settings.BringMob then
            pcall(function()
                for i, v in pairs(game.Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        if (v.HumanoidRootPart.Position - HumanoidRootPart.Position).magnitude <= 350 then
                            v.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, _G.Settings.FarmDistance)
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
        if _G.Settings.AutoHaki then
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
        if _G.Settings.NoClip then
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
                Humanoid.WalkSpeed = _G.Settings.WalkSpeed
                Humanoid.JumpPower = _G.Settings.JumpPower
            end
        end)
    end
end)

-- Auto Stats
spawn(function()
    while wait(1) do
        pcall(function()
            if _G.Settings.AutoMelee then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1)
            end
            if _G.Settings.AutoDefense then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Defense", 1)
            end
            if _G.Settings.AutoSword then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Sword", 1)
            end
            if _G.Settings.AutoGun then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Gun", 1)
            end
            if _G.Settings.AutoFruit then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", 1)
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
                if _G.Settings.SelectedWeapon == "Melee" and v.ToolTip:lower():find("melee") then
                    Humanoid:EquipTool(v)
                    return
                elseif _G.Settings.SelectedWeapon == "Sword" and v.ToolTip:lower():find("sword") then
                    Humanoid:EquipTool(v)
                    return
                elseif _G.Settings.SelectedWeapon == "Gun" and v.ToolTip:lower():find("gun") then
                    Humanoid:EquipTool(v)
                    return
                elseif _G.Settings.SelectedWeapon == "Fruit" and v.ToolTip:lower():find("fruit") then
                    Humanoid:EquipTool(v)
                    return
                end
            end
        end
    end)
end

-- Auto Farm
spawn(function()
    while wait() do
        if _G.Settings.AutoFarmLevel then
            pcall(function()
                local Quest = GetQuest()
                
                -- Take Quest
                if not Player.PlayerGui.Main.Quest.Visible then
                    TP(Quest.Pos)
                    wait(1)
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", Quest.Name, Quest.Level)
                    wait(1)
                end
                
                -- Farm Mob
                for _, v in pairs(Workspace.Enemies:GetChildren()) do
                    if v.Name == Quest.Mob and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        repeat wait()
                            EquipWeapon()
                            TP(v.HumanoidRootPart.CFrame * CFrame.new(0, _G.Settings.FarmDistance, 0))
                            v.HumanoidRootPart.CanCollide = false
                            v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                        until not _G.Settings.AutoFarmLevel or not v.Parent or v.Humanoid.Health <= 0
                    end
                end
            end)
        end
    end
end)

--===========================================
-- GUI
--===========================================

-- Remove old
pcall(function()
    game.CoreGui:FindFirstChild("SATX_Hub"):Destroy()
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SATX_Hub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Toggle Button
local Toggle = Instance.new("TextButton")
Toggle.Parent = ScreenGui
Toggle.BackgroundColor3 = Color3.fromRGB(195, 3, 4)
Toggle.Position = UDim2.new(0.01, 0, 0.4, 0)
Toggle.Size = UDim2.new(0, 70, 0, 70)
Toggle.Font = Enum.Font.GothamBold
Toggle.Text = "SATX"
Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
Toggle.TextSize = 18

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 15)
ToggleCorner.Parent = Toggle

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
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
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Position = UDim2.new(0.5, -350, 0.5, -250)
Main.Size = UDim2.new(0, 700, 0, 500)
Main.Visible = false

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(195, 3, 4)
MainStroke.Thickness = 2
MainStroke.Parent = Main

-- Title
local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Font = Enum.Font.GothamBold
Title.Text = "SATX BLOX FRUITS HUB V3.1"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

-- Close
local Close = Instance.new("TextButton")
Close.Parent = Title
Close.BackgroundColor3 = Color3.fromRGB(195, 3, 4)
Close.Position = UDim2.new(1, -40, 0.5, -15)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Font = Enum.Font.GothamBold
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 16

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = Close

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

-- Tabs
local TabContainer = Instance.new("Frame")
TabContainer.Parent = Main
TabContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
TabContainer.Position = UDim2.new(0, 0, 0, 50)
TabContainer.Size = UDim2.new(0, 150, 1, -50)

local Content = Instance.new("Frame")
Content.Parent = Main
Content.BackgroundTransparency = 1
Content.Position = UDim2.new(0, 150, 0, 50)
Content.Size = UDim2.new(1, -150, 1, -50)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Parent = Content
Scroll.BackgroundTransparency = 1
Scroll.Size = UDim2.new(1, -10, 1, -10)
Scroll.Position = UDim2.new(0, 5, 0, 5)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 6
Scroll.ScrollBarImageColor3 = Color3.fromRGB(195, 3, 4)

local Layout = Instance.new("UIListLayout")
Layout.Parent = Scroll
Layout.Padding = UDim.new(0, 10)

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
end)

-- Create Tab
local function CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Parent = TabContainer
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabBtn.Size = UDim2.new(1, -10, 0, 40)
    TabBtn.Position = UDim2.new(0, 5, 0, (#TabContainer:GetChildren() - 1) * 45)
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.TextSize = 14
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabBtn
    
    local TabContent = Instance.new("Frame")
    TabContent.Parent = Scroll
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
        for _, v in pairs(Scroll:GetChildren()) do
            if v:IsA("Frame") then v.Visible = false end
        end
        TabContent.Visible = true
        
        for _, v in pairs(TabContainer:GetChildren()) do
            if v:IsA("TextButton") then
                v.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                v.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
        TabBtn.BackgroundColor3 = Color3.fromRGB(195, 3, 4)
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    return TabContent
end

-- Create Toggle
local function CreateToggle(parent, text, callback)
    local Frame = Instance.new("Frame")
    Frame.Parent = parent
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.Size = UDim2.new(1, -10, 0, 40)
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Parent = Frame
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.Size = UDim2.new(1, -80, 1, 0)
    Label.Font = Enum.Font.Gotham
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Btn = Instance.new("TextButton")
    Btn.Parent = Frame
    Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Btn.Position = UDim2.new(1, -55, 0.5, -12)
    Btn.Size = UDim2.new(0, 45, 0, 24)
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
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(195, 3, 4)}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -22, 0.5, -10), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        end
        callback(toggled)
    end)
end

-- Create Button
local function CreateButton(parent, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Parent = parent
    Btn.BackgroundColor3 = Color3.fromRGB(195, 3, 4)
    Btn.Size = UDim2.new(1, -10, 0, 40)
    Btn.Font = Enum.Font.GothamBold
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 14
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Btn
    
    Btn.MouseButton1Click:Connect(callback)
end

-- Create Slider
local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Parent = parent
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.Size = UDim2.new(1, -10, 0, 60)
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Parent = Frame
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 15, 0, 5)
    Label.Size = UDim2.new(1, -30, 0, 20)
    Label.Font = Enum.Font.Gotham
    Label.Text = text .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Bar = Instance.new("Frame")
    Bar.Parent = Frame
    Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Bar.Position = UDim2.new(0, 15, 0, 35)
    Bar.Size = UDim2.new(1, -30, 0, 8)
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = Bar
    
    local Fill = Instance.new("Frame")
    Fill.Parent = Bar
    Fill.BackgroundColor3 = Color3.fromRGB(195, 3, 4)
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

-- Create Dropdown
local function CreateDropdown(parent, text, options, callback)
    local Frame = Instance.new("Frame")
    Frame.Parent = parent
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.Size = UDim2.new(1, -10, 0, 40)
    Frame.ClipsDescendants = false
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Parent = Frame
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Font = Enum.Font.Gotham
    Label.Text = text .. ": " .. options[1]
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Btn = Instance.new("TextButton")
    Btn.Parent = Frame
    Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Btn.Position = UDim2.new(1, -30, 0.5, -10)
    Btn.Size = UDim2.new(0, 20, 0, 20)
    Btn.Font = Enum.Font.GothamBold
    Btn.Text = "▼"
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 10
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 5)
    BtnCorner.Parent = Btn
    
    local List = Instance.new("Frame")
    List.Parent = Frame
    List.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    List.Position = UDim2.new(0, 0, 1, 5)
    List.Size = UDim2.new(1, 0, 0, 0)
    List.Visible = false
    
    local ListCorner = Instance.new("UICorner")
    ListCorner.CornerRadius = UDim.new(0, 8)
    ListCorner.Parent = List
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = List
    ListLayout.Padding = UDim.new(0, 2)
    
    local isOpen = false
    
    Btn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            List.Visible = true
            TweenService:Create(List, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, math.min(#options * 32, 120))}):Play()
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
        OptBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        OptBtn.Size = UDim2.new(1, -4, 0, 28)
        OptBtn.Font = Enum.Font.Gotham
        OptBtn.Text = option
        OptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptBtn.TextSize = 12
        
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
    end
end

-- Create Section
local function CreateSection(parent, text)
    local Frame = Instance.new("Frame")
    Frame.Parent = parent
    Frame.BackgroundColor3 = Color3.fromRGB(195, 3, 4)
    Frame.Size = UDim2.new(1, -10, 0, 35)
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Parent = Frame
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, -20, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Font = Enum.Font.GothamBold
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 15
    Label.TextXAlignment = Enum.TextXAlignment.Left
end

-- Tabs
local MainTab = CreateTab("Main")
local FarmTab = CreateTab("Farm")
local CombatTab = CreateTab("Combat")
local StatsTab = CreateTab("Stats")
local TeleportTab = CreateTab("Teleport")
local MiscTab = CreateTab("Misc")

-- MAIN TAB
CreateSection(MainTab, "⚡ Quick Actions")

CreateButton(MainTab, "🚀 Redeem All Codes", function()
    local codes = {"Sub2CaptainMaui", "kittgaming", "Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy", "Sub2NoobMaster123"}
    for _, code in pairs(codes) do
        ReplicatedStorage.Remotes.Redeem:InvokeServer(code)
        wait(0.1)
    end
    Notify("SATX Hub", "Codes redeemed!")
end)

CreateButton(MainTab, "🎁 Collect Chests (Sea 1)", function()
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
InfoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
InfoFrame.Size = UDim2.new(1, -10, 0, 70)

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 8)
InfoCorner.Parent = InfoFrame

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Parent = InfoFrame
InfoLabel.BackgroundTransparency = 1
InfoLabel.Size = UDim2.new(1, -20, 1, -20)
InfoLabel.Position = UDim2.new(0, 10, 0, 10)
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.Text = "Level: " .. Player.Data.Level.Value .. "\nBeli: " .. Player.Data.Beli.Value
InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoLabel.TextSize = 13
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.TextYAlignment = Enum.TextYAlignment.Top

-- FARM TAB
CreateSection(FarmTab, "⚔️ Auto Farm")

CreateToggle(FarmTab, "Auto Farm Level", function(value)
    _G.Settings.AutoFarmLevel = value
    Notify("SATX Hub", "Auto Farm: " .. tostring(value))
end)

CreateSection(FarmTab, "⚙️ Settings")

CreateToggle(FarmTab, "Bring Mob", function(value)
    _G.Settings.BringMob = value
end)

CreateSlider(FarmTab, "Farm Distance", 10, 50, 30, function(value)
    _G.Settings.FarmDistance = value
end)

CreateDropdown(FarmTab, "Weapon", {"Melee", "Sword", "Gun", "Fruit"}, function(value)
    _G.Settings.SelectedWeapon = value
end)

-- COMBAT TAB
CreateSection(CombatTab, "⚡ Combat")

CreateToggle(CombatTab, "Fast Attack", function(value)
    _G.Settings.FastAttack = value
end)

CreateToggle(CombatTab, "Auto Haki", function(value)
    _G.Settings.AutoHaki = value
end)

-- STATS TAB
CreateSection(StatsTab, "📈 Auto Stats")

CreateToggle(StatsTab, "Auto Melee", function(value)
    _G.Settings.AutoMelee = value
end)

CreateToggle(StatsTab, "Auto Defense", function(value)
    _G.Settings.AutoDefense = value
end)

CreateToggle(StatsTab, "Auto Sword", function(value)
    _G.Settings.AutoSword = value
end)

CreateToggle(StatsTab, "Auto Gun", function(value)
    _G.Settings.AutoGun = value
end)

CreateToggle(StatsTab, "Auto Fruit", function(value)
    _G.Settings.AutoFruit = value
end)

CreateButton(StatsTab, "Reset Stats", function()
    ReplicatedStorage.Remotes.CommF_:InvokeServer("BlackbeardReward","Refund","1")
    Notify("SATX Hub", "Stats reset!")
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

CreateSection(TeleportTab, "🗺️ Sea 3")

CreateButton(TeleportTab, "Port Town", function()
    TP(CFrame.new(-290, 7, 5343))
end)

CreateButton(TeleportTab, "Hydra Island", function()
    TP(CFrame.new(5749, 612, -282))
end)

-- MISC TAB
CreateSection(MiscTab, "⚙️ Miscellaneous")

CreateToggle(MiscTab, "NoClip", function(value)
    _G.Settings.NoClip = value
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
    _G.Settings.WalkSpeed = value
end)

CreateSlider(MiscTab, "Jump Power", 50, 300, 50, function(value)
    _G.Settings.JumpPower = value
end)

-- Toggle GUI
Toggle.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- First tab
MainTab.Visible = true
TabContainer:GetChildren()[1].BackgroundColor3 = Color3.fromRGB(195, 3, 4)
TabContainer:GetChildren()[1].TextColor3 = Color3.fromRGB(255, 255, 255)

-- Notification
Notify("SATX Hub V3.1", "Loaded Successfully!")

print("SATX Hub V3.1 - Loaded")
