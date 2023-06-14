--Changes map
--Sends game over notice to clients
--Sets map length

local mapList = game:GetService("ServerStorage").Maps:GetChildren()
local replicatedStorageService = game:GetService("ReplicatedStorage")
local playerDataRequestRE = replicatedStorageService.PlayerDataRequestRE
local playerDataPostmanRE = replicatedStorageService.PlayerDataPostmanRE
local rotationTime = 10 * 60
local scoreboardDisplayTime = 20

function applyGlassScript(map: Model)
	for _,v in pairs(map:GetDescendants()) do
		if v.Name == "Glass" then
			local gScript = script.GlassScript:Clone()
			gScript.Parent = v
			gScript.Enabled = true
		end
	end
end

function selectMap()
	if workspace:FindFirstChild("Map") then warn("MapControl: A map is already present.") return end
	local map = mapList[math.round(math.random(1,#mapList))]:Clone()
	replicatedStorageService.MapName.Value = map.Name
	replicatedStorageService.MapGamemode.Value = map.Data.Gamemode.Value
	replicatedStorageService.MapTimeRemaining.Value = rotationTime
	map.Name = "Map"
	map.Parent = workspace
	applyGlassScript(map)
end

function distributePlayerData()
	playerDataRequestRE:FireAllClients()
	local players = game:GetService("Players"):GetPlayers()
	local playerDataList = {}
	playerDataRequestRE.OnServerEvent:Connect(function(player, playerData)
		local container = {
			Player = player,
			PlayerData = playerData
		}
		table.insert(playerDataList, container)
		end)
	repeat wait() until #playerDataList == #players
	playerDataPostmanRE:FireAllClients(playerDataList)
end

function removeMap()
	distributePlayerData()
	wait(scoreboardDisplayTime)
	workspace:WaitForChild("Map"):Destroy()
end

while true do
	selectMap()
	while replicatedStorageService.MapTimeRemaining.Value > 0 do
		replicatedStorageService.MapTimeRemaining.Value -= 1
		wait(1)
	end
	removeMap()
end