--Sets player team to Spectator

local playerService = game:GetService("Players")
local teamService = game:GetService("Teams")

local function doSpectatorProcessing(player)
	if player and player.Team ~= teamService.Spectating then return end
	workspace:WaitForChild(player.Name).Humanoid.WalkSpeed = 0
	player:WaitForChild("PlayerGui"):WaitForChild("MenuGui").Enabled = true
	player:WaitForChild("PlayerGui"):WaitForChild("MoneyGui").Enabled = true
end

playerService.PlayerAdded:Connect(
	function(player)
		player.Team = teamService.Spectating
		player.Changed:Connect(
			function()
				doSpectatorProcessing(player)
			end)
	end)