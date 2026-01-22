local HttpService = game:GetService("HttpService")
local url = "https://discord.com/api/webhooks/1463908805170696243/mbHmgwS_AfwzC9RzNHJXFV1APo_l4XAwHQ5P7mYsayAeXDKePMT-e9bRfgfiqx8Tt_iw"

-- إنشاء الشاشة الرئيسية
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KengerHubV2"
screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- الإطار الرئيسي (المنيو)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 250)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- إضافة زوايا دائرية وإطار نيون
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(0, 170, 255)
uiStroke.Thickness = 1.5
uiStroke.Parent = mainFrame

-- شريط العنوان (الجزء المسؤول عن السحب)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundTransparency = 1 -- شفاف لكنه موجود للسحب
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "KENGER HUB PRO"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.Parent = titleBar

-- زر الإغلاق (X)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy() -- يحذف الواجهة تماماً عند الضغط
end)

-- *** كود تحريك المنيو (Draggable Script) ***
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- إنشاء مربع النص (TextBox) للكتابة
local messageBox = Instance.new("TextBox")
messageBox.Size = UDim2.new(0.8, 0, 0, 40)
messageBox.Position = UDim2.new(0.1, 0, 0.4, 0)
messageBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
messageBox.PlaceholderText = "اكتب رسالتك هنا..."
messageBox.Text = ""
messageBox.TextColor3 = Color3.fromRGB(255, 255, 255)
messageBox.Font = Enum.Font.Gotham
messageBox.TextSize = 14
messageBox.Parent = mainFrame

local boxCorner = Instance.new("UICorner")
boxCorner.Parent = messageBox

-- إنشاء زر الإرسال
local sendButton = Instance.new("TextButton")
sendButton.Size = UDim2.new(0.8, 0, 0, 40)
sendButton.Position = UDim2.new(0.1, 0, 0.6, 0)
sendButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
sendButton.Text = "إرسال إلى ديسكورد"
sendButton.TextColor3 = Color3.fromRGB(255, 255, 255)
sendButton.Font = Enum.Font.GothamBold
sendButton.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.Parent = sendButton

-- وظيفة الإرسال
sendButton.MouseButton1Click:Connect(function()
    local message = messageBox.Text
    
    if message ~= "" then
        local data = {
            ["content"] = "وصلت رسالة جديدة من المنيو:\n**" .. message .. "**",
            ["username"] = "Kenger Bot"
        }
        
        -- تحويل البيانات إلى JSON وإرسالها
        local jsonData = HttpService:JSONEncode(data)
        
        -- ملاحظة: الويب هوك المباشر قد لا يعمل في روبلوكس بدون بروكزي (Proxy)
        -- سأستخدم لك بروكزي بسيط مشهور (hooks.hyra.io) لضمان العمل
        local finalUrl = url:gsub("discord.com", "hooks.hyra.io")
        
        pcall(function()
            HttpService:PostAsync(finalUrl, jsonData)
        end)
        
        sendButton.Text = "تم الإرسال ✅"
        messageBox.Text = ""
        wait(2)
        sendButton.Text = "إرسال إلى ديسكورد"
    else
        sendButton.Text = "اكتب شيئاً أولاً! ⚠️"
        wait(1)
        sendButton.Text = "إرسال إلى ديسكورد"
    end
end)
