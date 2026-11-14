-- ==========================================
-- 脚本名称: LMM fps (纯直角正方形 & 可自由拖动悬浮球)
-- ==========================================

-- 清理旧的 UI（避免重复运行叠加）
pcall(function()
    local existingGui = game:GetService("CoreGui"):FindFirstChild("LMM_FPS_Gui")
    if existingGui then existingGui:Destroy() end
    local playerGui = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
    if playerGui then
        local old = playerGui:FindFirstChild("LMM_FPS_Gui")
        if old then old:Destroy() end
    end
end)

-- 创建核心 UI 根节点
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LMM_FPS_Gui"
ScreenGui.ResetOnSpawn = false
pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- ==========================================
-- 1. 主面板 (MainFrame - 纯正方形、无圆角、半透明、可拖动)
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 220) -- 正常尺寸 (220x220)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -110) -- 屏幕居中
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BackgroundTransparency = 0.35 -- 半透明
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- 确保全程可拖动
MainFrame.Parent = ScreenGui
-- 注意：这里不加 UICorner，保持纯正方形直角

-- 标题标签
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -70, 0, 40)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "LMM FPS"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

-- 按钮: - (正方形直角、半透明)
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Position = UDim2.new(1, -60, 0, 8)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeButton.BackgroundTransparency = 0.35
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 16
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Parent = MainFrame

-- 按钮: X (正方形直角、半透明)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 8)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BackgroundTransparency = 0.35
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0
CloseButton.Parent = MainFrame

-- 内部功能按钮容器
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, 0, 1, -40)
ContentContainer.Position = UDim2.new(0, 0, 0, 40)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- 悬浮球模式下的显示文本标签（正方形直角、显示 "FPS"）
local BallLabel = Instance.new("TextLabel")
BallLabel.Name = "BallLabel"
BallLabel.Size = UDim2.new(1, 0, 1, 0)
BallLabel.BackgroundTransparency = 1
BallLabel.Text = "FPS"
BallLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
BallLabel.TextSize = 14
BallLabel.Font = Enum.Font.GothamBold
BallLabel.Visible = false
BallLabel.Parent = MainFrame

-- 按钮 1: FPS Boosts (正方形直角风格)
local BoostButton = Instance.new("TextButton")
BoostButton.Name = "BoostButton"
BoostButton.Size = UDim2.new(0, 180, 0, 55)
BoostButton.Position = UDim2.new(0.5, -90, 0, 20)
BoostButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
BoostButton.BackgroundTransparency = 0.2
BoostButton.Text = "FPS Boosts"
BoostButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BoostButton.TextSize = 14
BoostButton.Font = Enum.Font.GothamSemibold
BoostButton.BorderSizePixel = 0
BoostButton.Parent = ContentContainer

-- 按钮 2: 切换 FPS 显示按钮 (正方形直角风格)
local ToggleFpsButton = Instance.new("TextButton")
ToggleFpsButton.Name = "ToggleFpsButton"
ToggleFpsButton.Size = UDim2.new(0, 180, 0, 55)
ToggleFpsButton.Position = UDim2.new(0.5, -90, 0, 90)
ToggleFpsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleFpsButton.BackgroundTransparency = 0.2
ToggleFpsButton.Text = "开启 FPS 显示"
ToggleFpsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleFpsButton.TextSize = 14
ToggleFpsButton.Font = Enum.Font.GothamSemibold
ToggleFpsButton.BorderSizePixel = 0
ToggleFpsButton.Parent = ContentContainer


-- ==========================================
-- 2. 独立全透明 FPS 显示面板 (FpsFrame - 可拖动、纯正方形)
-- ==========================================
local FpsFrame = Instance.new("Frame")
FpsFrame.Name = "FpsFrame"
FpsFrame.Size = UDim2.new(0, 120, 0, 50)
FpsFrame.Position = UDim2.new(0.5, -60, 0.2, 0)
FpsFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FpsFrame.BackgroundTransparency = 1 -- 完全透明
FpsFrame.BorderSizePixel = 0
FpsFrame.Active = true
FpsFrame.Draggable = true
FpsFrame.Visible = false
FpsFrame.Parent = ScreenGui

local FpsDisplayLabel = Instance.new("TextLabel")
FpsDisplayLabel.Name = "FpsDisplayLabel"
FpsDisplayLabel.Size = UDim2.new(1, 0, 1, 0)
FpsDisplayLabel.BackgroundTransparency = 1
FpsDisplayLabel.Text = "FPS: --"
FpsDisplayLabel.TextSize = 18
FpsDisplayLabel.Font = Enum.Font.GothamBold
FpsDisplayLabel.Parent = FpsFrame


-- ==========================================
-- 3. 交互逻辑实现
-- ==========================================

-- 关闭按钮 (X)
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- 最小化切换按钮 (-) -> 变成 50x50 的纯正方形悬浮球
local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = true
    MainFrame.Size = UDim2.new(0, 50, 0, 50) -- 50x50 正方形小悬浮球
    TitleLabel.Visible = false
    MinimizeButton.Visible = false
    CloseButton.Visible = false
    ContentContainer.Visible = false
    BallLabel.Visible = true
end)

-- 点击悬浮球恢复大面板（采用严格判定：只有纯点击、不发生位移时才展开，完美不影响拖动）
local clickCheckPos = nil
MainFrame.InputBegan:Connect(function(input)
    if isMinimized and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        clickCheckPos = MainFrame.AbsolutePosition
    end
end)

MainFrame.InputEnded:Connect(function(input)
    if isMinimized and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        if clickCheckPos and (MainFrame.AbsolutePosition - clickCheckPos).Magnitude < 5 then
            -- 判定为点击而不是拖动，展开面板
            isMinimized = false
            MainFrame.Size = UDim2.new(0, 220, 0, 220)
            TitleLabel.Visible = true
            MinimizeButton.Visible = true
            CloseButton.Visible = true
            ContentContainer.Visible = true
            BallLabel.Visible = false
        end
        clickCheckPos = nil
    end
end)

-- FPS Boosts 按钮逻辑
BoostButton.MouseButton1Click:Connect(function()
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.CastShadow = false
            end
        end
    end)
    BoostButton.Text = "已优化!"
    task.wait(1.5)
    BoostButton.Text = "FPS Boosts"
end)

-- 独立 FPS 面板显示开关逻辑
local fpsShowing = false
local runService = game:GetService("RunService")
local connection = nil

ToggleFpsButton.MouseButton1Click:Connect(function()
    fpsShowing = not fpsShowing
    if fpsShowing then
        ToggleFpsButton.Text = "关闭 FPS 显示"
        ToggleFpsButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        FpsFrame.Visible = true
        
        local lastTime = tick()
        local frameCount = 0
        
        connection = runService.RenderStepped:Connect(function()
            frameCount = frameCount + 1
            local currentTime = tick()
            
            if currentTime - lastTime >= 1 then
                local fps = math.floor(frameCount / (currentTime - lastTime))
                FpsDisplayLabel.Text = "FPS: " .. tostring(fps)
                frameCount = 0
                lastTime = currentTime
            end
            
            -- RGB 动态变色效果
            local hue = (currentTime % 5) / 5
            FpsDisplayLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
        end)
    else
        ToggleFpsButton.Text = "开启 FPS 显示"
        ToggleFpsButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        FpsFrame.Visible = false
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
end)
