I'll fix the speed menu positioning and enhance the anticheat bypass system:

```lua
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local PathfindingService = game:GetService("PathfindingService")

-- Clean up existing UI
if CoreGui:FindFirstChild("SynapseUI") then
    CoreGui:FindFirstChild("SynapseUI"):Destroy()
end

-- Create main GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SynapseUI"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

-- Main frame (RIGHT side as before)
local frame = Instance.new("Frame")
frame.AnchorPoint = Vector2.new(1, 0)
frame.Position = UDim2.new(1, -20, 0, 20)
frame.Size = UDim2.new(0, 250, 0, 470)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Visible = true
frame.Parent = gui

-- Add rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Add gradient background
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
}
gradient.Rotation = 90
gradient.Parent = frame

-- Add border stroke
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(40, 40, 40)
stroke.Thickness = 1
stroke.Parent = frame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

-- Fix bottom corners of title bar
local titleBarFix = Instance.new("Frame")
titleBarFix.Size = UDim2.new(1, 0, 0, 10)
titleBarFix.Position = UDim2.new(0, 0, 1, -10)
titleBarFix.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBarFix.BorderSizePixel = 0
titleBarFix.Parent = titleBar

-- Title text
local title = Instance.new("TextLabel")
title.Text = "SYNAPSE X"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Minimize button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Text = "—"
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 20
minimizeButton.TextColor3 = Color3.fromRGB(180, 180, 180)
minimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minimizeButton.Size = UDim2.new(0, 25, 0, 25)
minimizeButton.Position = UDim2.new(1, -55, 0.5, -12.5)
minimizeButton.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 5)
minCorner.Parent = minimizeButton

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Text = "×"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 20
closeButton.TextColor3 = Color3.fromRGB(180, 180, 180)
closeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -28, 0.5, -12.5)
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

-- Content area with scrolling
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -45)
scrollFrame.Position = UDim2.new(0, 5, 0, 40)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.Parent = frame

-- Layout for buttons
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scrollFrame

-- SPEED SETTINGS MENU (now on LEFT side of main menu, as a separate window)
local speedSettingsFrame = Instance.new("Frame")
speedSettingsFrame.AnchorPoint = Vector2.new(1, 0)
speedSettingsFrame.Position = UDim2.new(1, -280, 0, 20) -- Position to the left of main menu
speedSettingsFrame.Size = UDim2.new(0, 200, 0, 250)
speedSettingsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
speedSettingsFrame.BorderSizePixel = 0
speedSettingsFrame.Visible = false
speedSettingsFrame.Parent = gui -- Parent to gui, not frame

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 10)
speedCorner.Parent = speedSettingsFrame

local speedGradient = Instance.new("UIGradient")
speedGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
}
speedGradient.Rotation = 90
speedGradient.Parent = speedSettingsFrame

local speedStroke = Instance.new("UIStroke")
speedStroke.Color = Color3.fromRGB(40, 40, 40)
speedStroke.Thickness = 1
speedStroke.Parent = speedSettingsFrame

-- Speed Settings Title
local speedTitle = Instance.new("TextLabel")
speedTitle.Text = "Speed Settings"
speedTitle.Font = Enum.Font.SourceSansBold
speedTitle.TextSize = 16
speedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
speedTitle.BackgroundTransparency = 1
speedTitle.Size = UDim2.new(1, 0, 0, 30)
speedTitle.Position = UDim2.new(0, 0, 0, 5)
speedTitle.Parent = speedSettingsFrame

-- Speed Value Display
local speedValueLabel = Instance.new("TextLabel")
speedValueLabel.Text = "Speed: 100"
speedValueLabel.Font = Enum.Font.SourceSans
speedValueLabel.TextSize = 14
speedValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedValueLabel.BackgroundTransparency = 1
speedValueLabel.Size = UDim2.new(1, 0, 0, 20)
speedValueLabel.Position = UDim2.new(0, 0, 0, 40)
speedValueLabel.Parent = speedSettingsFrame

-- Speed Slider
local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(0.9, 0, 0, 20)
sliderFrame.Position = UDim2.new(0.05, 0, 0, 70)
sliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
sliderFrame.BorderSizePixel = 0
sliderFrame.Parent = speedSettingsFrame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 10)
sliderCorner.Parent = sliderFrame

local sliderButton = Instance.new("TextButton")
sliderButton.Text = ""
sliderButton.Size = UDim2.new(0, 20, 1, 0)
sliderButton.Position = UDim2.new(0.2, -10, 0, 0)
sliderButton.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
sliderButton.BorderSizePixel = 0
sliderButton.AutoButtonColor = false
sliderButton.Parent = sliderFrame

local sliderButtonCorner = Instance.new("UICorner")
sliderButtonCorner.CornerRadius = UDim.new(0, 10)
sliderButtonCorner.Parent = sliderButton

-- Speed Presets
local presetLabel = Instance.new("TextLabel")
presetLabel.Text = "Presets:"
presetLabel.Font = Enum.Font.SourceSansBold
presetLabel.TextSize = 14
presetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
presetLabel.BackgroundTransparency = 1
presetLabel.Size = UDim2.new(1, 0, 0, 20)
presetLabel.Position = UDim2.new(0, 10, 0, 105)
presetLabel.TextXAlignment = Enum.TextXAlignment.Left
presetLabel.Parent = speedSettingsFrame

local presetButtons = {}
local presets = {
    {name = "Slow", value = 50},
    {name = "Normal", value = 100},
    {name = "Fast", value = 150},
    {name = "Insane", value = 300}
}

for i, preset in ipairs(presets) do
    local presetBtn = Instance.new("TextButton")
    presetBtn.Text = preset.name
    presetBtn.Font = Enum.Font.SourceSans
    presetBtn.TextSize = 12
    presetBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    presetBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    presetBtn.BorderSizePixel = 0
    presetBtn.Size = UDim2.new(0.43, 0, 0, 25)
    presetBtn.Position = UDim2.new(0.05 + ((i-1) % 2) * 0.47, 0, 0, 130 + math.floor((i-1) / 2) * 30)
    presetBtn.AutoButtonColor = false
    presetBtn.Parent = speedSettingsFrame
    
    local presetCorner = Instance.new("UICorner")
    presetCorner.CornerRadius = UDim.new(0, 5)
    presetCorner.Parent = presetBtn
    
    presetBtn.MouseButton1Click:Connect(function()
        currentSpeedValue = preset.value
        speedValueLabel.Text = "Speed: " .. tostring(currentSpeedValue)
        sliderButton.Position = UDim2.new((currentSpeedValue - 16) / (500 - 16), -10, 0, 0)
    end)
    
    table.insert(presetButtons, presetBtn)
end

-- Speed value
local currentSpeedValue = 100

-- Slider functionality
local draggingSlider = false

sliderButton.MouseButton1Down:Connect(function()
    draggingSlider = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mouse = UserInputService:GetMouseLocation()
        local relativeX = mouse.X - sliderFrame.AbsolutePosition.X
        local percentage = math.clamp(relativeX / sliderFrame.AbsoluteSize.X, 0, 1)
        
        sliderButton.Position = UDim2.new(percentage, -10, 0, 0)
        currentSpeedValue = math.floor(16 + (500 - 16) * percentage)
        speedValueLabel.Text = "Speed: " .. tostring(currentSpeedValue)
    end
end)

-- Icon IDs for different features
local icons = {
    gravity = "rbxassetid://7733765307",    -- Moon icon
    teleport = "rbxassetid://7733764536",   -- Arrow up icon
    speed = "rbxassetid://7733673987",      -- Lightning bolt icon
    esp = "rbxassetid://7733964370",        -- Eye icon
    steal = "rbxassetid://7733674153",      -- Money icon
    down = "rbxassetid://7733764605",       -- Arrow down icon
    noclip = "rbxassetid://7733799795"      -- Ghost icon
}

-- Button creation function
local function createButton(text, iconId, layoutOrder)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, 0, 0, 45)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.LayoutOrder = layoutOrder or 1
    buttonFrame.Parent = scrollFrame
    
    local btn = Instance.new("TextButton")
    btn.Text = ""
    btn.Font = Enum.Font.SourceSans
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1, -10, 1, 0)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.AutoButtonColor = false
    btn.Parent = buttonFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = Color3.fromRGB(50, 50, 50)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.5
    btnStroke.Parent = btn
    
    -- Icon
    local iconLabel = Instance.new("ImageLabel")
    iconLabel.Image = iconId
    iconLabel.ImageColor3 = Color3.fromRGB(150, 150, 150)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Size = UDim2.new(0, 20, 0, 20)
    iconLabel.Position = UDim2.new(0, 10, 0.5, -10)
    iconLabel.ScaleType = Enum.ScaleType.Fit
    iconLabel.Parent = btn
    
    -- Button text
    local btnText = Instance.new("TextLabel")
    btnText.Text = text
    btnText.Font = Enum.Font.SourceSans
    btnText.TextSize = 14
    btnText.TextColor3 = Color3.fromRGB(220, 220, 220)
    btnText.BackgroundTransparency = 1
    btnText.Size = UDim2.new(1, -90, 1, 0)
    btnText.Position = UDim2.new(0, 40, 0, 0)
    btnText.TextXAlignment = Enum.TextXAlignment.Left
    btnText.Parent = btn
    
    -- Status indicator
    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.new(0, 8, 0, 8)
    statusDot.Position = UDim2.new(1, -20, 0.5, -4)
    statusDot.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    statusDot.BorderSizePixel = 0
    statusDot.Parent = btn
    
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = statusDot
    
    -- Hover effects
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        }):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {
            Color = Color3.fromRGB(70, 70, 70)
        }):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        if not btn:GetAttribute("Active") then
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            }):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.2), {
                Color = Color3.fromRGB(50, 50, 50)
            }):Play()
        end
    end)
    
    -- Click animation
    btn.MouseButton1Click:Connect(function()
        local clickTween = TweenService:Create(btn, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        })
        clickTween:Play()
        task.wait(0.1)
        TweenService:Create(btn, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        }):Play()
    end)
    
    return btn, statusDot, iconLabel, buttonFrame
end

-- Create buttons
local gravityButton, gravityStatus, gravityIcon = createButton("Moon Gravity", icons.gravity, 1)
local teleportButton, teleportStatus, teleportIcon = createButton("Teleport", icons.teleport, 2)
local speedButton, speedStatus, speedIcon = createButton("Speed Boost", icons.speed, 3)
local espButton, espStatus, espIcon = createButton("ESP", icons.esp, 4)
local proximityButton, proximityStatus, proximityIcon = createButton("Auto Steal", icons.steal, 5)
local noclipButton, noclipStatus, noclipIcon = createButton("Noclip", icons.noclip, 6)

-- Create teleport down button (initially hidden)
local teleportDownButton, teleportDownStatus, teleportDownIcon, teleportDownFrame = createButton("Teleport Down", icons.down, 7)
teleportDownFrame.Visible = false

-- Made by label
local madeByLabel = Instance.new("TextLabel")
madeByLabel.Text = "v2.1.0 | joker9292oo | 2025"
madeByLabel.Font = Enum.Font.SourceSans
madeByLabel.TextSize = 11
madeByLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
madeByLabel.BackgroundTransparency = 1
madeByLabel.Size = UDim2.new(1, 0, 0, 20)
madeByLabel.Position = UDim2.new(0, 0, 1, -20)
madeByLabel.Parent = frame

-- Update canvas size
layout.Changed:Connect(function()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end)

-- Minimize functionality
local minimized = false
local originalSize = frame.Size

minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    
    if minimized then
        TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
            Size = UDim2.new(0, 250, 0, 35)
        }):Play()
        minimizeButton.Text = "+"
        scrollFrame.Visible = false
        madeByLabel.Visible = false
        speedSettingsFrame.Visible = false
    else
        TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
            Size = originalSize
        }):Play()
        minimizeButton.Text = "—"
        scrollFrame.Visible = true
        madeByLabel.Visible = true
    end
end)

-- Hover effects for title buttons
minimizeButton.MouseEnter:Connect(function()
    TweenService:Create(minimizeButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
end)

minimizeButton.MouseLeave:Connect(function()
    TweenService:Create(minimizeButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        TextColor3 = Color3.fromRGB(180, 180, 180)
    }):Play()
end)

closeButton.MouseEnter:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(200, 60, 60),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
end)

closeButton.MouseLeave:Connect(function()
    TweenService:Create(closeButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        TextColor3 = Color3.fromRGB(180, 180, 180)
    }):Play()
end)

-- Close functionality
closeButton.MouseButton1Click:Connect(function()
    TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(1, -20, 0, 20)
    }):Play()
    task.wait(0.3)
    gui:Destroy()
end)

-- Dragging system
local dragging = false
local dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateDrag(input)
    end
end)

-- Toggle UI visibility
local uiVisible = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        uiVisible = not uiVisible
        if uiVisible then
            frame.Visible = true
            TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -20, 0, 20)
            }):Play()
        else
            TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Position = UDim2.new(1, 300, 0, 20)
            }):Play()
            task.wait(0.3)
            frame.Visible = false
        end
    end
end)

-- Store original position before teleporting up
local originalPosition = nil

-- Smart Noclip System (Won't fall through ground)
local noclipEnabled = false
local temporaryNoclipActive = false
local noclipConnection = nil
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

local function smartNoclip()
    local character = Players.LocalPlayer.Character
    if not character then return end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    -- Set up raycast to ignore character
    raycastParams.FilterDescendantsInstances = {character}
    
    -- Disable collision for character parts
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part ~= root then
            part.CanCollide = false
        end
    end
    
    -- Keep root part collision but handle it specially
    local rootPos = root.Position
    
    -- Check if there's ground below
    local rayDown = workspace:Raycast(rootPos, Vector3.new(0, -5, 0), raycastParams)
    
    if rayDown and rayDown.Instance then
        -- There's ground below, check if we're inside something
        local rayUp = workspace:Raycast(rootPos, Vector3.new(0, 5, 0), raycastParams)
        
        if rayUp and rayUp.Instance then
            -- We're inside something, disable collision
            root.CanCollide = false
        else
            -- We're above ground, keep collision
            root.CanCollide = true
        end
    else
        -- No ground immediately below, keep checking
        local rayFarDown = workspace:Raycast(rootPos, Vector3.new(0, -50, 0), raycastParams)
        
        if rayFarDown and rayFarDown.Instance then
            -- Ground exists but is far, we might be jumping
            root.CanCollide = false
        else
            -- No ground at all, enable collision to prevent falling into void
            root.CanCollide = true
        end
    end
    
    -- Prevent falling through map
    if rootPos.Y < -200 then
        root.CFrame = CFrame.new(rootPos.X, 10, rootPos.Z)
    end
end

local function enableSmartNoclip()
    noclipConnection = RunService.Stepped:Connect(smartNoclip)
end

local function disableSmartNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    -- Re-enable collision for all parts
    local character = Players.LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Noclip button functionality
noclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    
    if noclipEnabled then
        noclipButton:SetAttribute("Active", true)
        TweenService:Create(noclipStatus, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(150, 100, 255)
        }):Play()
        TweenService:Create(noclipIcon, TweenInfo.new(0.2), {
            ImageColor3 = Color3.fromRGB(150, 100, 255)
        }):Play()
        
        enableSmartNoclip()
    else
        noclipButton:SetAttribute("Active", false)
        TweenService:Create(noclipStatus, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        }):Play()
        TweenService:Create(noclipIcon, TweenInfo.new(0.2), {
            ImageColor3 = Color3.fromRGB(150, 150, 150)
        }):Play()
        
        disableSmartNoclip()
    end
end)

-- Temporary noclip for auto steal
local function enableNoclip()
    if not noclipEnabled then
        temporaryNoclipActive = true
        enableSmartNoclip()
    end
end

local function disableNoclip()
    if temporaryNoclipActive and not noclipEnabled then
        temporaryNoclipActive = false
        disableSmartNoclip()
    end
end

-- ADVANCED AUTO STEAL SYSTEM (SLOW FLYING)
local autoProximityEnabled = false
local proximityConnection = nil
local myBasePosition = nil
local isProcessingSteal = false
local flyConnection = nil

-- Function to find "MyBase" part with better detection
local function findMyBase()
    local playerName = Players.LocalPlayer.Name
    
    -- List of search patterns
    local searchPatterns = {
        "MyBase",
        playerName .. "Base",
        "Base" .. playerName,
        playerName,
        "base",
        "spawn",
        "home"
    }
    
    -- First, look for exact matches
    for _, pattern in pairs(searchPatterns) do
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and string.lower(obj.Name) == string.lower(pattern) then
                -- Make sure we get the top surface
                return obj.Position + Vector3.new(0, obj.Size.Y/2 + 5, 0)
            end
        end
    end
    
    -- Look for models
    for _, pattern in pairs(searchPatterns) do
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and string.find(string.lower(obj.Name), string.lower(pattern)) then
                local primaryPart = obj.PrimaryPart
                if not primaryPart then
                    primaryPart = obj:FindFirstChildWhichIsA("BasePart")
                end
                if primaryPart then
                    -- Make sure we get the top surface
                    return primaryPart.Position + Vector3.new(0, primaryPart.Size.Y/2 + 5, 0)
                end
            end
        end
    end
    
    -- If still no base found, just go to spawn
    local character = Players.LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local spawnLocation = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChildOfClass("SpawnLocation")
        if spawnLocation then
            return spawnLocation.Position + Vector3.new(0, 5, 0)
        end
        -- Last resort: current position + offset
        return character.HumanoidRootPart.Position + Vector3.new(50, 15, 0)
    end
    
    return Vector3.new(0, 100, 0)
end

-- Slow flying movement to base
local function slowFlyToBase()
    local character = Players.LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then return end
    
    -- Find base position
    myBasePosition = findMyBase()
    
    -- Store current position as original
    originalPosition = root.CFrame
    
    -- Enable noclip for movement
    enableNoclip()
    
    -- Calculate direction and distance
    local startPos = root.Position
    local targetPos = myBasePosition
    local direction = (targetPos - startPos).Unit
    local distance = (targetPos - startPos).Magnitude
    
    -- Lift player slightly first (10-15 studs)
    local liftHeight = 15
    local currentPos = startPos + Vector3.new(0, liftHeight, 0)
    root.CFrame = CFrame.new(currentPos)
    
    -- Adjust target position to same height
    targetPos = Vector3.new(targetPos.X, startPos.Y + liftHeight, targetPos.Z)
    
    -- Recalculate direction after lift
    direction = (targetPos - currentPos).Unit
    distance = (targetPos - currentPos).Magnitude
    
    -- Slow flying parameters
    local flySpeed = 16 -- Slow speed (studs per second)
    local startTime = tick()
    
    if flyConnection then flyConnection:Disconnect() end
    
    flyConnection = RunService.Heartbeat:Connect(function()
        if not character.Parent then
            flyConnection:Disconnect()
            return
        end
        
        local elapsedTime = tick() - startTime
        local distanceTraveled = flySpeed * elapsedTime
        
        if distanceTraveled < distance then
            -- Continue flying
            local newPos = startPos + Vector3.new(0, liftHeight, 0) + (direction * distanceTraveled)
            
            -- Add slight bobbing motion for realism
            local bobAmount = math.sin(elapsedTime * 2) * 0.3
            newPos = newPos + Vector3.new(0, bobAmount, 0)
            
            -- Face direction of movement
            local lookDirection = CFrame.lookAt(root.Position, newPos + direction)
            root.CFrame = lookDirection + (newPos - root.Position)
        else
            -- Reached destination
            flyConnection:Disconnect()
            
            -- Land at base position
            root.CFrame = CFrame.new(myBasePosition)
            
            -- Show teleport down button
            teleportDownFrame.Visible = true
            teleportDownFrame.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(teleportDownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, 45)
            }):Play()
            
            -- Disable noclip after landing
            task.wait(0.5)
            disableNoclip()
            
            -- Reset processing flag
            isProcessingSteal = false
        end
    end)
end

-- Find closest steal prompt
local function getClosestStealPrompt()
    local character = Players.LocalPlayer.Character
    if not character then return nil end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return nil end
    
    local closestPrompt = nil
    local closestDistance = math.huge
    
    for _, prompt in pairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") and prompt.ActionText == "Steal" and prompt.Enabled then
            local success, result = pcall(function()
                local parent = prompt.Parent
                if parent then
                    local part = nil
                    
                    if parent:IsA("BasePart") then
                        part = parent
                    elseif parent:IsA("Model") then
                        part = parent.PrimaryPart or parent:FindFirstChildWhichIsA("BasePart")
                    elseif parent:IsA("Attachment") then
                        part = parent.Parent
                    end
                    
                    if part and part:IsA("BasePart") then
                        local distance = (part.Position - humanoidRootPart.Position).Magnitude
                        
                        if distance < closestDistance and distance <= prompt.MaxActivationDistance then
                            closestDistance = distance
                            closestPrompt = prompt
                        end
                    end
                end
            end)
        end
    end
    
    return closestPrompt
end

-- Human-like prompt trigger
local function triggerPromptHumanLike(prompt)
    -- Store original values
    local originalHoldDuration = prompt.HoldDuration
    local originalLineOfSight = prompt.RequiresLineOfSight
    
    -- Make prompt easier to trigger
    prompt.RequiresLineOfSight = false
    
    -- Simulate human click with slight delay
    task.wait(math.random() * 0.3 + 0.1) -- Random 0.1-0.4 second delay
    
    -- Check if we need to hold
    if originalHoldDuration > 0 then
        -- Start holding
        prompt:InputHoldBegin()
        
        -- Wait for hold duration with slight variance
        local holdTime = originalHoldDuration + (math.random() * 0.2 - 0.1)
        task.wait(holdTime)
        
        -- Release
        prompt:InputHoldEnd()
    else
        -- Instant click
        if fireproximityprompt then
            fireproximityprompt(prompt)
        else
            prompt:InputHoldBegin()
            task.wait(0.05)
            prompt:InputHoldEnd()
        end
    end
    
    -- Restore original values
    prompt.HoldDuration = originalHoldDuration
    prompt.RequiresLineOfSight = originalLineOfSight
end

-- Auto Steal button functionality
proximityButton.MouseButton1Click:Connect(function()
    autoProximityEnabled = not autoProximityEnabled
    
    if autoProximityEnabled then
        proximityButton:SetAttribute("Active", true)
        TweenService:Create(proximityStatus, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 150, 100)
        }):Play()
        TweenService:Create(proximityIcon, TweenInfo.new(0.2), {
            ImageColor3 = Color3.fromRGB(255, 150, 100)
        }):Play()
        
        -- Reset base position to find it fresh
        myBasePosition = nil
        
        if proximityConnection then proximityConnection:Disconnect() end
        
        proximityConnection = RunService.Heartbeat:Connect(function()
            if not autoProximityEnabled then
                if proximityConnection then
                    proximityConnection:Disconnect()
                    proximityConnection = nil
                end
                return
            end
            
            -- Only process if not already stealing
            if not isProcessingSteal then
                local closestPrompt = getClosestStealPrompt()
                if closestPrompt then
                    isProcessingSteal = true
                    
                    -- Trigger prompt with human-like behavior
                    spawn(function()
                        triggerPromptHumanLike(closestPrompt)
                        
                        -- Wait for action to complete
                        task.wait(1.5) -- Give time for the steal action
                        
                        -- Slow fly to base
                        slowFlyToBase()
                    end)
                    
                    -- Auto-disable after triggering
                    autoProximityEnabled = false
                    proximityButton:SetAttribute("Active", false)
                    TweenService:Create(proximityStatus, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                    }):Play()
                    TweenService:Create(proximityIcon, TweenInfo.new(0.2), {
                        ImageColor3 = Color3.fromRGB(150, 150, 150)
                    }):Play()
                    
                    if proximityConnection then
                        proximityConnection:Disconnect()
                        proximityConnection = nil
                    end
                end
            end
        end)
        
    else
        proximityButton:SetAttribute("Active", false)
        TweenService:Create(proximityStatus, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        }):Play()
        TweenService:Create(proximityIcon, TweenInfo.new(0.2), {
            ImageColor3 = Color3.fromRGB(150, 150, 150)
        }):Play()
        
        if proximityConnection then
            proximityConnection:Disconnect()
            proximityConnection = nil
        end
        
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        isProcessingSteal = false
    end
end)

-- Teleport down button functionality
teleportDownButton.MouseButton1Click:Connect(function()
    if originalPosition then
        local character = Players.LocalPlayer.Character
        if character then
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                -- Teleport back to original position
                root.CFrame = originalPosition
                
                -- Hide button with animation
                TweenService:Create(teleportDownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                    Size = UDim2.new(1, 0, 0, 0)
                }):Play()
                task.wait(0.3)
                teleportDownFrame.Visible = false
                
                -- Clear stored position
                originalPosition = nil
            end
        end
    end
end)

-- Moon Gravity functionality (improved)
local moonGravityEnabled = false
local gravityConnection
local originalGravitySettings = {}

local function resetGravity()
    local character = Players.LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildWhichIsA("Humanoid")
        if humanoid then
            pcall(function()
                humanoid.JumpPower = originalGravitySettings.JumpPower or 50
                humanoid.JumpHeight = originalGravitySettings.JumpHeight or 7.2
            end)
        end
    end
end

gravityButton.MouseButton1Click:Connect(function()
    moonGravityEnabled = not moonGravityEnabled
    
    if moonGravityEnabled then
        gravityButton:SetAttribute("Active", true)
        TweenService:Create(gravityStatus, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        }):Play()
        TweenService:Create(gravityIcon, TweenInfo.new(0.2), {
            ImageColor3 = Color3.fromRGB(100, 200, 100)
        }):Play()
        
        local character = Players.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildWhichIsA("Humanoid")
            local root = character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and root then
                -- Store original settings
                originalGravitySettings.JumpPower = humanoid.JumpPower
                originalGravitySettings.JumpHeight = humanoid.JumpHeight
                
                -- Apply moon gravity
                pcall(function()
                    humanoid.UseJumpPower = true
                    humanoid.JumpPower = 96
                end)
                
                if gravityConnection then gravityConnection:Disconnect() end
                
                gravityConnection = RunService.Stepped:Connect(function()
                    if not moonGravityEnabled or not root.Parent then
                        gravityConnection:Disconnect()
                        resetGravity()
                        return
                    end
                    
                    -- Smoother gravity effect
                    local velocity = root.AssemblyLinearVelocity
                    if velocity.Y < 0 then
                        root.AssemblyLinearVelocity = Vector3.new(velocity.X, velocity.Y * 0.92, velocity.Z)
                    end
                end)
            end
        end
    else
        gravityButton:SetAttribute("Active", false)
        TweenService:Create(gravityStatus, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        }):Play()
        TweenService:Create(gravityIcon, TweenInfo.new(0.2), {
            ImageColor3 = Color3.fromRGB(150, 150, 150)
        }):Play()
        
        if gravityConnection then
            gravityConnection:Disconnect()
            gravityConnection = nil
        end
        resetGravity()
    end
end)

-- Teleport functionality
local teleportUp = true
teleportButton.MouseButton1Click:Connect(function()
    local character = Players.LocalPlayer.Character
    if character then
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            -- Flash animation
            TweenService:Create(teleportStatus, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(100, 150, 255)
            }):Play()
            
            if teleportUp then
                originalPosition = root.CFrame
                root.CFrame = root.CFrame + Vector3.new(0, 150, 0)
                teleportIcon.Image = icons.down
                
                -- Show teleport down button
                teleportDownFrame.Visible = true
                teleportDownFrame.Size = UDim2.new(0, 0, 0, 0)
                TweenService:Create(teleportDownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, 0, 0, 45)
                }):Play()
            else
                root.CFrame = root.CFrame - Vector3.new(0, 150, 0)
                teleportIcon.Image = icons.teleport
            end
            teleportUp = not teleportUp
            
            task.wait(0.1)
            TweenService:Create(teleportStatus, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            }):Play()
        end
    end
end)

-- ULTRA ADVANCED SPEED BOOST SYSTEM (MAXIMUM ANTICHEAT BYPASS)
local speedEnabled = false
local speedConnections = {}
local originalWalkSpeed = 16
local originalProperties = {}

-- Advanced Speed Methods with anticheat bypass
local SpeedMethods = {
    -- Method 1: Advanced CFrame with prediction and smoothing
    AdvancedCFrame = function(character, moveVector, speed)
        local root = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if root and humanoid and moveVector.Magnitude > 0 then
            -- Get actual move direction from humanoid
            local moveDirection = humanoid.MoveDirection
            
            -- Apply speed in smaller increments to avoid detection
            local increment = speed / 30
            local smoothingFactor = 0.85
            
            -- Calculate new position with smoothing
            local currentVel = root.AssemblyLinearVelocity
            local targetVel = moveDirection * speed
            local smoothedVel = currentVel:Lerp(targetVel, smoothingFactor)
            
            -- Apply movement
            root.CFrame = root.CFrame + (moveDirection * increment)
            
            -- Maintain Y velocity for jumping
            root.AssemblyLinearVelocity = Vector3.new(
                smoothedVel.X,
                currentVel.Y,
                smoothedVel.Z
            )
        end
    end,
    
    -- Method 2: Hybrid CFrame + Velocity
    HybridMethod = function(character, moveVector, speed)
        local root = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if root and humanoid then
            local moveDirection = humanoid.MoveDirection
            
            if moveDirection.Magnitude > 0 then
                -- Split speed between CFrame and Velocity
                local cframeSpeed = speed * 0.6
                local velocitySpeed = speed * 0.4
                
                -- CFrame movement
                root.CFrame = root.CFrame + (moveDirection * (cframeSpeed / 30))
                
                -- Velocity boost
                root.AssemblyLinearVelocity = Vector3.new(
                    moveDirection.X * velocitySpeed,
                    root.AssemblyLinearVelocity.Y,
                    moveDirection.Z * velocitySpeed
                )
            else
                -- Stop smoothly
                root.AssemblyLinearVelocity = Vector3.new(
                    root.AssemblyLinearVelocity.X * 0.8,
                    root.AssemblyLinearVelocity.Y,
                    root.AssemblyLinearVelocity.Z * 0.8
                )
            end
        end
    end,
    
    -- Method 3: BodyPosition (advanced anticheat bypass)
    BodyPositionMethod = function(character, moveVector, speed)
        local root = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if root and humanoid then
            local bodyPos = root:FindFirstChild("SpeedBoostBodyPosition")
            if not bodyPos then
                bodyPos = Instance.new("BodyPosition")
                bodyPos.Name = "SpeedBoostBodyPosition"
                bodyPos.MaxForce = Vector3.new(4000, 0, 4000)
                bodyPos.D = 500
                bodyPos.P = 10000
                bodyPos.Parent = root
            end
            
            if humanoid.MoveDirection.Magnitude > 0 then
                bodyPos.Position = root.Position + (humanoid.MoveDirection * speed / 10)
            else
                bodyPos.Position = root.Position
            end
        end
    end,
    
    -- Method 4: WalkSpeed with spoofing
    SpoofedWalkSpeed = function(character, moveVector, speed)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Rapidly change walkspeed to avoid detection
            local variations = {speed * 0.9, speed, speed * 1.1}
            humanoid.WalkSpeed = variations[math.random(1, #variations)]
        end
    end
}

-- Advanced detection bypass
local function detectBestSpeedMethod()
    local character = Players.LocalPlayer.Character
    if not character then return "AdvancedCFrame" end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not root or not humanoid then return "AdvancedCFrame" end
    
    -- Test multiple properties
    local tests = {
        walkspeed = false,
        velocity = false,
        bodymovers = false
    }
    
    -- Test WalkSpeed
    local success = pcall(function()
        local old = humanoid.WalkSpeed
        humanoid.WalkSpeed = old + 1
        task.wait()
        humanoid.WalkSpeed = old
        tests.walkspeed = true
    end)
    
    -- Test Velocity
    success = pcall(function()
        local old = root.AssemblyLinearVelocity
        root.AssemblyLinearVelocity = old + Vector3.new(1, 0, 0)
        task.wait()
        root.AssemblyLinearVelocity = old
        tests.velocity = true
    end)
    
    -- Test BodyMovers
    success = pcall(function()
        local bp = Instance.new("BodyPosition")
        bp.Parent = root
        task.wait()
        bp:Destroy()
        tests.bodymovers = true
    end)
    
    -- Determine best method based on tests
    if tests.velocity and tests.bodymovers then
        return "HybridMethod"
    elseif tests.bodymovers then
        return "BodyPositionMethod"
    elseif tests.walkspeed then
        return "SpoofedWalkSpeed"
    else
        return "AdvancedCFrame"
    end
end

-- Anticheat bypass utilities
local function spoofNetworkOwnership()
    local character = Players.LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part ~= character.PrimaryPart then
                pcall(function()
                    part:SetNetworkOwner(Players.LocalPlayer)
                end)
            end
        end
    end
end

speedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    
    if speedEnabled then
        speedButton:SetAttribute("Active", true)
        TweenService:Create(speedStatus, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 200, 100)
        }):Play()
        TweenService:Create(speedIcon, TweenInfo.new(0.2), {
            ImageColor3 = Color3.fromRGB(255, 200, 100)
        }):Play()
        
        -- Show speed settings
        speedSettingsFrame.Visible = true
        
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local root = character:WaitForChild("HumanoidRootPart")
        
        -- Store original properties
        originalWalkSpeed = humanoid.WalkSpeed
        originalProperties = {
            WalkSpeed = humanoid.WalkSpeed,
            JumpPower = humanoid.JumpPower,
            Gravity = workspace.Gravity
        }
        
        -- Spoof network ownership
        spoofNetworkOwnership()
        
        -- Detect best method
        local methodName = detectBestSpeedMethod()
        local speedMethod = SpeedMethods[methodName]
        
        -- Clear old connections
        for _, conn in pairs(speedConnections) do
            if conn then conn:Disconnect() end
        end
        speedConnections = {}
        
        -- Main speed loop with multiple RunService connections
        speedConnections.render = RunService.RenderStepped:Connect(function()
            if not speedEnabled or not character.Parent then return end
            
            local moveVector = humanoid.MoveDirection
            speedMethod(character, moveVector, currentSpeedValue)
        end)
        
        -- Physics spoofing
        speedConnections.physics = RunService.Stepped:Connect(function()
            if not speedEnabled or not character.Parent then return end
            
            -- Keep character active
            if humanoid.MoveDirection.Magnitude > 0 then
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
            
            -- Prevent sleep
            root.AssemblyAngularVelocity = Vector3.new(0, 0.001, 0)
        end)
        
        -- Network bypass
        speedConnections.network = RunService.Heartbeat:Connect(function()
            if not speedEnabled or not character.Parent then return end
            
            -- Randomize properties slightly
            if math.random() > 0.95 then
                spoofNetworkOwnership()
            end
        end)
        
    else
        speedButton:SetAttribute("Active", false)
        TweenService:Create(speedStatus, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        }):Play()
        TweenService:Create(speedIcon, TweenInfo.new(0.2), {
            ImageColor3 = Color3.fromRGB(150, 150, 150)
        }):Play()
        
        -- Hide speed settings
        speedSettingsFrame.Visible = false
        
        -- Disconnect all
        for _, conn in pairs(speedConnections) do
            if conn then conn:Disconnect() end
        end
        speedConnections = {}
        
        -- Cleanup
        local character = Players.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local root = character:FindFirstChild("HumanoidRootPart")
            
            if root then
                -- Remove body movers
                for _, obj in pairs(root:GetChildren()) do
                    if obj.Name:find("SpeedBoost") then
                        obj:Destroy()
                    end
                end
                
                -- Reset velocity
                root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
            end
            
            if humanoid then
                humanoid.WalkSpeed = originalWalkSpeed
            end
        end
    end
end)

-- ESP functionality (improved)
local espEnabled = false
local espBoxes = {}
local espConnections = {}

local function addBox(player)
    if player == Players.LocalPlayer then return end
    
    local function createBox(char)
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        -- Remove old box if exists
        if espBoxes[player] then
            espBoxes[player]:Destroy()
        end
        
        local box = Instance.new("BoxHandleAdornment")
        box.Adornee = root
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Size = Vector3.new(4, 6, 2)
        box.Transparency = 0.5
        box.Color3 = Color3.new(1, 1, 1)
        box.Parent = CoreGui
        
        espBoxes[player] = box
    end
    
    if player.Character then
        createBox(player.Character)
    end
    
    -- Store connections for cleanup
    espConnections[player] = {
        player.CharacterAdded:Connect(function(char)
            if espEnabled then
                task.wait(0.5) -- Wait for character to load
                createBox(char)
            end
        end),
        
        player.CharacterRemoving:Connect(function()
            if espBoxes[player] then
                espBoxes[player]:Destroy()
                espBoxes[player] = nil
            end
        end)
    }
end

espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    
    if espEnabled then
        espButton:SetAttribute("Active", true)
        TweenService:Create(espStatus, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(200, 100, 255)
        }):Play()
        TweenService:Create(espIcon, TweenInfo.new(0.2), {
            ImageColor3 = Color3.fromRGB(200, 100, 255)
        }):Play()
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer then
                addBox(player)
            end
        end
        
        Players.PlayerAdded:Connect(function(player)
            if espEnabled and player ~= Players.LocalPlayer then
                addBox(player)
            end
        end)
    else
        espButton:SetAttribute("Active", false)
        TweenService:Create(espStatus, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        }):Play()
        TweenService:Create(espIcon, TweenInfo.new(0.2), {
            ImageColor3 = Color3.fromRGB(150, 150, 150)
        }):Play()
        
        -- Clean up all ESP
        for _, box in pairs(espBoxes) do
            if box then box:Destroy() end
        end
        espBoxes = {}
        
        -- Disconnect all connections
        for _, connections in pairs(espConnections) do
            for _, connection in pairs(connections) do
                connection:Disconnect()
            end
        end
        espConnections = {}
    end
end)

-- Initial slide-in animation
frame.Position = UDim2.new(1, 300, 0, 20)
TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out):Play()

-- Handle character respawn
Players.LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5) -- Wait for character to load
    
    -- Re-enable noclip if it was active
    if noclipEnabled or temporaryNoclipActive then
        enableSmartNoclip()
    end
    
    -- Re-enable speed if it was active
    if speedEnabled then
        -- Reset speed state and re-enable
        speedEnabled = false
        speedButton.MouseButton1Click:Fire()
    end
    
    -- Re-enable moon gravity if it was active
    if moonGravityEnabled then
        moonGravityEnabled = false
        gravityButton.MouseButton1Click:Fire()
    end
end)

-- Auto-save settings
local function saveSettings()
    if not isfolder("SynapseX") then
        makefolder("SynapseX")
    end
    
    local settings = {
        speedValue = currentSpeedValue,
        lastUpdated = os.date("%Y-%m-%d %H:%M:%S")
    }
    
    writefile("SynapseX/settings.json", game:GetService("HttpService"):JSONEncode(settings))
end

local function loadSettings()
    if isfile("SynapseX/settings.json") then
        local success, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile("SynapseX/settings.json"))
        end)
        
        if success and data then
            currentSpeedValue = data.speedValue or 100
            speedValueLabel.Text = "Speed: " .. tostring(currentSpeedValue)
            sliderButton.Position = UDim2.new((currentSpeedValue - 16) / (500 - 16), -10, 0, 0)
        end
    end
end

-- Load settings on startup
loadSettings()

-- Save settings when speed value changes
sliderButton.Changed:Connect(function()
    saveSettings()
end)

-- Performance optimization
local lastCleanup = tick()
RunService.Heartbeat:Connect(function()
    if tick() - lastCleanup > 60 then -- Clean up every minute
        lastCleanup = tick()
        
        -- Clean up disconnected ESP
        for player, box in pairs(espBoxes) do
            if not player.Parent or not box.Parent then
                if box.Parent then box:Destroy() end
                espBoxes[player] = nil
                
                -- Clean up connections
                if espConnections[player] then
                    for _, conn in pairs(espConnections[player]) do
                        conn:Disconnect()
                    end
                    espConnections[player] = nil
                end
            end
        end
    end
end)

-- Anti-lag measures
local function optimizePerformance()
    local character = Players.LocalPlayer.Character
    if character then
        -- Reduce physics calculations for far away parts
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Parent ~= character then
                local distance = (part.Position - character.HumanoidRootPart.Position).Magnitude
                if distance > 500 then
                    part.CanQuery = false
                    part.CanTouch = false
                end
            end
        end
    end
end

-- Run optimization every 30 seconds
spawn(function()
    while gui.Parent do
        task.wait(30)
        optimizePerformance()
    end
end)

-- Final initialization message
print("[SYNAPSE X] Script loaded successfully!")
print("[SYNAPSE X] Version: 2.1.0")
print("[SYNAPSE X] Created by: joker9292oo")
print("[SYNAPSE X] Last Updated: 2025-07-02")
print("[SYNAPSE X] Press INSERT to toggle UI")
