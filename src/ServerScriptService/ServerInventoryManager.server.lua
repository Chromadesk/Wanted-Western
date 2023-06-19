local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

ReplicatedStorage.WeaponsRE.OnServerEvent:Connect(function(player)
        ReplicatedStorage.WeaponsRE:FireClient(player, ReplicatedStorage.Guns:GetChildren(), ReplicatedStorage.Melees:GetChildren())
    end)