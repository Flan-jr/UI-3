local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- إعداد الواجهة الرئيسية
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KengerMasterTool"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 450, 0, 400)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.Parent = mainFrame

-- العنوان وزر الإغلاق
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "KENGER ADMIN TOOL | COORDS & RADAR"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

--- [1. قسم الإحداثيات الحالية والحفظ] ---
local currentCoordLabel = Instance.new("TextLabel")
currentCoordLabel.Size = UDim2.new(0.9, 0, 0, 30)
currentCoordLabel.Position = UDim2.new(0.05, 0, 0.12, 0)
currentCoordLabel.Text = "My Pos: X:0 Y:0 Z:0"
currentCoordLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
currentCoordLabel.BackgroundTransparency = 1
currentCoordLabel.Font = Enum.Font.GothamMedium
currentCoordLabel.Parent = mainFrame

local locationNameBox = Instance.new("TextBox")
locationNameBox.Size = UDim2.new(0.6, 0, 0, 35)
locationNameBox.Position = UDim2.new(0.05, 0, 0.2, 0)
locationNameBox.PlaceholderText = "اسم المكان (مثلاً: القاعدة)"
locationNameBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
locationNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
locationNameBox.Parent = mainFrame

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0.25, 0, 0, 35)
saveBtn.Position = UDim2.new(0.7, 0, 0.2, 0)
saveBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
saveBtn.Text = "حفظ الموقع"
saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveBtn.Parent = mainFrame

--- [2. قائمة المواقع المحفوظة] ---
local savedScroll = Instance.new("ScrollingFrame")
savedScroll.Size = UDim2.new(0.45, 0, 0, 220)
savedScroll.Position = UDim2.new(0.05, 0, 0.35, 0)
savedScroll.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
savedScroll.CanvasSize = UDim2.new(0, 0, 5, 0)
savedScroll.Parent = mainFrame

local savedLayout = Instance.new("UIListLayout")
savedLayout.Padding = UDim.new(0, 5)
savedLayout.Parent = savedScroll

--- [3. قائمة رادار اللاعبين] ---
local radarScroll = Instance.new("ScrollingFrame")
radarScroll.Size = UDim2.new(0.4, 0, 0, 220)
radarScroll.Position = UDim2.new(0.55, 0, 0.35, 0)
radarScroll.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
radarScroll.CanvasSize = UDim2.new(0, 0, 5, 0)
radarScroll.Parent = mainFrame

local radarLayout = Instance.new("UIListLayout")
radarLayout.Parent = radarScroll

local radarTitle = Instance.new("TextLabel")
radarTitle.Size = UDim2.new(0.4, 0, 0, 20)
radarTitle.Position = UDim2.new(0.55, 0, 0.3, 0)
radarTitle.Text = "رادار اللاعبين"
radarTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
radarTitle.BackgroundTransparency = 1
radarTitle.Parent = mainFrame

--- [وظائف البرمجة] ---

-- تحديث إحداثياتي
RunService.RenderStepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local p = player.Character.HumanoidRootPart.Position
        currentCoordLabel.Text = string.format("My Pos: X:%.1f Y:%.1f Z:%.1f", p.X, p.Y, p.Z)
    end
end)

-- وظيفة الحفظ والتليبورت
local function createWaypoint(name, pos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = name .. " (TP)"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = savedScroll
    
    btn.MouseButton1Click:Connect(function()
        if player.Character then
            player.Character:MoveTo(pos)
        end
    end)
end

saveBtn.MouseButton1Click:Connect(function()
    local name = locationNameBox.Text
    if name ~= "" and player.Character then
        local pos = player.Character.HumanoidRootPart.Position
        createWaypoint(name, pos)
        locationNameBox.Text = ""
    end
end)

-- تحديث الرادار (كل ثانية)
spawn(function()
    while wait(1) do
        -- مسح القائمة القديمة
        for _, v in pairs(radarScroll:GetChildren()) do
            if v:IsA("TextLabel") then v:Destroy() end
        end
        
        -- إضافة اللاعبين
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local pos = p.Character.HumanoidRootPart.Position
                local dist = math.floor((player.Character.HumanoidRootPart.Position - pos).Magnitude)
                
                local pLabel = Instance.new("TextLabel")
                pLabel.Size = UDim2.new(1, 0, 0, 25)
                pLabel.BackgroundTransparency = 1
                pLabel.Text = string.format("%s: [%d, %d, %d] (%dm)", p.Name, pos.X, pos.Y, pos.Z, dist)
                pLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                pLabel.TextSize = 10
                pLabel.Parent = radarScroll
            end
        end
    end
end)
