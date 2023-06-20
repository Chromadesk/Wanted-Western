--TODO Add sounds for clicking on stuff
local ServerStorage = game:GetService("ServerStorage")
local player = game:GetService("Players").LocalPlayer

local StoreGui = script.Parent
local InnerFrame = StoreGui:WaitForChild("OuterFrame"):WaitForChild("InnerFrame")
local NPCImage = InnerFrame:WaitForChild("NPCImage")
local ExitButton = InnerFrame:WaitForChild("ExitButton")
local Menu = InnerFrame:WaitForChild("Menu")
local Card1 = InnerFrame:WaitForChild("Card1")
local CategoryName = InnerFrame:WaitForChild("Category"):WaitForChild("CategoryName")
local selectedItem = nil

--Top Right
local TopRight = InnerFrame:WaitForChild("TopRight")
local TRViewport = TopRight:WaitForChild("ViewportFrame")
local BuyButton = TopRight:WaitForChild("BuyButton")
local DamageText = TopRight:WaitForChild("Damage")
local AmmoText = TopRight:WaitForChild("Ammo")
local FirespeedText = TopRight:WaitForChild("Firespeed")
local ReloadText = TopRight:WaitForChild("Reload")
local RangeText = TopRight:WaitForChild("Range")
local TRItemName = TopRight:WaitForChild("ItemName")
local TRPrice = TopRight:WaitForChild("Price")

--Icon Template
local IconTemplate = StoreGui:WaitForChild("Icon")

function TableConcat(t1,t2)
	for i=1,#t2 do
		t1[#t1+1] = t2[i]
	end
	return t1
end

function setupViewportFrame(item, viewportFrame)
	local viewportCamera = Instance.new("Camera")
	viewportCamera.Name = "ViewportCamera"
	viewportFrame.CurrentCamera = viewportCamera
	viewportCamera.Parent = workspace
	
	local itemClone = item:Clone()
	for _,v in pairs(itemClone:GetChildren()) do --SKIN IT!!! same as skin him, finds scripts and removes them
		if not v:IsA("Part") and not v:IsA("Model") and not v:IsA("Folder") then v:Destroy() end
	end
	local CamPart = itemClone.Model.CamPart
	itemClone.Name = itemClone.Name .. "Dummy"
	itemClone.Parent = workspace
	itemClone.Model:PivotTo(CFrame.new(0, 0, 0) * CFrame.Angles(0, 90, 0))
	
	itemClone.Parent = viewportFrame
	
	viewportCamera.CFrame = CFrame.new(Vector3.new(CamPart.Position.X -2, CamPart.Position.Y, CamPart.Position.Z), CamPart.Position) 
end

function displayMainItem(item)
	for _,v in pairs(TRViewport:GetChildren()) do
		v:Destroy()
	end
	setupViewportFrame(item, TRViewport)

	DamageText.Text = item.Stats.Damage.Value
	AmmoText.Text = item.Stats.Ammo.Value
	FirespeedText.Text = item.Stats.Firespeed.Value
	ReloadText.Text = item.Stats.ReloadTime.Value
	RangeText.Text = item.Stats.Range.Value
	TRItemName.Text = item.Name
	TRPrice.Text = item.Stats.Cost.Value

	selectedItem = item
end

function displayItems()
	print("See DisplayItems line 74")
	--TODO Move all weapons from Guns & Melees to one Weapons folder.
	--TODO Update everything to make all items equip from the player's inventory not from hard code.

	local items
	game:GetService("ReplicatedStorage").WeaponsRE:FireServer()
	game:GetService("ReplicatedStorage").WeaponsRE.OnClientEvent:Connect(function(guns, melees)
		print(guns)
		print(melees)
		items = TableConcat(guns, melees)
		print(items)
	end)
	repeat wait() until items

	for _,v in pairs(items) do
		local icon = IconTemplate:Clone()
		icon.ItemName.Value = v.Name
		icon.Cost.Text = "$" ..v.Stats.Cost.Value --TODO Install same number formatting code in bounty script to here
		icon.Title.Text = v.Name
		setupViewportFrame(v, icon.ViewportFrame)

		icon.MouseButton1Click:Connect(function() displayMainItem(v) end)

		icon.Parent = Menu
		icon.Visible = true
	end

	BuyButton.MouseButton1Click:Connect(function()
		if not selectedItem then return end
		player.Inventory[selectedItem.Stats.Category.Value].Value = selectedItem.Name
		print(player.Inventory[selectedItem.Stats.Category.Value].Value)
	end)
end

displayItems()

ExitButton.MouseButton1Click:Connect(function()
	StoreGui.Enabled = false
end)