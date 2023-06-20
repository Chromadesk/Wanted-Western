--Loads player data
--Saves player data
--Creates the Inventory folder for the player
--Loads player money

local DataStoreService = game:GetService("DataStoreService")
local inventoryStore = DataStoreService:GetDataStore("PlayerInventory")

local PlayerService = game:GetService("Players")

--TODO add the clothing instances to the save/load routine
PlayerService.PlayerAdded:Connect(function(player)
	local playerInv = Instance.new("Folder")
	playerInv.Name = "Inventory"
	playerInv.Parent = player
	
	local totalMoney = Instance.new("IntValue")
	totalMoney.Name = "TotalMoney"
	totalMoney.Value = 0
	totalMoney.Parent = playerInv
	
	local activeWeapon = Instance.new("StringValue")
	activeWeapon.Name = "ActiveWeapon"
	activeWeapon.Value = "Stock Revolver"
	activeWeapon.Parent = playerInv
	
	local activeFootwear = Instance.new("StringValue")
	activeFootwear.Name = "ActiveFootwear"
	activeFootwear.Value = "Cowboy Boots"
	activeFootwear.Parent = playerInv
	
	local activeHair = Instance.new("StringValue")
	activeHair.Name = "ActiveHair"
	activeHair.Value = "Shorthair"
	activeHair.Parent = playerInv
	
	local activeHeadwear = Instance.new("StringValue")
	activeHeadwear.Name = "ActiveHeadwear"
	activeHeadwear.Value = "Cowboy Hat"
	activeHeadwear.Parent = playerInv
	
	local activeJacket = Instance.new("StringValue")
	activeJacket.Name = "ActiveJacket"
	--No default because i hate the pooor hhrgggggrggg
	activeJacket.Parent = playerInv
	
	local activePants = Instance.new("StringValue")
	activePants.Name = "ActivePants"
	activePants.Value = "Jeans"
	activePants.Parent = playerInv
	
	local activeShirt = Instance.new("StringValue")
	activeShirt.Name = "ActiveShirt"
	activeShirt.Value = "Flannel Shirt"
	activeShirt.Parent = playerInv
	
	local activeExtra1 = Instance.new("StringValue")
	activeExtra1.Name = "ActiveExtra1"
	--No default because i hate the pooor hhrgggggrggg
	activeExtra1.Parent = playerInv
	
	local activeExtra2 = Instance.new("StringValue")
	activeExtra2.Name = "ActiveExtra2"
	--No default because i hate the pooor hhrgggggrggg
	activeExtra2.Parent = playerInv
	
	local activeExtra3 = Instance.new("StringValue")
	activeExtra3.Name = "ActiveExtra3"
	--No default because i hate the pooor hhrgggggrggg
	activeExtra3.Parent = playerInv
	
	local invData = inventoryStore:GetAsync(player.UserId)
	
	if invData then
		local function corruptionDefault(data, default) -- Prevents a nil error in case the invData object can't be found
			if data then return data end
			return default
		end
		totalMoney.Value = corruptionDefault(invData["TotalMoney"], 0)
		activeWeapon.Value = corruptionDefault(invData["ActiveWeapon"], "Stock Revolver")
		activeFootwear.Value = corruptionDefault(invData["ActiveFootwear"], "Cowboy Boots")
		activeHair.Value = corruptionDefault(invData["ActiveHair"], "Shorthair")
		activeHeadwear.Value = corruptionDefault(invData["ActiveHeadwear"], "Cowboy Hat")
		activeJacket.Value = corruptionDefault(invData["ActiveJacket"], "")
		activePants.Value = corruptionDefault(invData["ActivePants"], "Jeans")
		activeShirt.Value = corruptionDefault(invData["ActiveShirt"], "Flannel Shirt")
		activeExtra1.Value = corruptionDefault(invData["ActiveExtra1"], "")
		activeExtra2.Value = corruptionDefault(invData["ActiveExtra2"], "")
		activeExtra3.Value = corruptionDefault(invData["ActiveExtra3"], "")
		print("Loaded data: UserId " ..player.UserId)
	else
		print("New player: UserId " ..player.UserId)
	end
end)

PlayerService.PlayerRemoving:Connect(function(player)
	local savePackage = {
		TotalMoney = player.Inventory.TotalMoney.Value,
		ActiveWeapon = player.Inventory.ActiveWeapon.Value,
		ActiveFootwear = player.Inventory.ActiveFootwear.Value,
		ActiveHair = player.Inventory.ActiveHair.Value,
		ActiveHeadwear = player.Inventory.ActiveHeadwear.Value,
		ActiveJacket = player.Inventory.ActiveJacket.Value,
		ActivePants = player.Inventory.ActivePants.Value,
		ActiveShirt = player.Inventory.ActiveShirt.Value,
		ActiveExtra1 = player.Inventory.ActiveExtra1.Value,
		ActiveExtra2 = player.Inventory.ActiveExtra2.Value,
		ActiveExtra3 = player.Inventory.ActiveExtra3.Value
	}
	local success, errMessage = pcall(function()
		inventoryStore:SetAsync(player.UserId, savePackage)
	end)
	if success then
		print("Saved data: UserId " ..player.UserId)
	else
		warn("Failed to save data: UserId " ..player.UserId)
	end
	print(savePackage)
end)