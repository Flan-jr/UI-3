local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- الشاشة الرئيسية
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KengerAdvanced"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- [1] زر الفتح الصغير (يظهر عند إغلاق المنيو)
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 40, 0, 40)
openBtn.Position = UDim2.new(0, 10, 0.5, -20)
openBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
openBtn.Text = "K" -- شعار المنيو
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Visible = false -- مخفي في البداية
openBtn.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0) -- دائري تماماً
openCorner.Parent = openBtn

-- [2] المنيو الرئيسي (حجم أصغر)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 350)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Draggable = true
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 170, 255)
stroke.Thickness = 1.5
stroke.Parent = mainFrame

-- زر التصغير (_)
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -35, 0, 5)
minBtn.Text = "-"
minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Parent = mainFrame

minBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    openBtn.Visible = false
end)

--- [ قسم الرادار المطور ] ---
local radarLabel = Instance.new("TextLabel")
radarLabel.Size = UDim2.new(1, 0, 0, 30)
radarLabel.Position = UDim2.new(0, 0, 0.05, 0)
radarLabel.Text = "رادار اللاعبين (اضغط للتنقل)"
radarLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
radarLabel.BackgroundTransparency = 1
radarLabel.Font = Enum.Font.GothamBold
radarLabel.Parent = mainFrame

local radarScroll = Instance.new("ScrollingFrame")
radarScroll.Size = UDim2.new(0.9, 0, 0.5, 0)
radarScroll.Position = UDim2.new(0.05, 0, 0.15, 0)
radarScroll.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
radarScroll.BorderSizePixel = 0
radarScroll.CanvasSize = UDim2.new(0, 0, 5, 0)
radarScroll.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.Parent = radarScroll

-- وظيفة تحديث الرادار مع ميزة التلي بورت
local function updateRadar()
    for _, v in pairs(radarScroll:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            btn.Text = p.DisplayName .. " (@" .. p.Name .. ")"
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 12
            btn.Parent = radarScroll
            
            local bCorner = Instance.new("UICorner")
            bCorner.Parent = btn
            
            -- عند الضغط على اسم اللاعب
            btn.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character:MoveTo(p.Character.HumanoidRootPart.Position)
                    btn.Text = "تم الانتقال! ✅"
                    wait(1)
                    btn.Text = p.DisplayName
                end
            end)
        end
    end
end

-- تحديث تلقائي كل 3 ثوانٍ للرادار
spawn(function()
    while true do
        updateRadar()
        wait(3)
    end
end)

--- [ قسم الإحداثيات ] ---
local myPosLabel = Instance.new("TextLabel")
myPosLabel.Size = UDim2.new(0.9, 0, 0, 40)
myPosLabel.Position = UDim2.new(0.05, 0, 0.7, 0)
myPosLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
myPosLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
myPosLabel.Text = "X: 0 | Y: 0 | Z: 0"
myPosLabel.Font = Enum.Font.Code
myPosLabel.Parent = mainFrame

RunService.RenderStepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local pos = player.Character.HumanoidRootPart.Position
        myPosLabel.Text = string.format("X: %.1f | Y: %.1f | Z: %.1f", pos.X, pos.Y, pos.Z)
    end
end)
