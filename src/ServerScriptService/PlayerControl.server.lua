--Ragdoll on Death
--Award 1 kill to killer on Death
--Equip player with their saved items
--Changes character name to player name
--Makes player Archiveable
--Changes player to Playing team

local playerService = game:GetService("Players")
local teamService = game:GetService("Teams")

local function equipWeapon(weaponName, character)
	local newWeapon =  game:GetService("ReplicatedStorage").Weapons:WaitForChild(weaponName):Clone()

	character:WaitForChild("HumanoidRootPart").Transparency = 1
	newWeapon.Parent = workspace
	newWeapon.Parent = character
	for _,v in pairs(newWeapon.Model:GetChildren()) do
		v.CanCollide = false
	end
end

local function equipAccessory(clothingName, category, character)
	if not clothingName or string.len(clothingName) < 1 then return end --If the reqested accessory from activatePlayerItemReload is nil, do nothing.
	local clothingModelClone = game:GetService("ReplicatedStorage").Accessories[category]:WaitForChild(clothingName):Clone()

	for _,v in pairs(clothingModelClone:GetChildren()) do
		if v.Name == "Stats" then v:Destroy() else
			v.Parent = workspace
			v.Parent = character
		end
	end
end

--TODO There's a better way to do this.
local function loadPlayerItems(player, character)
	local inventory = player.Inventory
	print(inventory.ActiveWeapon.Value)
	equipWeapon(inventory.ActiveWeapon.Value, character)
	equipAccessory(inventory.ActiveFootwear.Value, "Footwear", character)
	equipAccessory(inventory.ActiveHair.Value, "Hair", character)
	equipAccessory(inventory.ActiveHeadwear.Value, "Headwear", character)
	equipAccessory(inventory.ActiveJacket.Value, "Jacket", character)
	equipAccessory(inventory.ActivePants.Value, "Pants", character)
	equipAccessory(inventory.ActiveShirt.Value, "Shirt", character)
	equipAccessory(inventory.ActiveExtra1.Value, "Extra", character)
	equipAccessory(inventory.ActiveExtra2.Value, "Extra", character)
	equipAccessory(inventory.ActiveExtra3.Value, "Extra", character)
end

--TODO There's a better way to do this.
--TODO The better way is to loop through every inventory item variable and use a combined version of equipWeapon
--and equipAccessory to set each slot's item.
local function activatePlayerItemReload(player, character)
	print("activateplayerreload")
	local inventory = player.Inventory
	inventory.ActiveWeapon.Changed:Connect(function() equipWeapon(inventory.ActiveWeapon.Value, character) end)
	inventory.ActiveFootwear.Changed:Connect(function() equipAccessory(inventory.ActiveFootwear.Value, "Footwear", character) end)
	inventory.ActiveHair.Changed:Connect(function() equipAccessory(inventory.ActiveHair.Value, "Hair", character) end)
	inventory.ActiveHeadwear.Changed:Connect(function() equipAccessory(inventory.ActiveHeadwear.Value, "Headwear", character) end)
	inventory.ActiveJacket.Changed:Connect(function() equipAccessory(inventory.ActiveJacket.Value, "Jacket", character) end)
	inventory.ActivePants.Changed:Connect(function() equipAccessory(inventory.ActivePants.Value, "Pants", character) end)
	inventory.ActiveShirt.Changed:Connect(function() equipAccessory(inventory.ActiveShirt.Value, "Shirt", character) end)
	inventory.ActiveExtra1.Changed:Connect(function() equipAccessory(inventory.ActiveExtra1.Value, "Extra", character) end)
	inventory.ActiveExtra2.Changed:Connect(function() equipAccessory(inventory.ActiveExtra2.Value, "Extra", character) end)
	inventory.ActiveExtra3.Changed:Connect(function() equipAccessory(inventory.ActiveExtra3.Value, "Extra", character) end)
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
	loadPlayerItems(player, character)
	activatePlayerItemReload(player, character)
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