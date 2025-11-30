-- UI Library for Roblox Injectors
-- Designed for execution through various injectors

local Rayfield = {}
Rayfield.__index = Rayfield

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Local references
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Library configuration
Rayfield.Themes = {
    Dark = {
        Main = Color3.fromRGB(25, 25, 25),
        Secondary = Color3.fromRGB(35, 35, 35),
        Accent = Color3.fromRGB(0, 85, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 200)
    },
    Light = {
        Main = Color3.fromRGB(240, 240, 240),
        Secondary = Color3.fromRGB(220, 220, 220),
        Accent = Color3.fromRGB(0, 85, 255),
        Text = Color3.fromRGB(0, 0, 0),
        TextSecondary = Color3.fromRGB(80, 80, 80)
    }
}

function Rayfield:CreateWindow(options)
    options = options or {}
    local window = {
        Name = options.Name or "UI Library",
        Theme = options.Theme or "Dark",
        ToggleKey = options.ToggleKey or Enum.KeyCode.RightShift
    }
    
    setmetatable(window, self)
    
    -- Create main screen GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RayfieldUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
    
    window.ScreenGui = ScreenGui
    
    -- Apply theme
    window:ApplyTheme(window.Theme)
    
    -- Create main frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainFrame.BackgroundColor3 = window.CurrentTheme.Main
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Corner
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = MainFrame
    
    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 44, 1, 44)
    Shadow.Position = UDim2.new(0, -22, 0, -22)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ImageColor3 = Color3.new(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.Parent = MainFrame
    
    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = window.CurrentTheme.Secondary
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -20, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = window.Name
    Title.TextColor3 = window.CurrentTheme.Text
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    
    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = window.CurrentTheme.Main
    CloseButton.Text = "X"
    CloseButton.TextColor3 = window.CurrentTheme.Text
    CloseButton.TextSize = 14
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton
    
    -- Tab container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, -20, 1, -60)
    TabContainer.Position = UDim2.new(0, 10, 0, 50)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame
    
    window.MainFrame = MainFrame
    window.TabContainer = TabContainer
    window.Tabs = {}
    
    -- Make window draggable
    local dragging = false
    local dragInput, dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Close button functionality
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Toggle key
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == window.ToggleKey then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)
    
    return window
end

function Rayfield:ApplyTheme(themeName)
    self.CurrentTheme = self.Themes[themeName] or self.Themes.Dark
end

function Rayfield:CreateTab(options)
    options = options or {}
    local tab = {
        Name = options.Name or "Tab",
        Icon = options.Icon or ""
    }
    
    -- Create tab button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = "TabButton"
    TabButton.Size = UDim2.new(0, 100, 0, 30)
    TabButton.Position = UDim2.new(0, 10 + (#self.Tabs * 110), 0, 10)
    TabButton.BackgroundColor3 = self.CurrentTheme.Secondary
    TabButton.TextColor3 = self.CurrentTheme.Text
    TabButton.Text = tab.Name
    TabButton.TextSize = 14
    TabButton.Font = Enum.Font.Gotham
    TabButton.Parent = self.MainFrame
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton
    
    -- Create tab frame
    local TabFrame = Instance.new("ScrollingFrame")
    TabFrame.Name = "TabFrame"
    TabFrame.Size = UDim2.new(1, 0, 1, 0)
    TabFrame.BackgroundTransparency = 1
    TabFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    TabFrame.ScrollBarThickness = 3
    TabFrame.ScrollBarImageColor3 = self.CurrentTheme.Accent
    TabFrame.Visible = false
    TabFrame.Parent = self.TabContainer
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = TabFrame
    
    tab.Button = TabButton
    tab.Frame = TabFrame
    
    table.insert(self.Tabs, tab)
    
    -- Show first tab by default
    if #self.Tabs == 1 then
        TabFrame.Visible = true
        TabButton.BackgroundColor3 = self.CurrentTheme.Accent
    end
    
    -- Tab switching
    TabButton.MouseButton1Click:Connect(function()
        for _, otherTab in pairs(self.Tabs) do
            otherTab.Frame.Visible = false
            otherTab.Button.BackgroundColor3 = self.CurrentTheme.Secondary
        end
        TabFrame.Visible = true
        TabButton.BackgroundColor3 = self.CurrentTheme.Accent
    end)
    
    return tab
end

function Rayfield:CreateSection(tab, options)
    options = options or {}
    local section = {
        Name = options.Name or "Section"
    }
    
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Name = "SectionFrame"
    SectionFrame.Size = UDim2.new(1, -20, 0, 40)
    SectionFrame.BackgroundColor3 = self.CurrentTheme.Secondary
    SectionFrame.Parent = tab.Frame
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 6)
    SectionCorner.Parent = SectionFrame
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Name = "SectionTitle"
    SectionTitle.Size = UDim2.new(1, -20, 1, 0)
    SectionTitle.Position = UDim2.new(0, 10, 0, 0)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = section.Name
    SectionTitle.TextColor3 = self.CurrentTheme.Text
    SectionTitle.TextSize = 16
    SectionTitle.Font = Enum.Font.GothamSemibold
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = SectionFrame
    
    section.Frame = SectionFrame
    
    return section
end

function Rayfield:CreateButton(section, options)
    options = options or {}
    local button = {
        Name = options.Name or "Button",
        Callback = options.Callback or function() end
    }
    
    local Button = Instance.new("TextButton")
    Button.Name = "Button"
    Button.Size = UDim2.new(1, -20, 0, 35)
    Button.BackgroundColor3 = self.CurrentTheme.Main
    Button.TextColor3 = self.CurrentTheme.Text
    Button.Text = button.Name
    Button.TextSize = 14
    Button.Font = Enum.Font.Gotham
    Button.Parent = section.Frame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    -- Adjust section height
    section.Frame.Size = UDim2.new(1, -20, 0, section.Frame.Size.Y.Offset + 45)
    
    Button.MouseButton1Click:Connect(function()
        button.Callback()
    end)
    
    return button
end

function Rayfield:CreateToggle(section, options)
    options = options or {}
    local toggle = {
        Name = options.Name or "Toggle",
        CurrentValue = options.Default or false,
        Callback = options.Callback or function() end
    }
    
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "ToggleFrame"
    ToggleFrame.Size = UDim2.new(1, -20, 0, 30)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Parent = section.Frame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "ToggleLabel"
    ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = toggle.Name
    ToggleLabel.TextColor3 = self.CurrentTheme.Text
    ToggleLabel.TextSize = 14
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0, 50, 0, 25)
    ToggleButton.Position = UDim2.new(1, -50, 0, 2)
    ToggleButton.BackgroundColor3 = self.CurrentTheme.Main
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 12)
    ToggleCorner.Parent = ToggleButton
    
    local ToggleDot = Instance.new("Frame")
    ToggleDot.Name = "ToggleDot"
    ToggleDot.Size = UDim2.new(0, 21, 0, 21)
    ToggleDot.Position = UDim2.new(0, 2, 0, 2)
    ToggleDot.BackgroundColor3 = self.CurrentTheme.TextSecondary
    ToggleDot.Parent = ToggleButton
    
    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(0, 10)
    DotCorner.Parent = ToggleDot
    
    -- Adjust section height
    section.Frame.Size = UDim2.new(1, -20, 0, section.Frame.Size.Y.Offset + 40)
    
    local function UpdateToggle()
        if toggle.CurrentValue then
            TweenService:Create(ToggleDot, TweenInfo.new(0.2), {Position = UDim2.new(0, 27, 0, 2)}):Play()
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = self.CurrentTheme.Accent}):Play()
        else
            TweenService:Create(ToggleDot, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 2)}):Play()
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = self.CurrentTheme.Main}):Play()
        end
        toggle.Callback(toggle.CurrentValue)
    end
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggle.CurrentValue = not toggle.CurrentValue
        UpdateToggle()
    end)
    
    UpdateToggle()
    
    return toggle
end

function Rayfield:CreateSlider(section, options)
    options = options or {}
    local slider = {
        Name = options.Name or "Slider",
        Min = options.Min or 0,
        Max = options.Max or 100,
        Default = options.Default or 50,
        Callback = options.Callback or function() end
    }
    
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = "SliderFrame"
    SliderFrame.Size = UDim2.new(1, -20, 0, 50)
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = section.Frame
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Name = "SliderLabel"
    SliderLabel.Size = UDim2.new(1, 0, 0, 20)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = slider.Name
    SliderLabel.TextColor3 = self.CurrentTheme.Text
    SliderLabel.TextSize = 14
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame
    
    local SliderValue = Instance.new("TextLabel")
    SliderValue.Name = "SliderValue"
    SliderValue.Size = UDim2.new(0, 50, 0, 20)
    SliderValue.Position = UDim2.new(1, -50, 0, 0)
    SliderValue.BackgroundTransparency = 1
    SliderValue.Text = tostring(slider.Default)
    SliderValue.TextColor3 = self.CurrentTheme.TextSecondary
    SliderValue.TextSize = 14
    SliderValue.Font = Enum.Font.Gotham
    SliderValue.TextXAlignment = Enum.TextXAlignment.Right
    SliderValue.Parent = SliderFrame
    
    local SliderTrack = Instance.new("Frame")
    SliderTrack.Name = "SliderTrack"
    SliderTrack.Size = UDim2.new(1, 0, 0, 5)
    SliderTrack.Position = UDim2.new(0, 0, 0, 30)
    SliderTrack.BackgroundColor3 = self.CurrentTheme.Main
    SliderTrack.Parent = SliderFrame
    
    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(0, 3)
    TrackCorner.Parent = SliderTrack
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "SliderFill"
    SliderFill.Size = UDim2.new((slider.Default - slider.Min) / (slider.Max - slider.Min), 0, 1, 0)
    SliderFill.BackgroundColor3 = self.CurrentTheme.Accent
    SliderFill.Parent = SliderTrack
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 3)
    FillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Name = "SliderButton"
    SliderButton.Size = UDim2.new(0, 15, 0, 15)
    SliderButton.Position = UDim2.new((slider.Default - slider.Min) / (slider.Max - slider.Min), -7, 0.5, -7)
    SliderButton.BackgroundColor3 = self.CurrentTheme.Text
    SliderButton.Text = ""
    SliderButton.ZIndex = 2
    SliderButton.Parent = SliderTrack
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 7)
    ButtonCorner.Parent = SliderButton
    
    -- Adjust section height
    section.Frame.Size = UDim2.new(1, -20, 0, section.Frame.Size.Y.Offset + 60)
    
    local function UpdateSlider(value)
        local percentage = (value - slider.Min) / (slider.Max - slider.Min)
        SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        SliderButton.Position = UDim2.new(percentage, -7, 0.5, -7)
        SliderValue.Text = tostring(math.floor(value))
        slider.Callback(value)
    end
    
    local dragging = false
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    SliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local percentage = (input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X
            local value = slider.Min + (percentage * (slider.Max - slider.Min))
            value = math.clamp(value, slider.Min, slider.Max)
            UpdateSlider(value)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local percentage = (input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X
            local value = slider.Min + (percentage * (slider.Max - slider.Min))
            value = math.clamp(value, slider.Min, slider.Max)
            UpdateSlider(value)
        end
    end)
    
    UpdateSlider(slider.Default)
    
    return slider
end

-- Initialize library
return Rayfield
