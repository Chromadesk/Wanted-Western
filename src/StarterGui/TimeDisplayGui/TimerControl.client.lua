local player = game:GetService("Players").LocalPlayer
local repStorageService = game:GetService("ReplicatedStorage")
local CurrentMap = workspace:WaitForChild("Map")

local timeDisplayGUI = script.Parent
local timerGUI = timeDisplayGUI:WaitForChild("Timer")
local gamemodeGUI = timeDisplayGUI:WaitForChild("Gamemode")


function updateGUI(map)
	gamemodeGUI.Text = repStorageService.MapGamemode.Value
	repStorageService.MapTimeRemaining.Changed:Connect(function()
		local mapTime = repStorageService.MapTimeRemaining.Value
		timerGUI.Text = math.floor(mapTime / 60) ..":" ..mapTime % 60
	end)
end

updateGUI(CurrentMap)
CurrentMap.Destroying:Connect(function()
	wait(2)
	CurrentMap = workspace:WaitForChild("Map")
	updateGUI(CurrentMap)
end)

player.Changed:Connect(function()
	if player.Team == game:GetService("Teams").Playing then
		timeDisplayGUI.Enabled = true
	else
		timeDisplayGUI.Enabled = false
	end
end)