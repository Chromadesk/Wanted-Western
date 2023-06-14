local playerService = game:GetService("Players")
local player = playerService.LocalPlayer
local playerDataRequestRE = game:GetService("ReplicatedStorage").PlayerDataRequestRE
local playerDataPostmanRE = game:GetService("ReplicatedStorage").PlayerDataPostmanRE

local endGameGUI = player.PlayerGui:WaitForChild("EndGameGui")
local frameGUI = endGameGUI:WaitForChild("Frame")
local mostWantedGUI = frameGUI:WaitForChild("MostWanted")
local mostIncomeGUI = frameGUI:WaitForChild("MostIncome")
local mostKillsGUI = frameGUI:WaitForChild("MostKills")
local mostDeathsGUI = frameGUI:WaitForChild("MostDeaths")

local scoreboardGUI = frameGUI:WaitForChild("Scoreboard")
local playerScoreGUI = scoreboardGUI:WaitForChild("PlayerScore")

function sortPlayersByStat(playerDataList, stat)
	--I HATE TABLE.SORT()!!!!!!!!!!!!!1
	local statArray = {}
	local i = 1
	for _,v in pairs(playerDataList) do
		statArray[i] = v.PlayerData[stat]
		i += 1
	end
	
	i = 1
	table.sort(statArray, function(a, b) return a > b end)
	
	local sortedArray = {}
	local usedNames = {}
	for _,v in ipairs(statArray) do
		for _,j in pairs(playerDataList) do
			if j.PlayerData[stat] == v and not table.find(usedNames, j.Player.Name) then
				sortedArray[i] = {Name = j.Player.Name, Value = v}
				usedNames[i] = j.Player.Name
			end
		end
		i += 1
	end
	
	return sortedArray
end

playerDataRequestRE.OnClientEvent:Connect(function()
	local playerData = player.PlayerScripts.PlayerData
	local playerDataCopy = { -- sneaky server client wall bypass
		WantedCount = playerData.WantedCount.Value,
		Income = playerData.Income.Value,
		Kills = playerData.Kills.Value,
		Deaths = playerData.Deaths.Value
	} 
	
	workspace:FindFirstChild("Map").Destroying:Connect(function()
		endGameGUI.Enabled = false
		endGameGUI.EndGameSong:Stop()
		player.PlayerScripts.PlayerData.WantedCount.Value = 0
		player.PlayerScripts.PlayerData.Income.Value = 0
		player.PlayerScripts.PlayerData.Kills.Value = 0
		player.PlayerScripts.PlayerData.Deaths.Value = 0
		player.Character.Humanoid.Health = 0
	end)
	
	playerDataRequestRE:FireServer(playerDataCopy)
end)

playerDataPostmanRE.OnClientEvent:Connect(function(playerDataList)
	player.Character:WaitForChild("Humanoid").WalkSpeed = 0

	local sortedWanted = sortPlayersByStat(playerDataList, "WantedCount")
	mostWantedGUI.PlayerName.Text = sortedWanted[1].Name
	mostWantedGUI.Score.Text = "Killstreak: " ..tostring(sortedWanted[1].Value)
		
	local sortedIncome = sortPlayersByStat(playerDataList, "Income")
	mostIncomeGUI.PlayerName.Text = sortedIncome[1].Name
	mostIncomeGUI.Score.Text = "Earnings: $" ..tostring(sortedIncome[1].Value)
		
	local sortedKills = sortPlayersByStat(playerDataList, "Kills")
	mostKillsGUI.PlayerName.Text = sortedKills[1].Name
	mostKillsGUI.Score.Text = "Killcount: " ..tostring(sortedKills[1].Value)
	
	local sortedDeaths = sortPlayersByStat(playerDataList, "Deaths")
	mostDeathsGUI.PlayerName.Text = sortedDeaths[1].Name
	mostDeathsGUI.Score.Text = "Deaths: " ..tostring(sortedDeaths[1].Value)
	
	local scorePos = 0.05
	for _,v in pairs(sortedKills) do
		local playerScoreClone = playerScoreGUI:Clone()
		playerScoreClone.Name = "PlayerScore" ..tostring(v.Name)
		playerScoreClone:WaitForChild("PlayerName").Text = v.Name
		playerScoreClone:WaitForChild("Score").Text = "N/A"
		playerScoreClone:WaitForChild("PlayerHeadshot").Image = playerService:GetUserThumbnailAsync(playerService:FindFirstChild(v.Name).UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
		playerScoreClone.Parent = scoreboardGUI
		playerScoreClone.Position = UDim2.fromScale(0,playerScoreClone.Position.Y.Scale + scorePos)
		scorePos += 0.05
		playerScoreClone.Visible = true
	end

	endGameGUI.Enabled = true
	endGameGUI.EndGameSong:Play()
end)

