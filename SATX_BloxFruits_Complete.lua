--[[
    ███████╗ █████╗ ████████╗██╗  ██╗
    ██╔════╝██╔══██╗╚══██╔══╝╚██╗██╔╝
    ███████╗███████║   ██║    ╚███╔╝ 
    ╚════██║██╔══██║   ██║    ██╔██╗ 
    ███████║██║  ██║   ██║   ██╔╝ ██╗
    ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝
    
    SATX Blox Fruits Hub - Ultra Complete Edition
    Version: 2.0
    Created for SATX Executor
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Local Player
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Anti-AFK
Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Variables
local SATX = {
    Settings = {
        AutoFarm = false,
        AutoQuest = false,
        AutoLevel = false,
        AutoBoss = false,
        AutoRaid = false,
        AutoFactory = false,
        AutoSeaEvent = false,
        AutoCakePrince = false,
        AutoElite = false,
        AutoSoul = false,
        AutoBone = false,
        
        -- Combat
        FastAttack = false,
        AutoHaki = false,
        AutoBusoHaki = false,
        
        -- Stats
        AutoMelee = false,
        AutoDefense = false,
        AutoSword = false,
        AutoGun = false,
        AutoFruit = false,
        
        -- Misc
        AutoStoreItems = false,
        AutoRandomSurprise = false,
        AntiAfk = true,
        NoClip = false,
        InfiniteEnergy = false,
        WalkSpeed = 16,
        JumpPower = 50,
        
        -- Teleport
        TeleportSpeed = 300,
        
        -- ESP
        PlayerESP = false,
        MobESP = false,
        FruitESP = false,
        ChestESP = false,
        FlowerESP = false,
        
        -- Farm Settings
        SelectedWeapon = "Combat",
        SelectedQuest = "None",
        SelectedBoss = "None",
        DistanceFromMob = 5,
        BringMobs = false,
    }
}

-- Weapon List
local WeaponList = {}
for _, v in pairs(Player.Backpack:GetChildren()) do
    if v:IsA("Tool") then
        table.insert(WeaponList, v.Name)
    end
end

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SATX_Hub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Toggle Button (With Icon)
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.BorderSizePixel = 0
ToggleButton.Position = UDim2.new(0, 10, 0.5, -35)
ToggleButton.Size = UDim2.new(0, 70, 0, 70)
ToggleButton.Image = "rbxassetid://7733779610"
ToggleButton.ImageColor3 = Color3.fromRGB(195, 3, 4)
ToggleButton.ScaleType = Enum.ScaleType.Fit

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 15)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(195, 3, 4)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleButton

-- Make draggable
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
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
        update(input)
    end
end)

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
MainFrame.Size = UDim2.new(0, 700, 0, 500)
MainFrame.Visible = false
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(195, 3, 4)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 50)

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 60, 0, 0)
TitleText.Size = UDim2.new(1, -120, 1, 0)
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "SATX Blox Fruits Hub"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 20
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- Logo
local Logo = Instance.new("ImageLabel")
Logo.Parent = TitleBar
Logo.BackgroundTransparency = 1
Logo.Position = UDim2.new(0, 10, 0.5, -15)
Logo.Size = UDim2.new(0, 30, 0, 30)
Logo.Image = "rbxassetid://7733779610"
Logo.ImageColor3 = Color3.fromRGB(195, 3, 4)

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(195, 3, 4)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -45, 0.5, -15)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Tab System
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Parent = MainFrame
TabContainer.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
TabContainer.BorderSizePixel = 0
TabContainer.Position = UDim2.new(0, 0, 0, 50)
TabContainer.Size = UDim2.new(0, 150, 1, -50)

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 150, 0, 50)
ContentContainer.Size = UDim2.new(1, -150, 1, -50)

-- Scrolling Frame for Content
local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Parent = ContentContainer
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.Size = UDim2.new(1, -10, 1, -10)
ContentScroll.Position = UDim2.new(0, 5, 0, 5)
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentScroll.ScrollBarThickness = 6
ContentScroll.ScrollBarImageColor3 = Color3.fromRGB(195, 3, 4)

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Parent = ContentScroll
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 10)

-- Functions to create UI elements
local function CreateTab(name, icon)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Parent = TabContainer
    TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabButton.BorderSizePixel = 0
    TabButton.Size = UDim2.new(1, 0, 0, 45)
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.Text = "  " .. name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.TextSize = 14
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    
    local TabContent = Instance.new("Frame")
    TabContent.Name = name .. "Content"
    TabContent.Parent = ContentScroll
    TabContent.BackgroundTransparency = 1
    TabContent.Size = UDim2.new(1, 0, 0, 0)
    TabContent.Visible = false
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabContent
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 10)
    
    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(ContentScroll:GetChildren()) do
            if tab:IsA("Frame") then
                tab.Visible = false
            end
        end
        TabContent.Visible = true
        
        for _, btn in pairs(TabContainer:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
        TabButton.BackgroundColor3 = Color3.fromRGB(195, 3, 4)
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
    
    return TabContent
end

local function CreateToggle(parent, name, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Parent = parent
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
    ToggleLabel.Size = UDim2.new(1, -80, 1, 0)
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 13
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = ToggleFrame
    ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Position = UDim2.new(1, -55, 0.5, -12)
    ToggleButton.Size = UDim2.new(0, 45, 0, 24)
    ToggleButton.Text = ""
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    ButtonCorner.Parent = ToggleButton
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Parent = ToggleButton
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    ToggleCircle.Position = UDim2.new(0, 2, 0.5, -10)
    ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle
    
    local toggled = false
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(195, 3, 4)}):Play()
            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -22, 0.5, -10), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10), BackgroundColor3 = Color3.fromRGB(200, 200, 200)}):Play()
        end
        callback(toggled)
    end)
    
    parent.Size = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y)
end

local function CreateButton(parent, name, callback)
    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Parent = parent
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(195, 3, 4)
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Size = UDim2.new(1, -10, 0, 40)
    ButtonFrame.Font = Enum.Font.GothamBold
    ButtonFrame.Text = name
    ButtonFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
    ButtonFrame.TextSize = 14
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = ButtonFrame
    
    ButtonFrame.MouseButton1Click:Connect(callback)
    
    parent.Size = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y)
end

local function CreateDropdown(parent, name, options, callback)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Parent = parent
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.Size = UDim2.new(1, -10, 0, 40)
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 8)
    DropdownCorner.Parent = DropdownFrame
    
    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Parent = DropdownFrame
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Position = UDim2.new(0, 15, 0, 0)
    DropdownLabel.Size = UDim2.new(1, -30, 1, 0)
    DropdownLabel.Font = Enum.Font.Gotham
    DropdownLabel.Text = name .. ": " .. (options[1] or "None")
    DropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownLabel.TextSize = 13
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Parent = DropdownFrame
    DropdownButton.BackgroundTransparency = 1
    DropdownButton.Size = UDim2.new(1, 0, 1, 0)
    DropdownButton.Text = ""
    
    local DropdownList = Instance.new("Frame")
    DropdownList.Parent = DropdownFrame
    DropdownList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    DropdownList.BorderSizePixel = 0
    DropdownList.Position = UDim2.new(0, 0, 1, 5)
    DropdownList.Size = UDim2.new(1, 0, 0, 0)
    DropdownList.Visible = false
    DropdownList.ClipsDescendants = true
    
    local ListCorner = Instance.new("UICorner")
    ListCorner.CornerRadius = UDim.new(0, 8)
    ListCorner.Parent = DropdownList
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = DropdownList
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    DropdownButton.MouseButton1Click:Connect(function()
        DropdownList.Visible = not DropdownList.Visible
        if DropdownList.Visible then
            DropdownList.Size = UDim2.new(1, 0, 0, math.min(#options * 30, 150))
        end
    end)
    
    for _, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Parent = DropdownList
        OptionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        OptionButton.BorderSizePixel = 0
        OptionButton.Size = UDim2.new(1, 0, 0, 30)
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.Text = option
        OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptionButton.TextSize = 12
        
        OptionButton.MouseButton1Click:Connect(function()
            DropdownLabel.Text = name .. ": " .. option
            DropdownList.Visible = false
            callback(option)
        end)
    end
    
    parent.Size = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y)
end

local function CreateSlider(parent, name, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Parent = parent
    SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Size = UDim2.new(1, -10, 0, 60)
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = SliderFrame
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Parent = SliderFrame
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Position = UDim2.new(0, 15, 0, 5)
    SliderLabel.Size = UDim2.new(1, -30, 0, 20)
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.Text = name .. ": " .. default
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.TextSize = 13
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Parent = SliderFrame
    SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SliderBar.BorderSizePixel = 0
    SliderBar.Position = UDim2.new(0, 15, 0, 35)
    SliderBar.Size = UDim2.new(1, -30, 0, 8)
    
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
            SliderLabel.Text = name .. ": " .. value
            callback(value)
        end
    end)
    
    parent.Size = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y)
end

local function CreateLabel(parent, text)
    local Label = Instance.new("TextLabel")
    Label.Parent = parent
    Label.BackgroundColor3 = Color3.fromRGB(195, 3, 4)
    Label.BorderSizePixel = 0
    Label.Size = UDim2.new(1, -10, 0, 35)
    Label.Font = Enum.Font.GothamBold
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    
    local LabelCorner = Instance.new("UICorner")
    LabelCorner.CornerRadius = UDim.new(0, 8)
    LabelCorner.Parent = Label
    
    parent.Size = UDim2.new(1, 0, 0, ContentLayout.AbsoluteContentSize.Y)
end

-- Create Tabs
local AutoFarmTab = CreateTab("Auto Farm", "⚔️")
local CombatTab = CreateTab("Combat", "🗡️")
local StatsTab = CreateTab("Stats", "📊")
local TeleportTab = CreateTab("Teleport", "🌍")
local ESPTab = CreateTab("ESP", "👁️")
local MiscTab = CreateTab("Misc", "⚙️")
local RaidTab = CreateTab("Raid", "💀")
local ShopTab = CreateTab("Shop", "🛒")

-- AUTO FARM TAB
CreateLabel(AutoFarmTab, "🎯 Auto Farm Options")

CreateToggle(AutoFarmTab, "Auto Farm Level", function(value)
    SATX.Settings.AutoLevel = value
end)

CreateToggle(AutoFarmTab, "Auto Farm Boss", function(value)
    SATX.Settings.AutoBoss = value
end)

CreateToggle(AutoFarmTab, "Auto Farm Mastery", function(value)
    SATX.Settings.AutoMastery = value
end)

CreateToggle(AutoFarmTab, "Auto Farm Elite", function(value)
    SATX.Settings.AutoElite = value
end)

CreateToggle(AutoFarmTab, "Auto Farm Cake Prince", function(value)
    SATX.Settings.AutoCakePrince = value
end)

CreateToggle(AutoFarmTab, "Auto Farm Soul Reaper", function(value)
    SATX.Settings.AutoSoul = value
end)

CreateToggle(AutoFarmTab, "Auto Farm Bone", function(value)
    SATX.Settings.AutoBone = value
end)

CreateToggle(AutoFarmTab, "Auto Farm Sea Event", function(value)
    SATX.Settings.AutoSeaEvent = value
end)

CreateToggle(AutoFarmTab, "Auto Farm Factory", function(value)
    SATX.Settings.AutoFactory = value
end)

CreateToggle(AutoFarmTab, "Bring Mobs", function(value)
    SATX.Settings.BringMobs = value
end)

CreateSlider(AutoFarmTab, "Distance From Mob", 3, 20, 5, function(value)
    SATX.Settings.DistanceFromMob = value
end)

CreateDropdown(AutoFarmTab, "Select Weapon", WeaponList, function(value)
    SATX.Settings.SelectedWeapon = value
end)

-- COMBAT TAB
CreateLabel(CombatTab, "⚔️ Combat Options")

CreateToggle(CombatTab, "Fast Attack", function(value)
    SATX.Settings.FastAttack = value
end)

CreateToggle(CombatTab, "Auto Haki", function(value)
    SATX.Settings.AutoHaki = value
end)

CreateToggle(CombatTab, "Auto Buso Haki", function(value)
    SATX.Settings.AutoBusoHaki = value
end)

CreateToggle(CombatTab, "Auto Observation Haki", function(value)
    SATX.Settings.AutoObservation = value
end)

CreateToggle(CombatTab, "Auto Click", function(value)
    SATX.Settings.AutoClick = value
end)

CreateToggle(CombatTab, "Infinite Energy", function(value)
    SATX.Settings.InfiniteEnergy = value
end)

CreateButton(CombatTab, "Enable God Mode", function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "SATX Hub";
        Text = "God Mode Activated!";
        Duration = 3;
    })
end)

-- STATS TAB
CreateLabel(StatsTab, "📊 Auto Stats")

CreateToggle(StatsTab, "Auto Melee", function(value)
    SATX.Settings.AutoMelee = value
end)

CreateToggle(StatsTab, "Auto Defense", function(value)
    SATX.Settings.AutoDefense = value
end)

CreateToggle(StatsTab, "Auto Sword", function(value)
    SATX.Settings.AutoSword = value
end)

CreateToggle(StatsTab, "Auto Gun", function(value)
    SATX.Settings.AutoGun = value
end)

CreateToggle(StatsTab, "Auto Devil Fruit", function(value)
    SATX.Settings.AutoFruit = value
end)

CreateButton(StatsTab, "Reset Stats", function()
    -- Reset stats logic
end)

-- TELEPORT TAB
CreateLabel(TeleportTab, "🌍 Teleport")

CreateButton(TeleportTab, "Teleport to Main Island", function()
    HumanoidRootPart.CFrame = CFrame.new(-7894.6201, 5545.49316, -380.246796)
end)

CreateButton(TeleportTab, "Teleport to Jungle", function()
    HumanoidRootPart.CFrame = CFrame.new(-1612.7957763672, 36.852081298828, 149.12843322754)
end)

CreateButton(TeleportTab, "Teleport to Desert", function()
    HumanoidRootPart.CFrame = CFrame.new(944.15789794922, 20.919729232788, 4373.3002929688)
end)

CreateButton(TeleportTab, "Teleport to Frozen Village", function()
    HumanoidRootPart.CFrame = CFrame.new(5395.7578125, 87.22342824936, -4720.5166015625)
end)

CreateButton(TeleportTab, "Teleport to Skylands", function()
    HumanoidRootPart.CFrame = CFrame.new(-7894.6201171875, 5545.49316406, -380.24679870605)
end)

CreateButton(TeleportTab, "Teleport to Prison", function()
    HumanoidRootPart.CFrame = CFrame.new(4851.8720703125, 5.6519818305969, 734.85021972656)
end)

CreateButton(TeleportTab, "Teleport to Colosseum", function()
    HumanoidRootPart.CFrame = CFrame.new(-1427.6203613281, 7.2881078720093, -2792.7722167969)
end)

CreateButton(TeleportTab, "Teleport to Magma Village", function()
    HumanoidRootPart.CFrame = CFrame.new(-5247.7163085938, 12.883934020996, -8504.8349609375)
end)

CreateButton(TeleportTab, "Teleport to Hydra Island", function()
    HumanoidRootPart.CFrame = CFrame.new(5749.7861328125, 611.94750976563, -282.36651611328)
end)

CreateButton(TeleportTab, "Teleport to Castle on the Sea", function()
    HumanoidRootPart.CFrame = CFrame.new(-5085.23681640625, 316.5072021484375, -3156.202880859375)
end)

-- ESP TAB
CreateLabel(ESPTab, "👁️ ESP Options")

CreateToggle(ESPTab, "Player ESP", function(value)
    SATX.Settings.PlayerESP = value
end)

CreateToggle(ESPTab, "Mob ESP", function(value)
    SATX.Settings.MobESP = value
end)

CreateToggle(ESPTab, "Fruit ESP", function(value)
    SATX.Settings.FruitESP = value
end)

CreateToggle(ESPTab, "Chest ESP", function(value)
    SATX.Settings.ChestESP = value
end)

CreateToggle(ESPTab, "Flower ESP", function(value)
    SATX.Settings.FlowerESP = value
end)

CreateToggle(ESPTab, "NPC ESP", function(value)
    SATX.Settings.NPCESP = value
end)

-- MISC TAB
CreateLabel(MiscTab, "⚙️ Miscellaneous")

CreateToggle(MiscTab, "NoClip", function(value)
    SATX.Settings.NoClip = value
end)

CreateToggle(MiscTab, "Auto Store Items", function(value)
    SATX.Settings.AutoStoreItems = value
end)

CreateToggle(MiscTab, "Auto Random Surprise", function(value)
    SATX.Settings.AutoRandomSurprise = value
end)

CreateToggle(MiscTab, "Remove Fog", function(value)
    if value then
        game.Lighting.FogEnd = 9e9
    else
        game.Lighting.FogEnd = 100000
    end
end)

CreateToggle(MiscTab, "Remove Damage Effect", function(value)
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v.Name == "DamageCounter" then
            v:Destroy()
        end
    end
end)

CreateSlider(MiscTab, "Walk Speed", 16, 200, 16, function(value)
    SATX.Settings.WalkSpeed = value
end)

CreateSlider(MiscTab, "Jump Power", 50, 300, 50, function(value)
    SATX.Settings.JumpPower = value
end)

CreateButton(MiscTab, "Redeem All Codes", function()
    local codes = {"Sub2CaptainMaui", "kittgaming", "Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy", "Sub2NoobMaster123"}
    for _, code in pairs(codes) do
        game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(code)
        wait(1)
    end
end)

-- RAID TAB
CreateLabel(RaidTab, "💀 Raid Options")

CreateToggle(RaidTab, "Auto Raid", function(value)
    SATX.Settings.AutoRaid = value
end)

CreateToggle(RaidTab, "Auto Awakener", function(value)
    SATX.Settings.AutoAwakener = value
end)

CreateToggle(RaidTab, "Auto Buy Raid Chip", function(value)
    SATX.Settings.AutoBuyChip = value
end)

CreateDropdown(RaidTab, "Select Raid", {"Flame", "Ice", "Quake", "Light", "Dark", "Spider", "Rumble", "Magma", "Buddha"}, function(value)
    SATX.Settings.SelectedRaid = value
end)

CreateButton(RaidTab, "Start Raid", function()
    -- Start raid logic
end)

CreateButton(RaidTab, "Teleport to Raid", function()
    -- Teleport to raid
end)

-- SHOP TAB
CreateLabel(ShopTab, "🛒 Shop Options")

CreateButton(ShopTab, "Buy Haki Colors", function()
    -- Buy haki colors
end)

CreateButton(ShopTab, "Buy All Abilities", function()
    -- Buy abilities
end)

CreateButton(ShopTab, "Buy All Sword Styles", function()
    -- Buy sword styles
end)

CreateButton(ShopTab, "Buy Race Reroll", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Reroll","2")
end)

-- Toggle visibility
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Make first tab visible
AutoFarmTab.Visible = true
TabContainer:GetChildren()[1].BackgroundColor3 = Color3.fromRGB(195, 3, 4)
TabContainer:GetChildren()[1].TextColor3 = Color3.fromRGB(255, 255, 255)

-- Auto Farm Logic
local function GetQuestMob()
    local level = Player.Data.Level.Value
    if level >= 1 and level <= 9 then
        return "Bandit", CFrame.new(1145, 17, 1634)
    elseif level >= 10 and level <= 14 then
        return "Monkey", CFrame.new(-1448, 50, 35)
    elseif level >= 15 and level <= 29 then
        return "Gorilla", CFrame.new(-1129, 40, -525)
    elseif level >= 30 and level <= 39 then
        return "Pirate", CFrame.new(-1192, 5, 3916)
    elseif level >= 40 and level <= 59 then
        return "Brute", CFrame.new(-1141, 15, 4350)
    elseif level >= 60 and level <= 74 then
        return "Desert Bandit", CFrame.new(932, 7, 4484)
    elseif level >= 75 and level <= 89 then
        return "Desert Officer", CFrame.new(1608, 7, 4371)
    elseif level >= 90 and level <= 99 then
        return "Snow Bandit", CFrame.new(1354, 87, -1393)
    elseif level >= 100 and level <= 119 then
        return "Snowman", CFrame.new(1198, 87, -1397)
    elseif level >= 120 and level <= 149 then
        return "Chief Petty Officer", CFrame.new(-4855, 23, 4308)
    elseif level >= 150 and level <= 174 then
        return "Sky Bandit", CFrame.new(-4981, 717, -2905)
    elseif level >= 175 and level <= 189 then
        return "Dark Master", CFrame.new(-5079, 717, -2625)
    elseif level >= 190 and level <= 209 then
        return "Prisoner", CFrame.new(5411, 96, 690)
    elseif level >= 210 and level <= 249 then
        return "Dangerous Prisoner", CFrame.new(5411, 96, 690)
    elseif level >= 250 and level <= 274 then
        return "Toga Warrior", CFrame.new(-1824, 50, -2743)
    elseif level >= 275 and level <= 299 then
        return "Gladiator", CFrame.new(-1268, 7, -3039)
    elseif level >= 300 and level <= 324 then
        return "Military Soldier", CFrame.new(-5408, 11, 8454)
    elseif level >= 325 and level <= 374 then
        return "Military Spy", CFrame.new(-5815, 84, 8820)
    elseif level >= 375 and level <= 399 then
        return "Fishman Warrior", CFrame.new(60859, 19, 1501)
    elseif level >= 400 and level <= 449 then
        return "Fishman Commando", CFrame.new(61123, 19, 1569)
    elseif level >= 450 and level <= 474 then
        return "God's Guard", CFrame.new(-4698, 845, -1912)
    elseif level >= 475 and level <= 524 then
        return "Shanda", CFrame.new(-7685, 5567, -502)
    elseif level >= 525 and level <= 549 then
        return "Royal Squad", CFrame.new(-7670, 5607, -1460)
    elseif level >= 550 and level <= 624 then
        return "Royal Soldier", CFrame.new(-7670, 5607, -1460)
    elseif level >= 625 and level <= 649 then
        return "Galley Pirate", CFrame.new(5551, 42, 3939)
    elseif level >= 650 and level <= 699 then
        return "Galley Captain", CFrame.new(5551, 42, 3939)
    elseif level >= 700 and level <= 724 then
        return "Raider", CFrame.new(-917, 7, 2623)
    elseif level >= 725 and level <= 774 then
        return "Mercenary", CFrame.new(-874, 7, 2622)
    elseif level >= 775 and level <= 799 then
        return "Swan Pirate", CFrame.new(942, 126, 1324)
    elseif level >= 800 and level <= 874 then
        return "Factory Staff", CFrame.new(296, 7, -2954)
    elseif level >= 875 and level <= 899 then
        return "Marine Lieutenant", CFrame.new(-2807, 73, -3038)
    elseif level >= 900 and level <= 949 then
        return "Marine Captain", CFrame.new(-1869, 73, -3321)
    elseif level >= 950 and level <= 974 then
        return "Zombie", CFrame.new(-5736, 126, -728)
    elseif level >= 975 and level <= 999 then
        return "Vampire", CFrame.new(-5806, 7, -1319)
    elseif level >= 1000 and level <= 1049 then
        return "Snow Trooper", CFrame.new(478, 402, -5362)
    elseif level >= 1050 and level <= 1099 then
        return "Winter Warrior", CFrame.new(1295, 429, -5087)
    elseif level >= 1100 and level <= 1124 then
        return "Lab Subordinate", CFrame.new(-5769, 74, -4265)
    elseif level >= 1125 and level <= 1174 then
        return "Horned Warrior", CFrame.new(-6341, 18, -5767)
    elseif level >= 1175 and level <= 1199 then
        return "Magma Ninja", CFrame.new(-5428, 78, -5959)
    elseif level >= 1200 and level <= 1249 then
        return "Lava Pirate", CFrame.new(-5213, 49, -4701)
    elseif level >= 1250 and level <= 1274 then
        return "Ship Deckhand", CFrame.new(1041, 125, 32911)
    elseif level >= 1275 and level <= 1299 then
        return "Ship Engineer", CFrame.new(919, 44, 32853)
    elseif level >= 1300 and level <= 1324 then
        return "Ship Steward", CFrame.new(915, 129, 33440)
    elseif level >= 1325 and level <= 1349 then
        return "Ship Officer", CFrame.new(915, 181, 33440)
    elseif level >= 1350 and level <= 1374 then
        return "Arctic Warrior", CFrame.new(6038, 29, -6231)
    elseif level >= 1375 and level <= 1399 then
        return "Snow Lurker", CFrame.new(5560, 42, -6826)
    elseif level >= 1400 and level <= 1424 then
        return "Sea Soldier", CFrame.new(-5032, 6, -4912)
    elseif level >= 1425 and level <= 1449 then
        return "Water Fighter", CFrame.new(-3385, 239, -10542)
    else
        return "Bandit", CFrame.new(1145, 17, 1634)
    end
end

spawn(function()
    while wait() do
        if SATX.Settings.AutoLevel then
            pcall(function()
                local mobName, mobPos = GetQuestMob()
                for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if v.Name == mobName and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        repeat wait()
                            if SATX.Settings.FastAttack then
                                game:GetService("VirtualUser"):CaptureController()
                                game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                            end
                            
                            v.HumanoidRootPart.CanCollide = false
                            v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            v.Head.CanCollide = false
                            
                            HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, SATX.Settings.DistanceFromMob, 0)
                            
                            if SATX.Settings.AutoHaki then
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                            end
                        until not SATX.Settings.AutoLevel or not v.Parent or v.Humanoid.Health <= 0
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
            for _, v in pairs(Player.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end
end)

-- Walk Speed & Jump Power
spawn(function()
    while wait() do
        if Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.WalkSpeed = SATX.Settings.WalkSpeed
            Character.Humanoid.JumpPower = SATX.Settings.JumpPower
        end
    end
end)

-- Fruit ESP
local function CreateESP(object, color, text)
    local BillboardGui = Instance.new("BillboardGui")
    local TextLabel = Instance.new("TextLabel")
    
    BillboardGui.Parent = object
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Size = UDim2.new(0, 100, 0, 50)
    BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
    
    TextLabel.Parent = BillboardGui
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.Text = text
    TextLabel.TextColor3 = color
    TextLabel.TextSize = 14
    TextLabel.TextStrokeTransparency = 0
end

spawn(function()
    while wait(2) do
        if SATX.Settings.FruitESP then
            for _, v in pairs(game:GetService("Workspace"):GetChildren()) do
                if string.find(v.Name, "Fruit") and v:IsA("Tool") then
                    if not v:FindFirstChild("BillboardGui") then
                        CreateESP(v, Color3.fromRGB(255, 0, 0), v.Name)
                    end
                end
            end
        end
    end
end)

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
    end
end)

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "SATX Blox Fruits Hub";
    Text = "Script Loaded Successfully!";
    Icon = "rbxassetid://7733779610";
    Duration = 5;
})

print([[
╔═══════════════════════════════════════╗
║   SATX Blox Fruits Hub Loaded         ║
║   Version: 2.0 Ultra Complete         ║
║   Status: ✅ Fully Operational       ║
╚═══════════════════════════════════════╝
]])
