local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local webhookUrl = "ضع_رابط_الويب_هوك_هنا"

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

-- 1. إضافة مربع النص (TextBox)
local feedbackBox = Instance.new("TextBox")
feedbackBox.Size = UDim2.new(0.85, 0, 0, 80) -- جعلناه أكبر للكتابة المريحة
feedbackBox.Position = UDim2.new(0.075, 0, 0.35, 0)
feedbackBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
feedbackBox.PlaceholderText = "اكتب اقتراحك أو البلاغ هنا..."
feedbackBox.Text = ""
feedbackBox.TextWrapped = true -- لجعل النص ينزل لسطر جديد
feedbackBox.TextColor3 = Color3.fromRGB(255, 255, 255)
feedbackBox.Font = Enum.Font.Gotham
feedbackBox.TextSize = 14
feedbackBox.ClearTextOnFocus = false
feedbackBox.Parent = mainFrame

local boxCorner = Instance.new("UICorner")
boxCorner.Parent = feedbackBox

-- 2. زر الإرسال المنسق
local sendBtn = Instance.new("TextButton")
sendBtn.Size = UDim2.new(0.85, 0, 0, 40)
sendBtn.Position = UDim2.new(0.075, 0, 0.75, 0)
sendBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
sendBtn.Text = "إرسال الـ Feedback 🚀"
sendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
sendBtn.Font = Enum.Font.GothamBold
sendBtn.TextSize = 16
sendBtn.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.Parent = sendBtn

-- 3. وظيفة إرسال البيانات المنظمة (Webhook Embed)
sendBtn.MouseButton1Click:Connect(function()
    local message = feedbackBox.Text
    
    if #message < 5 then
        sendBtn.Text = "الرسالة قصيرة جداً! ❌"
        wait(1.5)
        sendBtn.Text = "إرسال الـ Feedback 🚀"
        return
    end

    local data = {
        ["embeds"] = {{
            ["title"] = "📩 Feedback جديد وصل!",
            ["description"] = "لقد أرسل أحد المستخدمين رسالة جديدة من المنيو الخاص بك.",
            ["color"] = 65443, -- لون نيون أخضر
            ["fields"] = {
                {["name"] = "👤 اسم اللاعب", ["value"] = player.Name .. " (" .. player.UserId .. ")", ["inline"] = true},
                {["name"] = "🎮 الماب", ["value"] = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, ["inline"] = true},
                {["name"] = "📝 الرسالة", ["value"] = "```" .. message .. "```", ["inline"] = false},
                {["name"] = "🔗 بروفايل اللاعب", ["value"] = "[اضغط هنا](https://www.roblox.com/users/" .. player.UserId .. "/profile)", ["inline"] = false}
            },
            ["footer"] = {["text"] = "Kenger System • " .. os.date("%X")},
            ["thumbnail"] = {["url"] = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"}
        }}
    }

    local jsonData = HttpService:JSONEncode(data)
    local proxyUrl = webhookUrl:gsub("discord.com", "hooks.hyra.io") -- ضروري لتجاوز حظر روبلوكس

    local success, err = pcall(function()
        HttpService:PostAsync(proxyUrl, jsonData)
    end)

    if success then
        sendBtn.BackgroundColor3 = Color3.fromRGB(85, 255, 127)
        sendBtn.Text = "تم الإرسال بنجاح! ✅"
        feedbackBox.Text = ""
    else
        sendBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
        sendBtn.Text = "خطأ في الإرسال! ⚠️"
        warn("Error: " .. err)
    end

    wait(2)
    sendBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    sendBtn.Text = "إرسال الـ Feedback 🚀"
end)
