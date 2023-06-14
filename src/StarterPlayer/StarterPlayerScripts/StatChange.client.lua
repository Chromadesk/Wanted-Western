local playerService = game:GetService("Players")
local player = playerService.LocalPlayer
local playerData = player.PlayerScripts:WaitForChild("PlayerData")

local dataKills = playerData.Kills
local dataIncome = playerData.Income
local dataDeaths = playerData.Deaths
local dataWantedCount = playerData.WantedCount --already taken care of by Bounties localscript

player.CharacterAdded:Connect(function(character)
	character:WaitForChild("Humanoid").Died:Connect(function()
		dataDeaths.Value += 1
	end)
end)

game:GetService("ReplicatedStorage").DeathReceiptRE.OnClientEvent:Connect(function(reward)
	dataKills.Value += 1
	if reward then
		dataIncome.Value += reward
		player:WaitForChild("Inventory"):WaitForChild("TotalMoney").Value += reward
	else
		dataIncome.Value += 25
		player:WaitForChild("Inventory"):WaitForChild("TotalMoney").Value += 25
	end
end)