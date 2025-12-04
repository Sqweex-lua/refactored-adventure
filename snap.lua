local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Dark.cc",
   LoadingTitle = "Injecting. . .",
   LoadingSubtitle = "Made with love | @iceglock66",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "dark.cc"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "dark.cc | Custom | Homelles Life",
      Subtitle = "Key System",
      Note = "Script specialy for TheHunterKaKa",
      FileName = "denpidor677",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"DENISGAY123"}
   }
})

Rayfield:Notify({
   Title = "Succes",
   Content = "Loaded for 6.5 Seconds. ",
   Duration = 6.5,
   Image = 4483362458,
   Actions = {
      Ignore = {
         Name = "Okay!",
         Callback = function()
            print("⚡⚡⚡")
         end
      },
   },
})

-- Глобальные переменные
local originalSizes = {}
local selectedHitboxes = {"HumanoidRootPart"}
local selectedPlayer = nil
local autoKillEnabled = false
local antiBlockEnabled = false
local hitboxEnabled = false
local speedHackEnabled = false
local espEnabled = false
local boxes = {}
local autoCollectEnabled = false
local originalPosition = nil
local platformPart = nil
local killAuraEnabled = false
local killAuraPlayer = nil
local spamChatEnabled = false
local spamMessage = "Dark.cc on top!"
local deathSoundEnabled = true
local forcefieldArmsEnabled = false
local forcefieldArms = {}
local hitSoundsReplaced = false
local damageSoundEnabled = true
local attackSoundEnabled = true
local lastHealth = {}

local espTypes = {"Box", "Skeleton", "Name", "Distance"}
local selectedEspTypes = {"Box"}
local rainbowEnabled = false
local resolutionHackEnabled = false
local bloodSkyEnabled = false
local chinaHatEnabled = false
local fovValue = 70

local spinBotEnabled = false
local chinaHatPart = nil

-- Проверка на администратора
local localPlayerName = game.Players.LocalPlayer.Name
local isAdmin = localPlayerName == "viperr8880"

-- Функция для проверки защищенного игрока
local function isProtectedPlayer(playerName)
    return playerName == "viperr8880" or playerName == "gv177"
end

-- Функция для отключения всех функций
local function disableAllFunctions()
    autoKillEnabled = false
    antiBlockEnabled = false
    hitboxEnabled = false
    speedHackEnabled = false
    espEnabled = false
    autoCollectEnabled = false
    killAuraEnabled = false
    spamChatEnabled = false
    spinBotEnabled = false
    chinaHatEnabled = false
    resolutionHackEnabled = false
    bloodSkyEnabled = false
    deathSoundEnabled = false
    forcefieldArmsEnabled = false
    damageSoundEnabled = false
    attackSoundEnabled = false
    
    for playerModel, _ in pairs(originalSizes) do
        removeHitboxFromPlayer(playerModel)
    end
    originalSizes = {}
    
    for player, espParts in pairs(boxes) do
        for _, part in pairs(espParts) do
            part:Destroy()
        end
    end
    boxes = {}
    
    if platformPart then
        platformPart:Destroy()
        platformPart = nil
    end
    
    if chinaHatPart then
        chinaHatPart:Destroy()
        chinaHatPart = nil
    end
    
    for _, forcefield in pairs(forcefieldArms) do
        forcefield:Destroy()
    end
    forcefieldArms = {}
    
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 16
    end
    
    if originalPosition then
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = originalPosition
        end
    end
    
    local lighting = game:GetService("Lighting")
    lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
    lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
    lighting.FogColor = Color3.new(0.5, 0.5, 0.5)
    lighting.Brightness = 1
    
    for _, obj in pairs(lighting:GetChildren()) do
        if obj:IsA("Sky") then
            obj:Destroy()
        end
    end
    
    local camera = workspace.CurrentCamera
    camera.FieldOfView = 70
end

-- Функция для проверки gv177
local function checkForGV177()
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player.Name == "gv177" then
            Rayfield:Notify({
                Title = "WARNING",
                Content = "gv177 detected on server! Disabling all functions...",
                Duration = 5,
                Image = 4483362458,
            })
            
            disableAllFunctions()
            
            wait(2)
            
            Rayfield:Destroy()
            
            return true
        end
    end
    return false
end

-- Мониторинг игроков
local function monitorPlayers()
    game:GetService("Players").PlayerAdded:Connect(function(player)
        if player.Name == "gv177" then
            Rayfield:Notify({
                Title = "WARNING",
                Content = "gv177 joined the server! Disabling all functions...",
                Duration = 5,
                Image = 4483362458,
            })
            
            disableAllFunctions()
            
            wait(2)
            
            Rayfield:Destroy()
        end
    end)
end

checkForGV177()
monitorPlayers()

-- Звуковые функции
local function playDeathSound()
    if deathSoundEnabled then
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://17726923018"
        sound.Volume = 1
        sound.Parent = workspace
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 5)
    end
end

local function playDamageSound(position)
    if damageSoundEnabled then
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://8766809464"
        sound.Volume = 0.7
        sound.Parent = workspace
        if position then
            sound.Position = position
        end
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 5)
    end
end

local function playAttackSound(position)
    if attackSoundEnabled then
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://119289373229825"
        sound.Volume = 0.5
        sound.Parent = workspace
        if position then
            sound.Position = position
        end
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 5)
    end
end

-- Forcefield Arms
local function createForcefieldArms()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end
    
    for _, forcefield in pairs(forcefieldArms) do
        forcefield:Destroy()
    end
    forcefieldArms = {}
    
    local armParts = {
        "RightUpperArm",
        "RightLowerArm", 
        "LeftUpperArm",
        "LeftLowerArm"
    }
    
    for _, armName in pairs(armParts) do
        local arm = character:FindFirstChild(armName)
        if arm then
            local forcefield = Instance.new("ForceField")
            forcefield.Visible = true
            forcefield.Parent = arm
            
            local selectionBox = Instance.new("SelectionBox")
            selectionBox.Adornee = arm
            selectionBox.LineThickness = 0.05
            selectionBox.Color3 = Color3.fromRGB(170, 0, 255)
            selectionBox.Parent = arm
            selectionBox.Name = "PurpleForcefield"
            
            table.insert(forcefieldArms, forcefield)
            table.insert(forcefieldArms, selectionBox)
        end
    end
end

local function removeForcefieldArms()
    for _, forcefield in pairs(forcefieldArms) do
        forcefield:Destroy()
    end
    forcefieldArms = {}
end

-- Замена звуков
local function replaceHitSounds()
    if hitSoundsReplaced then return end
    
    local function replaceSoundsInFolder(folder)
        for _, sound in pairs(folder:GetDescendants()) do
            if sound:IsA("Sound") and string.lower(sound.Name):find("hit") then
                sound.SoundId = "rbxassetid://119289373229825"
            end
        end
    end
    
    local soundsFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Sounds")
    if soundsFolder then
        replaceSoundsInFolder(soundsFolder)
        hitSoundsReplaced = true
        Rayfield:Notify({
            Title = "Success",
            Content = "Hit sounds replaced!",
            Duration = 3,
            Image = 4483362458,
        })
    end
end

-- Мониторинг убийств
local function monitorKills()
    game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(character)
        character:WaitForChild("Humanoid").Died:Connect(function()
            playDeathSound()
        end)
    end)
    
    local currentCharacter = game:GetService("Players").LocalPlayer.Character
    if currentCharacter then
        currentCharacter:WaitForChild("Humanoid").Died:Connect(function()
            playDeathSound()
        end)
    end
end

-- Мониторинг урона
local function monitorDamage()
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        lastHealth[player] = player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health or 100
        
        player.CharacterAdded:Connect(function(character)
            local humanoid = character:WaitForChild("Humanoid")
            lastHealth[player] = humanoid.Health
            
            humanoid.HealthChanged:Connect(function()
                if lastHealth[player] and humanoid.Health < lastHealth[player] then
                    local damageTaken = lastHealth[player] - humanoid.Health
                    for i = 1, math.min(math.floor(damageTaken / 10), 5) do
                        playDamageSound(character:FindFirstChild("HumanoidRootPart") and character.HumanoidRootPart.Position)
                    end
                end
                lastHealth[player] = humanoid.Health
            end)
        end)
        
        if player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                lastHealth[player] = humanoid.Health
                humanoid.HealthChanged:Connect(function()
                    if lastHealth[player] and humanoid.Health < lastHealth[player] then
                        local damageTaken = lastHealth[player] - humanoid.Health
                        for i = 1, math.min(math.floor(damageTaken / 10), 5) do
                            playDamageSound(player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position)
                        end
                    end
                    lastHealth[player] = humanoid.Health
                end)
            end
        end
    end
    
    game:GetService("Players").PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            local humanoid = character:WaitForChild("Humanoid")
            lastHealth[player] = humanoid.Health
            
            humanoid.HealthChanged:Connect(function()
                if lastHealth[player] and humanoid.Health < lastHealth[player] then
                    local damageTaken = lastHealth[player] - humanoid.Health
                    for i = 1, math.min(math.floor(damageTaken / 10), 5) do
                        playDamageSound(character:FindFirstChild("HumanoidRootPart") and character.HumanoidRootPart.Position)
                    end
                end
                lastHealth[player] = humanoid.Health
            end)
        end)
    end)
end

-- Мониторинг атак
local function monitorAttacks()
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
            if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                playAttackSound(localPlayer.Character.HumanoidRootPart.Position)
            end
        end
        
        if input.UserInputType == Enum.UserInputType.Touch then
            if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                playAttackSound(localPlayer.Character.HumanoidRootPart.Position)
            end
        end
    end)
end

-- Хитбокс функции
local function applyHitboxToPlayer(playerModel)
    if not hitboxEnabled then return end
    if playerModel == game.Players.LocalPlayer.Character then return end
    
    for _, hitboxType in pairs(selectedHitboxes) do
        if playerModel:FindFirstChild(hitboxType) then
            local part = playerModel[hitboxType]
            originalSizes[playerModel] = originalSizes[playerModel] or {}
            originalSizes[playerModel][hitboxType] = part.Size
            
            if hitboxType == "HumanoidRootPart" then
                part.Size = Vector3.new(part.Size.X + 25, part.Size.Y, part.Size.Z + 25)
            elseif hitboxType == "Head" then
                part.Size = Vector3.new(part.Size.X, part.Size.Y + 30, part.Size.Z)
            end
            
            part.CanCollide = false
        end
    end
end

local function removeHitboxFromPlayer(playerModel)
    if originalSizes[playerModel] then
        for hitboxType, originalSize in pairs(originalSizes[playerModel]) do
            if playerModel:FindFirstChild(hitboxType) then
                local part = playerModel[hitboxType]
                part.Size = originalSize
                part.CanCollide = true
            end
        end
        originalSizes[playerModel] = nil
    end
end

local function refreshHitboxes()
    for playerModel, _ in pairs(originalSizes) do
        removeHitboxFromPlayer(playerModel)
    end
    originalSizes = {}
    
    if hitboxEnabled then
        for _, player in pairs(game:GetService("Workspace").Living:GetChildren()) do
            applyHitboxToPlayer(player)
        end
    end
end

local function monitorLivingFolder()
    for _, playerModel in pairs(game:GetService("Workspace").Living:GetChildren()) do
        applyHitboxToPlayer(playerModel)
    end
    
    game:GetService("Workspace").Living.ChildAdded:Connect(function(playerModel)
        applyHitboxToPlayer(playerModel)
    end)
end

-- Speed Hack
local function maintainSpeed()
    while true do
        if speedHackEnabled then
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = 35
            end
        end
        wait(0.1)
    end
end

-- Anti Block
local function startAntiBlock()
    while antiBlockEnabled do
        local localPlayer = game.Players.LocalPlayer
        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = localPlayer.Character.HumanoidRootPart
            
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local targetRoot = player.Character.HumanoidRootPart
                    local distance = (rootPart.Position - targetRoot.Position).Magnitude
                    
                    if distance <= 2 then
                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 2)
                        wait(0.1)
                        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 2)
                    end
                end
            end
        end
        wait(0.1)
    end
end

-- SpinBot
local function startSpinBot()
    while spinBotEnabled do
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(180), 0)
        end
        wait()
    end
end

-- Kill Aura
local function startKillAura()
    while killAuraEnabled do
        local target = game:GetService("Players")[killAuraPlayer]
        local localPlayer = game.Players.LocalPlayer
        
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and 
           target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health > 0 and
           localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            
            local targetRoot = target.Character.HumanoidRootPart
            local myRoot = localPlayer.Character.HumanoidRootPart
            
            local angle = tick() * 10
            local radius = 5
            local offset = Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
            local circlePosition = targetRoot.Position + offset
            
            myRoot.CFrame = CFrame.new(circlePosition, targetRoot.Position)
            
            for i = 1, 5 do
                if not killAuraEnabled then break end
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end
            
            if target.Character:FindFirstChild("HumanoidRootPart") then
                local humanoidRootPart = target.Character.HumanoidRootPart
                if not originalSizes[target.Character] then
                    originalSizes[target.Character] = {}
                    originalSizes[target.Character]["HumanoidRootPart"] = humanoidRootPart.Size
                end
                humanoidRootPart.Size = Vector3.new(humanoidRootPart.Size.X + 25, humanoidRootPart.Size.Y, humanoidRootPart.Size.Z + 25)
                humanoidRootPart.CanCollide = false
            end
        else
            if target and target.Character and originalSizes[target.Character] then
                local humanoidRootPart = target.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    humanoidRootPart.Size = originalSizes[target.Character]["HumanoidRootPart"]
                    humanoidRootPart.CanCollide = true
                end
                originalSizes[target.Character] = nil
            end
            killAuraEnabled = false
            Rayfield:Notify({
                Title = "Kill Aura",
                Content = "Target player died or left!",
                Duration = 3,
                Image = 4483362458,
            })
            break
        end
        wait()
    end
end

-- Spam Chat
local function startSpamChat()
    while spamChatEnabled do
        pcall(function()
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(spamMessage, "All")
        end)
        wait(1)
    end
end

-- Platform функции
local function createPlatform()
    if platformPart then
        platformPart:Destroy()
    end
    
    platformPart = Instance.new("Part")
    platformPart.Name = "AutoKillPlatform"
    platformPart.Size = Vector3.new(10, 2, 10)
    platformPart.Anchored = true
    platformPart.CanCollide = true
    platformPart.Transparency = 0.3
    platformPart.Color = Color3.new(0, 1, 0)
    platformPart.Material = Enum.Material.Neon
    platformPart.Parent = workspace
end

local function removePlatform()
    if platformPart then
        platformPart:Destroy()
        platformPart = nil
    end
end

-- China Hat
local function createChinaHat()
    if chinaHatPart then
        chinaHatPart:Destroy()
    end
    
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local head = character:WaitForChild("Head")

    chinaHatPart = Instance.new("Part")
    chinaHatPart.Name = "ClientPython"
    chinaHatPart.Anchored = false
    chinaHatPart.CanCollide = false
    chinaHatPart.Size = Vector3.new(4, 0.3, 4)
    chinaHatPart.Shape = Enum.PartType.Block
    chinaHatPart.Transparency = 0.4
    chinaHatPart.Material = Enum.Material.Neon
    chinaHatPart.Parent = head

    local mesh = Instance.new("SpecialMesh", chinaHatPart)
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://1033714"
    mesh.Scale = Vector3.new(2, 1, 2)

    chinaHatPart.CFrame = head.CFrame * CFrame.new(0, 1, 0)
    local weld = Instance.new("WeldConstraint", chinaHatPart)
    weld.Part0 = chinaHatPart
    weld.Part1 = head

    spawn(function()
        local hue = 0
        while chinaHatEnabled do
            hue = (hue + 1) % 360
            chinaHatPart.Color = Color3.fromHSV(hue / 360, 1, 1)
            wait(0.1)
        end
    end)
end

local function removeChinaHat()
    if chinaHatPart then
        chinaHatPart:Destroy()
        chinaHatPart = nil
    end
end

-- Resolution Hack
local function startResolutionHack()
    getgenv().Resolution = {
        [".gg"] = 0.85
    }

    local Camera = workspace.CurrentCamera
    if getgenv().gg_scripters == nil then
        game:GetService("RunService").RenderStepped:Connect(
            function()
                Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, getgenv().Resolution[".gg"], 0, 0, 0, 1)
            end
        )
    end
    getgenv().gg_scripters = "iceglock66"
end

-- Blood Sky
local function setBloodSky()
    if bloodSkyEnabled then
        local lighting = game:GetService("Lighting")
        lighting.Ambient = Color3.new(0.8, 0, 0)
        lighting.OutdoorAmbient = Color3.new(0.6, 0, 0)
        lighting.FogColor = Color3.new(0.5, 0, 0)
        lighting.Brightness = 0.9
        
        local sky = Instance.new("Sky")
        sky.SkyboxBk = "rbxassetid://106624846953980"
        sky.SkyboxDn = "rbxassetid://106624846953980"
        sky.SkyboxFt = "rbxassetid://106624846953980"
        sky.SkyboxLf = "rbxassetid://106624846953980"
        sky.SkyboxRt = "rbxassetid://106624846953980"
        sky.SkyboxUp = "rbxassetid://106624846953980"
        sky.Parent = lighting
    else
        local lighting = game:GetService("Lighting")
        lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
        lighting.FogColor = Color3.new(0.5, 0.5, 0.5)
        lighting.Brightness = 1
        
        for _, obj in pairs(lighting:GetChildren()) do
            if obj:IsA("Sky") then
                obj:Destroy()
            end
        end
    end
end

-- FOV Hack
local function updateFOV()
    local camera = workspace.CurrentCamera
    camera.FieldOfView = fovValue
end

-- ESP
local function updateESP()
    if espEnabled then
        for _, player in pairs(game:GetService("Workspace").Living:GetChildren()) do
            if player:FindFirstChild("HumanoidRootPart") and player ~= game.Players.LocalPlayer.Character then
                if boxes[player] then
                    for _, part in pairs(boxes[player]) do
                        part:Destroy()
                    end
                end
                boxes[player] = {}
                
                local color = Color3.new(1, 0, 0)
                if rainbowEnabled then
                    local hue = tick() % 5 / 5
                    color = Color3.fromHSV(hue, 1, 1)
                end
                
                if table.find(selectedEspTypes, "Box") then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = "ESPBox"
                    box.Adornee = player.HumanoidRootPart
                    box.AlwaysOnTop = true
                    box.Size = Vector3.new(3, 6, 3)
                    box.Transparency = 0.3
                    box.Color3 = color
                    box.ZIndex = 0
                    box.Parent = player.HumanoidRootPart
                    table.insert(boxes[player], box)
                end
                
                if table.find(selectedEspTypes, "Name") then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "ESPName"
                    billboard.Adornee = player.HumanoidRootPart
                    billboard.Size = UDim2.new(0, 100, 0, 30)
                    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
                    billboard.AlwaysOnTop = true
                    
                    local textLabel = Instance.new("TextLabel")
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.Text = player.Name
                    textLabel.TextColor3 = color
                    textLabel.TextScaled = true
                    textLabel.Font = Enum.Font.GothamBold
                    textLabel.TextStrokeTransparency = 0
                    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                    textLabel.Parent = billboard
                    
                    billboard.Parent = player.HumanoidRootPart
                    table.insert(boxes[player], billboard)
                end
                
                if table.find(selectedEspTypes, "Distance") then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "ESPDistance"
                    billboard.Adornee = player.HumanoidRootPart
                    billboard.Size = UDim2.new(0, 100, 0, 30)
                    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                    billboard.AlwaysOnTop = true
                    
                    local textLabel = Instance.new("TextLabel")
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.Text = "Distance: " .. math.floor((player.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                    textLabel.TextColor3 = color
                    textLabel.TextScaled = true
                    textLabel.Font = Enum.Font.GothamBold
                    textLabel.TextStrokeTransparency = 0
                    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                    textLabel.Parent = billboard
                    
                    billboard.Parent = player.HumanoidRootPart
                    table.insert(boxes[player], billboard)
                end
                
                if table.find(selectedEspTypes, "Skeleton") then
                    local parts = {"Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg"}
                    for _, partName in pairs(parts) do
                        if player:FindFirstChild(partName) then
                            local part = player[partName]
                            local box = Instance.new("BoxHandleAdornment")
                            box.Name = "ESPSkeleton"
                            box.Adornee = part
                            box.AlwaysOnTop = true
                            box.Size = part.Size
                            box.Transparency = 0.5
                            box.Color3 = color
                            box.ZIndex = 0
                            box.Parent = part
                            table.insert(boxes[player], box)
                        end
                    end
                end
            end
        end
    else
        for player, espParts in pairs(boxes) do
            for _, part in pairs(espParts) do
                part:Destroy()
            end
        end
        boxes = {}
    end
end

-- Обновление списка игроков
local function updatePlayersList()
    local players = {}
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game.Players.LocalPlayer and not isProtectedPlayer(player.Name) then
            table.insert(players, player.Name)
        end
    end
    return players
end

-- Auto Collect Money
local function startAutoCollect()
    while autoCollectEnabled do
        task.wait(0.1)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local character = player.Character
            local rootPart = character.HumanoidRootPart
            
            for _, cash in pairs(game:GetService("Workspace").CashDrops:GetChildren()) do
                if cash:IsA("UnionOperation") then
                    local distance = (rootPart.Position - cash.Position).Magnitude
                    if distance < 50 then
                        rootPart.CFrame = cash.CFrame
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        task.wait(0.1)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
                        task.wait(0.2)
                    end
                end
            end
        end
    end
end

-- Запуск основных функций
spawn(maintainSpeed)
monitorKills()
monitorDamage()
monitorAttacks()
replaceHitSounds()

-- Создание вкладок
local HitboxTab = Window:CreateTab("Hitbox", 4483362458)
local CombatTab = Window:CreateTab("Combat", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- Вкладка Hitbox
local Dropdown = HitboxTab:CreateDropdown({
   Name = "Hitbox Type",
   Options = {"HumanoidRootPart", "Head"},
   CurrentOption = {"HumanoidRootPart"},
   MultipleOptions = true,
   Flag = "Dropdown1",
   Callback = function(Option)
      selectedHitboxes = Option
   end,
})

local Toggle = HitboxTab:CreateToggle({
   Name = "Select Hitbox",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
      hitboxEnabled = Value
      if hitboxEnabled then
         monitorLivingFolder()
      else
         for playerModel, _ in pairs(originalSizes) do
            removeHitboxFromPlayer(playerModel)
         end
         originalSizes = {}
      end
   end,
})

local RefreshHitboxesBtn = HitboxTab:CreateButton({
   Name = "Refresh Hitboxes",
   Callback = function()
      refreshHitboxes()
      Rayfield:Notify({
         Title = "Success",
         Content = "Hitboxes refreshed!",
         Duration = 2,
         Image = 4483362458,
      })
   end,
})

-- Вкладка Combat
local PlayerDropdown = CombatTab:CreateDropdown({
   Name = "Select Player",
   Options = updatePlayersList(),
   CurrentOption = {},
   MultipleOptions = false,
   Flag = "Dropdown2",
   Callback = function(Option)
      if #Option > 0 then
         selectedPlayer = Option[1]
      else
         selectedPlayer = nil
      end
   end,
})

local KillAuraDropdown = CombatTab:CreateDropdown({
   Name = "Kill Aura Target",
   Options = updatePlayersList(),
   CurrentOption = {},
   MultipleOptions = false,
   Flag = "KillAuraDropdown",
   Callback = function(Option)
      if #Option > 0 then
         killAuraPlayer = Option[1]
      else
         killAuraPlayer = nil
      end
   end,
})

local RefreshListBtn = CombatTab:CreateButton({
   Name = "Refresh List",
   Callback = function()
      local currentPlayers = updatePlayersList()
      PlayerDropdown:SetOptions(currentPlayers)
      KillAuraDropdown:SetOptions(currentPlayers)
      Rayfield:Notify({
         Title = "Success",
         Content = "Player list refreshed!",
         Duration = 2,
         Image = 4483362458,
      })
   end,
})

local KillAuraToggle = CombatTab:CreateToggle({
   Name = "Kill Aura",
   CurrentValue = false,
   Flag = "KillAuraToggle",
   Callback = function(Value)
      if killAuraPlayer and isProtectedPlayer(killAuraPlayer) then
         Rayfield:Notify({
            Title = "Error",
            Content = "Cannot use Kill Aura on protected player!",
            Duration = 3,
            Image = 4483362458,
         })
         return
      end
      
      killAuraEnabled = Value
      if killAuraEnabled then
         if not killAuraPlayer then
            Rayfield:Notify({
               Title = "Error",
               Content = "Please select a player for Kill Aura first!",
               Duration = 3,
               Image = 4483362458,
            })
            killAuraEnabled = false
            return
         end
         
         spinBotEnabled = true
         spawn(startSpinBot)
         spawn(startKillAura)
         
         Rayfield:Notify({
            Title = "Kill Aura",
            Content = "Kill Aura activated! Fast SpinBot enabled.",
            Duration = 3,
            Image = 4483362458,
         })
      else
         spinBotEnabled = false
         Rayfield:Notify({
            Title = "Kill Aura",
            Content = "Kill Aura deactivated!",
            Duration = 2,
            Image = 4483362458,
         })
      end
   end,
})

local AutoKillToggle = CombatTab:CreateToggle({
   Name = "Auto Kill",
   CurrentValue = false,
   Flag = "Toggle5",
   Callback = function(Value)
      if selectedPlayer and isProtectedPlayer(selectedPlayer) then
         Rayfield:Notify({
            Title = "Error",
            Content = "Cannot use Auto Kill on protected player!",
            Duration = 3,
            Image = 4483362458,
         })
         return
      end
      
      autoKillEnabled = Value
      if autoKillEnabled then
         if not selectedPlayer then
            Rayfield:Notify({
               Title = "Error",
               Content = "Please select a player first!",
               Duration = 3,
               Image = 4483362458,
            })
            autoKillEnabled = false
            return
         end
         
         local headHitboxEnabled = false
         for _, hitbox in pairs(selectedHitboxes) do
            if hitbox == "Head" then
                headHitboxEnabled = true
                break
            end
         end
         
         if not headHitboxEnabled then
            Rayfield:Notify({
               Title = "Error",
               Content = "Head hitbox must be enabled for Auto Kill!",
               Duration = 3,
               Image = 4483362458,
            })
            autoKillEnabled = false
            return
         end
         
         local player = game.Players.LocalPlayer
         if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            originalPosition = player.Character.HumanoidRootPart.CFrame
         end
         
         createPlatform()
         
         spawn(function()
            local lastTargetPos = nil
            while autoKillEnabled and task.wait() do
               local target = game:GetService("Players")[selectedPlayer]
               
               if not target or not target.Character or not target.Character:FindFirstChild("Humanoid") or target.Character.Humanoid.Health <= 0 then
                  autoKillEnabled = false
                  Rayfield:Notify({
                     Title = "Auto Kill",
                     Content = "Target player died! Auto Kill disabled.",
                     Duration = 3,
                     Image = 4483362458,
                  })
                  break
               end
               
               if target.Character and target.Character:FindFirstChild("HumanoidRootPart") and target.Character:FindFirstChild("Head") then
                  local localPlayer = game.Players.LocalPlayer
                  if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                     local rootPart = localPlayer.Character.HumanoidRootPart
                     local targetHead = target.Character.Head
                     local targetPos = targetHead.Position
                     
                     if lastTargetPos and (targetPos - lastTargetPos).Magnitude > 1 then
                         local platformPosition = Vector3.new(targetPos.X, targetPos.Y + 6, targetPos.Z)
                         local myPosition = Vector3.new(targetPos.X, targetPos.Y + 7, targetPos.Z)
                         
                         if platformPart then
                             platformPart.Position = platformPosition
                         end
                         
                         rootPart.CFrame = CFrame.new(myPosition)
                     end
                     
                     lastTargetPos = targetPos
                     
                     pcall(function()
                         for i = 1, 4 do
                            if not autoKillEnabled then break end
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                            task.wait(0.01)
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
                            task.wait(0.05)
                         end
                         
                         if autoKillEnabled then
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 2)
                            task.wait(0.01)
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 2)
                            task.wait(0.05)
                         end
                     end)
                  end
               else
                  autoKillEnabled = false
                  break
               end
            end
            
            if originalPosition then
               local player = game.Players.LocalPlayer
               if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                  player.Character.HumanoidRootPart.CFrame = originalPosition
               end
            end
            
            removePlatform()
         end)
      else
         if originalPosition then
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
               player.Character.HumanoidRootPart.CFrame = originalPosition
            end
         end
         removePlatform()
      end
   end,
})

local AntiBlockToggle = CombatTab:CreateToggle({
   Name = "Anti Block",
   CurrentValue = false,
   Flag = "Toggle6",
   Callback = function(Value)
      antiBlockEnabled = Value
      if antiBlockEnabled then
         spawn(startAntiBlock)
      end
   end,
})

-- Вкладка Player
local SpeedToggle = PlayerTab:CreateToggle({
   Name = "Speed Hack",
   CurrentValue = false,
   Flag = "Toggle2",
   Callback = function(Value)
      speedHackEnabled = Value
      if speedHackEnabled then
         local player = game.Players.LocalPlayer
         if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 35
         end
         player.CharacterAdded:Connect(function(character)
            task.wait(1)
            if speedHackEnabled and character:FindFirstChild("Humanoid") then
               character.Humanoid.WalkSpeed = 35
            end
         end)
      else
         local player = game.Players.LocalPlayer
         if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
         end
      end
   end,
})

local GodmodeBtn = PlayerTab:CreateButton({
   Name = "Godmode",
   Callback = function()
      local player = game.Players.LocalPlayer
      if player.Character and player.Character:FindFirstChild("Humanoid") then
         player.Character.Humanoid.MaxHealth = 9999
         player.Character.Humanoid.Health = 9999
      end
   end,
})

local LeavePVPBtn = PlayerTab:CreateButton({
   Name = "Leave From PVP",
   Callback = function()
      local player = game.Players.LocalPlayer
      if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
         player.Character.HumanoidRootPart.CFrame = CFrame.new(-27.02, 44.37, 373.13)
      end
   end,
})

local SpinBotToggle = PlayerTab:CreateToggle({
   Name = "SpinBot",
   CurrentValue = false,
   Flag = "SpinBotToggle",
   Callback = function(Value)
      spinBotEnabled = Value
      if spinBotEnabled then
         spawn(startSpinBot)
      end
   end,
})

local ForcefieldArmsToggle = PlayerTab:CreateToggle({
   Name = "Purple Forcefield Arms",
   CurrentValue = false,
   Flag = "ForcefieldArmsToggle",
   Callback = function(Value)
      forcefieldArmsEnabled = Value
      if forcefieldArmsEnabled then
         createForcefieldArms()
         game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
            wait(1)
            if forcefieldArmsEnabled then
               createForcefieldArms()
            end
         end)
         Rayfield:Notify({
            Title = "Forcefield Arms",
            Content = "Purple forcefield arms activated!",
            Duration = 2,
            Image = 4483362458,
         })
      else
         removeForcefieldArms()
         Rayfield:Notify({
            Title = "Forcefield Arms",
            Content = "Forcefield arms deactivated!",
            Duration = 2,
            Image = 4483362458,
         })
      end
   end,
})

-- Вкладка Visuals
local EspDropdown = VisualsTab:CreateDropdown({
   Name = "ESP Types",
   Options = espTypes,
   CurrentOption = selectedEspTypes,
   MultipleOptions = true,
   Flag = "EspDropdown",
   Callback = function(Option)
      selectedEspTypes = Option
      updateESP()
   end,
})

local EspToggle = VisualsTab:CreateToggle({
   Name = "ESP",
   CurrentValue = false,
   Flag = "EspToggle",
   Callback = function(Value)
      espEnabled = Value
      updateESP()
   end,
})

local RainbowToggle = VisualsTab:CreateToggle({
   Name = "RGB ESP",
   CurrentValue = false,
   Flag = "RainbowToggle",
   Callback = function(Value)
      rainbowEnabled = Value
      updateESP()
   end,
})

local ResolutionToggle = VisualsTab:CreateToggle({
   Name = "Resolution Hack",
   CurrentValue = false,
   Flag = "ResolutionToggle",
   Callback = function(Value)
      resolutionHackEnabled = Value
      if resolutionHackEnabled then
         startResolutionHack()
      end
   end,
})

local BloodSkyBtn = VisualsTab:CreateButton({
   Name = "SkyBox Blood",
   Callback = function()
      bloodSkyEnabled = not bloodSkyEnabled
      setBloodSky()
      Rayfield:Notify({
         Title = "SkyBox",
         Content = bloodSkyEnabled and "Blood sky enabled!" or "Blood sky disabled!",
         Duration = 2,
         Image = 4483362458,
      })
   end,
})

local ChinaHatToggle = VisualsTab:CreateToggle({
   Name = "China Hat",
   CurrentValue = false,
   Flag = "ChinaHatToggle",
   Callback = function(Value)
      chinaHatEnabled = Value
      if chinaHatEnabled then
         createChinaHat()
      else
         removeChinaHat()
      end
   end,
})

local FovSlider = VisualsTab:CreateSlider({
   Name = "FOV Hack",
   Range = {50, 120},
   Increment = 1,
   Suffix = "FOV",
   CurrentValue = 70,
   Flag = "FovSlider",
   Callback = function(Value)
      fovValue = Value
      updateFOV()
   end,
})

-- Вкладка Misc
local DeathSoundToggle = MiscTab:CreateToggle({
   Name = "Death Sound",
   CurrentValue = true,
   Flag = "DeathSoundToggle",
   Callback = function(Value)
      deathSoundEnabled = Value
   end,
})

local DamageSoundToggle = MiscTab:CreateToggle({
   Name = "Damage Sound",
   CurrentValue = true,
   Flag = "DamageSoundToggle",
   Callback = function(Value)
      damageSoundEnabled = Value
   end,
})

local AttackSoundToggle = MiscTab:CreateToggle({
   Name = "Attack Sound",
   CurrentValue = true,
   Flag = "AttackSoundToggle",
   Callback = function(Value)
      attackSoundEnabled = Value
   end,
})

local ReplaceHitSoundsBtn = MiscTab:CreateButton({
   Name = "Replace Hit Sounds",
   Callback = function()
      replaceHitSounds()
   end,
})

local SpamChatToggle = MiscTab:CreateToggle({
   Name = "Spam Chat",
   CurrentValue = false,
   Flag = "SpamChatToggle",
   Callback = function(Value)
      spamChatEnabled = Value
      if spamChatEnabled then
         spawn(startSpamChat)
         Rayfield:Notify({
            Title = "Spam Chat",
            Content = "Spam chat activated!",
            Duration = 2,
            Image = 4483362458,
         })
      else
         Rayfield:Notify({
            Title = "Spam Chat",
            Content = "Spam chat deactivated!",
            Duration = 2,
            Image = 4483362458,
         })
      end
   end,
})

local SpamMessageInput = MiscTab:CreateInput({
   Name = "Spam Message",
   PlaceholderText = "Dark.cc on top!",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      spamMessage = Text
   end,
})

local DisableRagdollBtn = MiscTab:CreateButton({
   Name = "Disable Ragdoll",
   Callback = function()
      if game:GetService("ReplicatedStorage"):FindFirstChild("Ragdoll") then
         game:GetService("ReplicatedStorage").Ragdoll:Destroy()
      end
   end,
})

local DeleteAnticheatBtn = MiscTab:CreateButton({
   Name = "Delete Anticheat",
   Callback = function()
      local path = game:GetService("CorePackages")
      if path:FindFirstChild("Workspace") then
         local workspaceFolder = path.Workspace
         if workspaceFolder:FindFirstChild("Packages") then
            local packages = workspaceFolder.Packages
            if packages:FindFirstChild("_Index") then
               local index = packages._Index
               if index:FindFirstChild("AppTopBanner") then
                  local appTopBanner = index.AppTopBanner
                  if appTopBanner:FindFirstChild("AppTopBanner") then
                     appTopBanner.AppTopBanner:Destroy()
                  end
               end
            end
         end
      end
   end,
})

local AutoCollectToggle = MiscTab:CreateToggle({
   Name = "Auto Collect Money",
   CurrentValue = false,
   Flag = "Toggle4",
   Callback = function(Value)
      autoCollectEnabled = Value
      if autoCollectEnabled then
         spawn(startAutoCollect)
      end
   end,
})

-- Вкладка Admin (только для viperr8880)
local AdminTab
if isAdmin then
    AdminTab = Window:CreateTab("Admin", 4483362458)

    -- Кнопка для выполнения Dex++
    local DexButton = AdminTab:CreateButton({
        Name = "Execute Dex++",
        Callback = function()
            loadstring(game:HttpGet("https://github.com/AZYsGithub/DexPlusPlus/releases/latest/download/out.lua"))()
            Rayfield:Notify({
                Title = "Admin",
                Content = "Dex++ executed successfully!",
                Duration = 3,
                Image = 4483362458,
            })
        end,
    })

    -- Удаление объектов по пути
    local DeleteInput = AdminTab:CreateInput({
        Name = "Delete Object by Path",
        PlaceholderText = "Workspace.PartName",
        RemoveTextAfterFocusLost = false,
        Callback = function(Text)
            if Text and Text ~= "" then
                local success, result = pcall(function()
                    local object = game:GetService("ServiceProvider"):FindFirstChild(Text, true)
                    if object then
                        object:Destroy()
                        Rayfield:Notify({
                            Title = "Admin",
                            Content = "Object deleted successfully!",
                            Duration = 3,
                            Image = 4483362458,
                        })
                    else
                        Rayfield:Notify({
                            Title = "Error",
                            Content = "Object not found!",
                            Duration = 3,
                            Image = 4483362458,
                        })
                    end
                end)
                
                if not success then
                    Rayfield:Notify({
                        Title = "Error",
                        Content = "Invalid path or object not found!",
                        Duration = 3,
                        Image = 4483362458,
                    })
                end
            end
        end,
    })

    -- Проверка администраторов
    local CheckAdminsBtn = AdminTab:CreateButton({
        Name = "Check for Admins",
        Callback = function()
            local foundAdmins = {}
            
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player.Name == "gv177" then
                    table.insert(foundAdmins, player.Name)
                end
            end
            
            if #foundAdmins > 0 then
                Rayfield:Notify({
                    Title = "Admin Check",
                    Content = "Found admins: " .. table.concat(foundAdmins, ", "),
                    Duration = 5,
                    Image = 4483362458,
                })
            else
                Rayfield:Notify({
                    Title = "Admin Check",
                    Content = "No admins found on server!",
                    Duration = 3,
                    Image = 4483362458,
                })
            end
        end,
    })

    -- Отключение скрипта у других игроков
    local DisableScriptBtn = AdminTab:CreateButton({
        Name = "Disable Script for Players",
        Callback = function()
            local playersUsingScript = {}
            
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    -- Проверяем наличие нашего скрипта у других игроков
                    local character = player.Character
                    if character then
                        -- Проверяем наличие характерных частей нашего скрипта
                        if character:FindFirstChild("ClientPython") or 
                           workspace:FindFirstChild("AutoKillPlatform") then
                            table.insert(playersUsingScript, player.Name)
                            
                            -- Отключаем функции
                            if character:FindFirstChild("ClientPython") then
                                character.ClientPython:Destroy()
                            end
                        end
                    end
                end
            end
            
            if #playersUsingScript > 0 then
                Rayfield:Notify({
                    Title = "Script Disabler",
                    Content = "Disabled script for: " .. table.concat(playersUsingScript, ", "),
                    Duration = 5,
                    Image = 4483362458,
                })
            else
                Rayfield:Notify({
                    Title = "Script Disabler",
                    Content = "No other players using the script found!",
                    Duration = 3,
                    Image = 4483362458,
                })
            end
        end,
    })

    -- Расширенное удаление объектов
    local MassDeleteBtn = AdminTab:CreateButton({
        Name = "Mass Delete Common Objects",
        Callback = function()
            local objectsToDelete = {
                "AntiCheat",
                "AC",
                "Anticheat",
                "ScriptDetector",
                "Security",
                "Ban",
                "Kick",
                "Admin",
                "Moderator"
            }
            
            local deletedCount = 0
            
            for _, objName in pairs(objectsToDelete) do
                pcall(function()
                    local objects = game:GetDescendants()
                    for _, obj in pairs(objects) do
                        if obj.Name:lower():find(objName:lower()) then
                            obj:Destroy()
                            deletedCount = deletedCount + 1
                        end
                    end
                end)
            end
            
            Rayfield:Notify({
                Title = "Mass Delete",
                Content = "Deleted " .. deletedCount .. " objects!",
                Duration = 3,
                Image = 4483362458,
            })
        end,
    })

    -- Очистка workspace
    local CleanWorkspaceBtn = AdminTab:CreateButton({
        Name = "Clean Workspace",
        Callback = function()
            local cleanedCount = 0
            
            pcall(function()
                for _, obj in pairs(workspace:GetChildren()) do
                    if obj:IsA("Part") and obj.Name ~= "Baseplate" then
                        obj:Destroy()
                        cleanedCount = cleanedCount + 1
                    end
                end
            end)
            
            Rayfield:Notify({
                Title = "Workspace Cleaner",
                Content = "Cleaned " .. cleanedCount .. " objects from workspace!",
                Duration = 3,
                Image = 4483362458,
            })
        end,
    })

    Rayfield:Notify({
        Title = "Admin Access",
        Content = "Admin tab loaded successfully! Welcome viperr8880",
        Duration = 3,
        Image = 4483362458,
    })
else
    -- Уведомление для не-админов
    game:GetService("Players").LocalPlayer.Chatted:Connect(function(message)
        if message:lower():find("admin") or message:lower():find("viperr8880") then
            Rayfield:Notify({
                Title = "Access Denied",
                Content = "Admin features are only available for viperr8880",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end)
end
