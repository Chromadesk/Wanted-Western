local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

ReplicatedStorage.WeaponsRE.OnServerEvent:Connect(function(player)
        ReplicatedStorage.WeaponsRE:FireClient(player, ReplicatedStorage.Weapons:GetChildren())
    end)

ReplicatedStorage.SelectedItemRE.OnServerEvent:Connect(function(player, selectedItem)
    player.Inventory[selectedItem.Stats.Category.Value].Value = selectedItem.Name
end)