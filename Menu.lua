-- إنشاء الواجهة
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CoordTracker"
screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- الإطار الرئيسي
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 100)
frame.Position = UDim2.new(0, 50, 0.8, 0) -- يظهر أسفل اليسار
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.Parent = frame

-- نص الإحداثيات
local coordLabel = Instance.new("TextLabel")
coordLabel.Size = UDim2.new(1, 0, 0.6, 0)
coordLabel.BackgroundTransparency = 1
coordLabel.Text = "X: 0 | Y: 0 | Z: 0"
coordLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
coordLabel.Font = Enum.Font.GothamBold
coordLabel.TextSize = 16
coordLabel.Parent = frame

-- زر النسخ
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0.8, 0, 0.3, 0)
copyBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
copyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
copyBtn.Text = "Copy Coordinates"
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.Font = Enum.Font.Gotham
copyBtn.TextSize = 12
copyBtn.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 4)
btnCorner.Parent = copyBtn

-- وظيفة التحديث التلقائي
local player = game.Players.LocalPlayer
game:GetService("RunService").RenderStepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local pos = player.Character.HumanoidRootPart.Position
        -- تقريب الأرقام لسهولة القراءة
        local x = string.format("%.2f", pos.X)
        local y = string.format("%.2f", pos.Y)
        local z = string.format("%.2f", pos.Z)
        
        coordLabel.Text = "X: "..x.." | Y: "..y.." | Z: "..z
    end
end)

-- وظيفة النسخ (تنسخ بصيغة Vector3 جاهزة للكود)
copyBtn.MouseButton1Click:Connect(function()
    local pos = player.Character.HumanoidRootPart.Position
    local formattedPos = "Vector3.new("..pos.X..", "..pos.Y..", "..pos.Z..")"
    
    -- في روبلوكس لا يمكن الوصول للحافظة (Clipboard) مباشرة إلا عبر الـ Executor
    -- لذا سنطبعها في الكونسول (F9) ونغير اسم الزر مؤقتاً
    setclipboard(formattedPos) -- تعمل في أغلب الـ Executors
    copyBtn.Text = "Copied to Clipboard!"
    wait(1)
    copyBtn.Text = "Copy Coordinates"
end)
