--Ragdoll on Death
--Award 1 kill to killer on Death
--Equip player with Stock Revolver
--Equip player with clothes
--Changes character name to player name
--Makes player Archiveable
--Changes player to Playing team

local playerService = game:GetService("Players")
local teamService = game:GetService("Teams")

local function equipWeapon(weaponName, category, character)
	local newWeapon =  game:GetService("ReplicatedStorage")[category]:WaitForChild(weaponName):Clone()

	character:WaitForChild("HumanoidRootPart").Transparency = 1
	newWeapon.Parent = workspace
	newWeapon.Parent = character
	for _,v in pairs(newWeapon.Model:GetChildren()) do
		v.CanCollide = false
	end
end

local function equipAccessory(clothingName, category, character)
	local clothingModelClone = game:GetService("ReplicatedStorage").Accessories[category]:WaitForChild(clothingName):Clone()

	for _,v in pairs(clothingModelClone:GetChildren()) do
		if v.Name == "Stats" then v:Destroy() else
			print(v.Name)
			v.Parent = workspace
			v.Parent = character
		end
	end
end

local function loadPlayerItems(player, character)
	
end

local function rewardKiller(player, character)
	character.Humanoid.Died:Connect(
		function()
			local killer = workspace:FindFirstChild(character.Data.LastAttacker.Value)
			if killer then
				local reward
				if character.Data.IsWanted.Value then reward = character.Data.CurrentBounty.Value end
				killer.Data.Killstreak.Value += 1
				game:GetService("ReplicatedStorage").DeathReceiptRE:FireClient(playerService:FindFirstChild(character.Data.LastAttacker.Value), reward)
			end
			character.Data.Killstreak.Value = 0
	end)
end

local function readyCharacter(player, character)
	character.Humanoid.DisplayName = player.Name
	character.Archivable = true
	character.Humanoid.WalkSpeed = 16
	
	player.CharacterAdded:Connect(
		function()
			player.Team = teamService.Spectating
			character.Data.Processed.Value = false
	end)
end

local function doPlayerProcessing(player)
	if player and player.Team ~= teamService.Playing or workspace:WaitForChild(player.Name).Data.Processed.Value then return end
	local character = workspace:WaitForChild(player.Name)
	character.Data.Processed.Value = true
	
	local menuGUI = player.PlayerGui:WaitForChild("MenuGui")
	menuGUI.Enabled = false
	
	readyCharacter(player, character)

	equipWeapon("Pickaxe", "Melees", character)
	
	equipAccessory("Flannel Shirt", "Shirt", character)
	equipAccessory("Jeans", "Pants", character)
	equipAccessory("Cowboy Boots", "Footwear", character)
	equipAccessory("Shorthair", "Hair", character)
	equipAccessory("Cowboy Hat", "Headwear", character)

	rewardKiller(player, character)
	
	local i = false	
	while not i do
		for _,v in workspace:WaitForChild("Map"):GetDescendants() do
			if v.Name == "SpawnLocation" then
				if math.round(math.random(1, 3)) == 3 then
					character.HumanoidRootPart.CFrame = CFrame.new(v.Position + Vector3.new(0, 5, 0))
					i = true
				end
			end
		end
	end
	
end

playerService.PlayerAdded:Connect(
	function(player)
		player.Changed:Connect(function()
			doPlayerProcessing(player)
		end)
	end)

game:GetService("ReplicatedStorage").TeamChangeRE.OnServerEvent:Connect(function(player, team)
	if team ~= "Playing" then return end
	player.Team = teamService[team]
end)