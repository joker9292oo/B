-- Speed Modifier Script with GUI
-- For educational/entertainment purposes only

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Anti-detection measures
local mt = getrawmetatable(game)
local oldIndex = mt.__index
local oldNewIndex = mt.__newindex
setreadonly(mt, false)

-- GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpeedModifierGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui") or player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 150)
mainFrame.Position = UDim2.new(1, -210, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Add rounded corners
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "Speed Modifier"
titleLabel.Size = UDim2.new(1, -30, 1, 0)
titleLabel.Position = UDim2.new(0, 5, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = titleBar

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Text = "-"
minimizeButton.Size = UDim2.new(0, 25, 0, 25)
minimizeButton.Position = UDim2.new(1, -27, 0, 2.5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextScaled = true
minimizeButton.Parent = titleBar

local minButtonCorner = Instance.new("UICorner")
minButtonCorner.CornerRadius = UDim.new(0, 4)
minButtonCorner.Parent = minimizeButton

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -10, 1, -35)
contentFrame.Position = UDim2.new(0, 5, 0, 30)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Speed Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Text = "Speed: 16"
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 0, 0, 5)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.SourceSans
speedLabel.TextScaled = true
speedLabel.Parent = contentFrame

-- Speed Slider
local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(1, 0, 0, 20)
sliderFrame.Position = UDim2.new(0, 0, 0, 30)
sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sliderFrame.Parent = contentFrame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 10)
sliderCorner.Parent = sliderFrame

local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0, 20, 1, 0)
sliderButton.Position = UDim2.new(0, 0, 0, 0)
sliderButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
sliderButton.Text = ""
sliderButton.Parent = sliderFrame

local sliderButtonCorner = Instance.new("UICorner")
sliderButtonCorner.CornerRadius = UDim.new(0, 10)
sliderButtonCorner.Parent = sliderButton

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Text = "Enable"
toggleButton.Size = UDim2.new(1, 0, 0, 30)
toggleButton.Position = UDim2.new(0, 0, 0, 60)
toggleButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextScaled = true
toggleButton.Parent = contentFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleButton

-- Variables
local isMinimized = false
local isEnabled = false
local currentSpeed = 16
local minSpeed = 16
local maxSpeed = 500
local connection

-- Functions
local function updateSpeed(value)
    currentSpeed = math.floor(minSpeed + (maxSpeed - minSpeed) * value)
    speedLabel.Text = "Speed: " .. tostring(currentSpeed)
end

local function setSpeed()
    if character and humanoid then
        -- Multiple methods to bypass detection
        pcall(function()
            humanoid.WalkSpeed = currentSpeed
        end)
        
        -- Backup method
        pcall(function()
            character:SetAttribute("WalkSpeed", currentSpeed)
        end)
    end
end

-- Slider functionality
local dragging = false

sliderButton.MouseButton1Down:Connect(function()
    dragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UserInputService:GetMouseLocation()
        local framePos = sliderFrame.AbsolutePosition
        local frameSize = sliderFrame.AbsoluteSize
        
        local relativeX = math.clamp((mousePos.X - framePos.X) / frameSize.X, 0, 1)
        sliderButton.Position = UDim2.new(relativeX - 0.05, 0, 0, 0)
        
        updateSpeed(relativeX)
        
        if isEnabled then
            setSpeed()
        end
    end
end)

-- Toggle functionality
toggleButton.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    
    if isEnabled then
        toggleButton.Text = "Disable"
        toggleButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
        
        -- Start speed modification
        connection = RunService.Heartbeat:Connect(function()
            setSpeed()
        end)
    else
        toggleButton.Text = "Enable"
        toggleButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        
        -- Stop speed modification
        if connection then
            connection:Disconnect()
        end
        
        -- Reset to default
        pcall(function()
            humanoid.WalkSpeed = 16
        end)
    end
end)

-- Minimize functionality
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        minimizeButton.Text = "+"
        contentFrame.Visible = false
        mainFrame.Size = UDim2.new(0, 200, 0, 30)
    else
        minimizeButton.Text = "-"
        contentFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 200, 0, 150)
    end
end)

-- Handle character respawn
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
end)

-- Anti-kick measures
mt.__index = function(self, key)
    if key == "WalkSpeed" and self == humanoid and isEnabled then
        return 16 -- Return default speed to game checks
    end
    return oldIndex(self, key)
end

mt.__newindex = function(self, key, value)
    if key == "WalkSpeed" and self == humanoid and isEnabled then
        return -- Prevent external speed changes
    end
    return oldNewIndex(self, key, value)
end

setreadonly(mt, true)

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Speed Modifier",
    Text = "Loaded successfully!",
    Duration = 3
})
