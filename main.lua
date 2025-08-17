local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESPActive = false
local ESPObjects = {} -- Guarda os highlights para cada player


-- Loop para criar highlights nos inimigos
RunService.RenderStepped:Connect(function()
    if ESPActive then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if not ESPObjects[player] then
                    -- Cria o highlight
                    local highlight = Instance.new("Highlight")
                    highlight.Adornee = player.Character
                    highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Cor da box
                    highlight.OutlineColor = Color3.fromRGB(0,0,0)
                    highlight.FillTransparency = 0.5
                    highlight.Parent = game:GetService("CoreGui")
                    
                    ESPObjects[player] = highlight
                end
            end
        end
    end
end)

-- Remove highlights de players que saem do jogo
Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        ESPObjects[player]:Destroy()
        ESPObjects[player] = nil
    end
end)


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local AimBotActive = false
local FOV = 150 -- Campo de visão do aimbot em pixels
local Smoothness = 0.2 -- Quanto mais baixo, mais rápido mira no alvo

-- Função para achar o player mais próximo do centro da tela
local function getClosestTarget()
    local closestDistance = FOV
    local closestPlayer = nil

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            if humanoid.Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end

    return closestPlayer
end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local AimBotActive = false
local FOV = 150 -- Campo de visão do aimbot em pixels
local Smoothness = 0.2 -- Quanto mais baixo, mais rápido mira no alvo

-- Função para achar o player mais próximo do centro da tela
local function getClosestTarget()
    local closestDistance = FOV
    local closestPlayer = nil

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            if humanoid.Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end

    return closestPlayer
end


-- Loop do aimbot com smooth aim
RunService.RenderStepped:Connect(function()
    if AimBotActive then
        local target = getClosestTarget()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = target.Character.HumanoidRootPart.Position
            local currentCFrame = Camera.CFrame
            local newCFrame = CFrame.new(currentCFrame.Position, targetPos)
            
            -- Smooth aim: interpola gradualmente
            Camera.CFrame = currentCFrame:Lerp(newCFrame, Smoothness)
        end
    end
end)



local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local flying = false
local speed = 50
local velocity = Vector3.zero

local function startFly()
    if flying then return end
    flying = true
    humanoid.PlatformStand = true -- desativa física padrão do humanoid

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not flying then
            connection:Disconnect()
            return
        end

        local moveDirection = Vector3.zero
        local cam = workspace.CurrentCamera
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection += cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection -= cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection -= cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection += cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection += Vector3.new(0,1,0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection -= Vector3.new(0,1,0)
        end

        if moveDirection.Magnitude > 0 then
            velocity = moveDirection.Unit * speed
        else
            velocity = Vector3.zero
        end

        humanoidRootPart.Velocity = velocity
    end)
end

local function stopFly()
    flying = false
    humanoid.PlatformStand = false -- reativa física normal
    humanoidRootPart.Velocity = Vector3.zero
end



local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "JHhub V1",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Carregando JHhub...",
   LoadingSubtitle = "by Jscripts",
   ShowText = "JHhub", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Amethyst", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "JHhubV1" -- The file name for your hub/game"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "2FY6kR7c", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local MainTab = Window:CreateTab("MainTab", 4483362458) -- Title, Image

Rayfield:Notify({
   Title = "JHhub Carregado",
   Content = "Criado por Jscripts",
   Duration = 6.5,
   Image = 4483362458,
})

local HelloWorldButton = MainTab:CreateButton({
   Name = "Hello World",
   Callback = function()
    print("Hello World!")
   end,
})

-- Conectando no Toggle:
local Toggle = MainTab:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Flag = "Fly",
   Callback = function(Value)
      if Value then
         startFly()
      else
         stopFly()
      end
   end,
})

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local WalkSpeedSlider = MainTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {0, 100},
   Increment = 10,
   Suffix = "WalkSpeed",
   CurrentValue = 10,
   Flag = "WalkSpeed",
   Callback = function(Value)
       -- Muda a velocidade do personagem imediatamente
       humanoid.WalkSpeed = Value
   end,
})
local JumpPowerSlider = MainTab:CreateSlider({
   Name = "JumpPower",
   Range = {0, 200},
   Increment = 10,
   Suffix = "JumpPower",
   CurrentValue = 50,
   Flag = "JumpPower",
   Callback = function(Value)
       -- Muda a potência do pulo do personagem imediatamente
       humanoid.JumpPower = Value
   end,
})

local AimBot = MainTab:CreateToggle({
   Name = "AimBot",
   CurrentValue = false,
   Flag = "AimBot",
   Callback = function(Value)
       AimBotActive = Value
   end,
})


-- Toggle ESP
local Esp = MainTab:CreateToggle({
   Name = "Esp",
   CurrentValue = false,
   Flag = "Esp",
   Callback = function(Value)
       ESPActive = Value
       
       if not ESPActive then
           -- Remove todos os highlights quando desligar
           for player, highlight in pairs(ESPObjects) do
               if highlight and highlight.Parent then
                   highlight:Destroy()
               end
           end
           ESPObjects = {}
       end
   end,
})
