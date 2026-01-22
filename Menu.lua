local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- الشاشة الرئيسية
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KengerUltra"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- [1] زر الفتح الصغير (عند التصغير)
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 50, 0, 50)
openBtn.Position = UDim2.new(0, 15, 0.5, -25)
openBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
openBtn.Text = "K"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.TextSize = 25
openBtn.Font = Enum.Font.GothamBold
openBtn.Visible = false
openBtn.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0)
openCorner.Parent = openBtn

-- [2] المنيو الرئيسي
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 480)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
mainFrame.BorderSizePixel = 0
mainFrame.Draggable = true
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 170, 255)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- زر التصغير (_)
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 35, 0, 35)
minBtn.Position = UDim2.new(1, -40, 0, 5)
minBtn.Text = "-"
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 20
minBtn.Parent = mainFrame

minBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    openBtn.Visible = false
end)

--- [3] قسم حفظ المواقع (Waypoints) ---
local saveTitle = Instance.new("TextLabel")
saveTitle.Size = UDim2.new(1, 0, 0, 30)
saveTitle.Position = UDim2.new(0, 0, 0.02, 0)
saveTitle.Text = "حفظ المواقع (Waypoints)"
saveTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
saveTitle.Font = Enum.Font.GothamBold
saveTitle.TextSize = 14
saveTitle.BackgroundTransparency = 1
saveTitle.Parent = mainFrame

local locationName = Instance.new("TextBox")
locationName.Size = UDim2.new(0.65, 0, 0, 35)
locationName.Position = UDim2.new(0.05, 0, 0.08, 0)
locationName.PlaceholderText = "اسم المكان هنا..."
locationName.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
locationName.TextColor3 = Color3.fromRGB(255, 255, 255)
locationName.Font = Enum.Font.GothamBold
locationName.TextSize = 14
locationName.Parent = mainFrame

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0.2, 0, 0, 35)
saveBtn.Position = UDim2.new(0.75, 0, 0.08, 0)
saveBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
saveBtn.Text = "حفظ"
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveBtn.Parent = mainFrame

local waypointsScroll = Instance.new("ScrollingFrame")
waypointsScroll.Size = UDim2.new(0.9, 0, 0, 100)
waypointsScroll.Position = UDim2.new(0.05, 0, 0.17, 0)
waypointsScroll.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
waypointsScroll.BorderSizePixel = 0
waypointsScroll.CanvasSize = UDim2.new(0, 0, 5, 0)
waypointsScroll.Parent = mainFrame

local wayLayout = Instance.new("UIListLayout")
wayLayout.Padding = UDim.new(0, 5)
wayLayout.Parent = waypointsScroll

--- [4] قسم رادار اللاعبين ---
local radarTitle = Instance.new("TextLabel")
radarTitle.Size = UDim2.new(1, 0, 0, 30)
radarTitle.Position = UDim2.new(0, 0, 0.4, 0)
radarTitle.Text = "رادار اللاعبين (اضغط للتنقل)"
radarTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
radarTitle.Font = Enum.Font.GothamBold
radarTitle.TextSize = 14
radarTitle.BackgroundTransparency = 1
radarTitle.Parent = mainFrame

local radarScroll = Instance.new("ScrollingFrame")
radarScroll.Size = UDim2.new(0.9, 0, 0, 150)
radarScroll.Position = UDim2.new(0.05, 0, 0.47, 0)
radarScroll.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
radarScroll.BorderSizePixel = 0
radarScroll.CanvasSize = UDim2.new(0, 0, 5, 0)
radarScroll.Parent = mainFrame

local radLayout = Instance.new("UIListLayout")
radLayout.Padding = UDim.new(0, 5)
radLayout.Parent = radarScroll

--- [5] عرض إحداثياتي الحالية ---
local myPosBox = Instance.new("Frame")
myPosBox.Size = UDim2.new(0.9, 0, 0, 50)
myPosBox.Position = UDim2.new(0.05, 0, 0.83, 0)
myPosBox.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
myPosBox.Parent = mainFrame

local posText = Instance.new("TextLabel")
posText.Size = UDim2.new(1, 0, 1, 0)
posText.BackgroundTransparency = 1
posText.Text = "X: 0 | Y: 0 | Z: 0"
posText.TextColor3 = Color3.fromRGB(0, 200, 255)
posText.Font = Enum.Font.GothamBold
posText.TextSize = 16
posText.Parent = myPosBox

-- وظيفة حفظ المواقع
saveBtn.MouseButton1Click:Connect(function()
    local name = locationName.Text
    if name ~= "" and player.Character then
        local currentPos = player.Character.HumanoidRootPart.Position
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 35)
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        btn.Text = "📍 " .. name
        btn.Font = Enum.Font.GothamBold
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Parent = waypointsScroll
        
        btn.MouseButton1Click:Connect(function()
            player.Character:MoveTo(currentPos)
        end)
        
        locationName.Text = ""
    end
end)

-- وظيفة تحديث الرادار
local function updateRadar()
    for _, v in pairs(radarScroll:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 35)
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            btn.Text = "👤 " .. p.DisplayName
            btn.Font = Enum.Font.GothamBold
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.Parent = radarScroll
            
            btn.MouseButton1Click:Connect(function()
                player.Character:MoveTo(p.Character.HumanoidRootPart.Position)
            end)
        end
    end
end

-- تحديث إحداثياتي والرادار
RunService.RenderStepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local p = player.Character.HumanoidRootPart.Position
        posText.Text = string.format("X: %.1f | Y: %.1f | Z: %.1f", p.X, p.Y, p.Z)
    end
end)

spawn(function()
    while wait(3) do updateRadar() end
end)
