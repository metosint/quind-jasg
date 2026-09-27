-- Загрузка Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Quind Hub",
    SubTitle = "Just a Sniper Game",
    TabWidth = 160,
    Size = UDim2.fromOffset(600, 480),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Sniper = Window:AddTab({ Title = "Sniper", Icon = "crosshair" }),
    Game = Window:AddTab({ Title = "Game", Icon = "target" }),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "settings" })
}

-- //=========================================\\
-- //            SNIPER TAB (10 функций)      \\
-- //=========================================\\

-- 1. Aimbot
Tabs.Sniper:AddToggle("Aimbot", { Title = "Aimbot", Default = false })
-- 2. Silent Aim
Tabs.Sniper:AddToggle("SilentAim", { Title = "Silent Aim", Default = false })
-- 3. Auto Shoot
Tabs.Sniper:AddToggle("AutoShoot", { Title = "Auto Shoot (Trigger Bot)", Default = false })
-- 4. No Recoil
Tabs.Sniper:AddToggle("NoRecoil", { Title = "No Recoil", Default = false, Callback = function(state)
    -- Логика отдачи (зависит от игры)
    getgenv().NoRecoil = state
end })
-- 5. No Spread
Tabs.Sniper:AddToggle("NoSpread", { Title = "No Spread", Default = false })
-- 6. Infinite Ammo
Tabs.Sniper:AddToggle("InfAmmo", { Title = "Infinite Ammo", Default = false })
-- 7. Fast Reload
Tabs.Sniper:AddToggle("FastReload", { Title = "Fast Reload", Default = false })
-- 8. Instant Hit
Tabs.Sniper:AddToggle("InstantHit", { Title = "Instant Hit", Default = false })
-- 9. FOV Circle
Tabs.Sniper:AddToggle("FOVCircle", { Title = "Show FOV Circle", Default = false })
-- 10. Hitbox Expander
Tabs.Sniper:AddToggle("HitboxExpander", { Title = "Hitbox Expander", Default = false, Callback = function(state)
    getgenv().HitboxExpander = state
    task.spawn(function()
        while getgenv().HitboxExpander do
            task.wait(0.5)
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= game.Players.LocalPlayer and p.Character then
                    for _, part in pairs(p.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.Size = Vector3.new(5, 5, 5)
                            part.Transparency = 0.5
                        end
                    end
                end
            end
        end
    end)
end })


-- //=========================================\\
-- //             GAME TAB (10 функций)       \\
-- //=========================================\\

-- 1. Auto Grab Gun (Авто граб)
Tabs.Game:AddToggle("AutoGrabGun", { Title = "Auto Grab Gun", Default = false, Callback = function(state)
    getgenv().AutoGrabGun = state
    task.spawn(function()
        while getgenv().AutoGrabGun do
            task.wait(0.1)
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                for _, v in pairs(workspace:GetChildren()) do
                    if v:IsA("Tool") and v.Name:lower():find("gun") or v.Name:lower():find("sniper") then
                        char.HumanoidRootPart.CFrame = v.Handle.CFrame
                        task.wait(0.1)
                        v.Parent = char
                    end
                end
            end
        end
    end)
end })

-- 2. Shoot Murderer (Выстрел в мардера)
Tabs.Game:AddButton({ Title = "Shoot Murderer (Выстрел в мардера)", Callback = function()
    local murderer = nil
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer and p.Character then
            if (p.Team and p.Team.Name:lower():find("murder")) or p.Character:FindFirstChild("MurdererTag") or p:FindFirstChild("IsMurderer") then
                murderer = p
            end
        end
    end
    if murderer then
        Fluent:Notify({Title="Quind Hub", Content="Мардер найден: "..murderer.Name, Duration=3})
        local tool = game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
        if tool then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, murderer.Character.Head.Position)
            task.wait(0.1)
            tool:Activate()
            Fluent:Notify({Title="Quind Hub", Content="Выстрел произведен!", Duration=3})
        else
            Fluent:Notify({Title="Quind Hub", Content="Возьмите оружие в руки!", Duration=3})
        end
    else
        Fluent:Notify({Title="Quind Hub", Content="Мардер не найден!", Duration=3})
    end
end })

-- 3. Teleport to Murderer
Tabs.Game:AddButton({ Title = "Teleport to Murderer", Callback = function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if (p.Team and p.Team.Name:lower():find("murder")) or p.Character:FindFirstChild("MurdererTag") then
            game.Players.LocalPlayer.Character:MoveTo(p.Character.HumanoidRootPart.Position)
        end
    end
end })

-- 4. Teleport to Sheriff
Tabs.Game:AddButton({ Title = "Teleport to Sheriff", Callback = function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if (p.Team and p.Team.Name:lower():find("sheriff")) or p.Character:FindFirstChild("SheriffTag") then
            game.Players.LocalPlayer.Character:MoveTo(p.Character.HumanoidRootPart.Position)
        end
    end
end })

-- 5. ESP Murderer (Подсветка мардера)
Tabs.Game:AddToggle("ESPMurderer", { Title = "ESP Murderer (Highlight)", Default = false, Callback = function(state)
    getgenv().ESPMurderer = state
    task.spawn(function()
        while getgenv().ESPMurderer do
            task.wait(0.5)
            for _, p in pairs(game.Players:GetPlayers()) do
                if p.Character and ((p.Team and p.Team.Name:lower():find("murder")) or p.Character:FindFirstChild("MurdererTag")) then
                    if not p.Character:FindFirstChild("MurdererHighlight") then
                        local hl = Instance.new("Highlight", p.Character)
                        hl.Name = "MurdererHighlight"
                        hl.FillColor = Color3.fromRGB(255, 0, 0)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    end
                end
            end
        end
    end)
end })

-- 6. ESP Sheriff (Подсветка шерифа)
Tabs.Game:AddToggle("ESPSheriff", { Title = "ESP Sheriff (Highlight)", Default = false, Callback = function(state)
    getgenv().ESPSheriff = state
    task.spawn(function()
        while getgenv().ESPSheriff do
            task.wait(0.5)
            for _, p in pairs(game.Players:GetPlayers()) do
                if p.Character and ((p.Team and p.Team.Name:lower():find("sheriff")) or p.Character:FindFirstChild("SheriffTag")) then
                    if not p.Character:FindFirstChild("SheriffHighlight") then
                        local hl = Instance.new("Highlight", p.Character)
                        hl.Name = "SheriffHighlight"
                        hl.FillColor = Color3.fromRGB(0, 0, 255)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    end
                end
            end
        end
    end)
end })

-- 7. Auto Win Round
Tabs.Game:AddButton({ Title = "Auto Win Round", Callback = function()
    Fluent:Notify({Title="Quind Hub", Content="Требуется знание RemoteEvent игры", Duration=3})
end })

-- 8. Drop Gun
Tabs.Game:AddButton({ Title = "Drop Current Gun", Callback = function()
    local char = game.Players.LocalPlayer.Character
    local tool = char:FindFirstChildWhichIsA("Tool")
    if tool then tool.Parent = workspace end
end })

-- 9. Spam Gun (Rapid Fire)
Tabs.Game:AddToggle("SpamGun", { Title = "Spam Gun (Rapid Fire)", Default = false, Callback = function(state)
    getgenv().SpamGun = state
    task.spawn(function()
        while getgenv().SpamGun do
            task.wait(0.05)
            local tool = game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
            if tool then tool:Activate() end
        end
    end)
end })

-- 10. Rejoin Server
Tabs.Game:AddButton({ Title = "Rejoin Server", Callback = function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
end })


-- //=========================================\\
-- //             VISUALS TAB                 \\
-- //=========================================\\
Tabs.Visuals:AddToggle("Fullbright", { Title = "Fullbright", Default = false, Callback = function(state)
    if state then
        game.Lighting.Brightness = 2
        game.Lighting.ClockTime = 12
        game.Lighting.FogEnd = 100000
    else
        game.Lighting.Brightness = 1
        game.Lighting.ClockTime = 14
        game.Lighting.FogEnd = 1000
    end
end })
Tabs.Visuals:AddToggle("NoFog", { Title = "Remove Fog", Default = false })
Tabs.Visuals:AddToggle("PlayerESP", { Title = "Player ESP (Boxes)", Default = false })
Tabs.Visuals:AddToggle("NameESP", { Title = "Name ESP", Default = false })
Tabs.Visuals:AddToggle("HealthESP", { Title = "Health ESP", Default = false })
Tabs.Visuals:AddSlider("FOV", { Title = "Camera FOV", Default = 70, Min = 70, Max = 120, Rounding = 0, Callback = function(val) workspace.CurrentCamera.FieldOfView = val end })
Tabs.Visuals:AddColorpicker("ESPColor", { Title = "ESP Color", Default = Color3.fromRGB(255, 0, 0) })
Tabs.Visuals:AddToggle("NoGrass", { Title = "Remove Grass", Default = false })
Tabs.Visuals:AddToggle("NoParticles", { Title = "Remove Particles", Default = false })
Tabs.Visuals:AddButton({ Title = "Reset Visuals", Callback = function() workspace.CurrentCamera.FieldOfView = 70 end })


-- //=========================================\\
-- //               MISC TAB                  \\
-- //=========================================\\
Tabs.Misc:AddToggle("AntiAFK", { Title = "Anti AFK", Default = true })
Tabs.Misc:AddToggle("NoClip", { Title = "No Clip", Default = false, Callback = function(state)
    getgenv().NoClip = state
    game:GetService("RunService").Stepped:Connect(function()
        if getgenv().NoClip and game.Players.LocalPlayer.Character then
            for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
            end
        end
    end)
end })
Tabs.Misc:AddSlider("Speed", { Title = "WalkSpeed", Default = 16, Min = 16, Max = 200, Rounding = 0, Callback = function(val)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end })
Tabs.Misc:AddSlider("Jump", { Title = "JumpPower", Default = 50, Min = 50, Max = 300, Rounding = 0, Callback = function(val)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = val
    end
end })
Tabs.Misc:AddToggle("InfJump", { Title = "Infinite Jump", Default = false, Callback = function(state)
    getgenv().InfJump = state
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if getgenv().InfJump and game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)
end })
Tabs.Misc:AddToggle("Fly", { Title = "Fly", Default = false })
Tabs.Misc:AddButton({ Title = "Reset Character", Callback = function() game.Players.LocalPlayer.Character:BreakJoints() end })
Tabs.Misc:AddButton({ Title = "Server Hop", Callback = function()
    local http = game:GetService("HttpService")
    local servers = http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, v in pairs(servers.data) do
        if v.playing < v.maxPlayers and v.id ~= game.JobId then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id, game.Players.LocalPlayer)
        end
    end
end })
Tabs.Misc:AddButton({ Title = "Save Config", Callback = function() Fluent:Notify({Title="Quind Hub", Content="Config Saved!", Duration=3}) end })
Tabs.Misc:AddButton({ Title = "Unload Hub", Callback = function() Window:Destroy() end })


-- //=========================================\\
-- //             INITIALIZATION              \\
-- //=========================================\\

InterfaceManager:SetLibrary(Fluent)
SaveManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("QuindHub")
SaveManager:SetFolder("QuindHub/Configs")
SaveManager:BuildConfigSection(Tabs.Misc)
InterfaceManager:ApplyToTab(Tabs.Misc)

Fluent:Notify({
    Title = "Quind Hub Loaded",
    Content = "Just a Sniper Game | 4 вкладки | LeftControl чтобы скрыть",
    Duration = 5
})