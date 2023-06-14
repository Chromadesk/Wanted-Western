local ServerStorage = game:GetService("ServerStorage")
local player = game:GetService("Players").LocalPlayer

local StoreGui = script.Parent
local InnerFrame = StoreGui:WaitForChild("OuterFrame"):WaitForChild("InnerFrame")
local NPCImage = InnerFrame:WaitForChild("NPCImage")
local ExitButton = InnerFrame:WaitForChild("ExitButton")
local Menu = InnerFrame:WaitForChild("Menu")
local Card1 = InnerFrame:WaitForChild("Card1")
local Card2 = InnerFrame:WaitForChild("Card2")
local CategoryName = InnerFrame:WaitForChild("Category"):WaitForChild("CategoryName")

--Top Right
local TopRight = InnerFrame:WaitForChild("TopRight")
local TRViewport = TopRight:WaitForChild("ViewportFrame")
local BuyButton = TopRight:WaitForChild("BuyButton")
local DamageText = TopRight:WaitForChild("Damage")
local AmmoText = TopRight:WaitForChild("Ammo")
local FirespeedText = TopRight:WaitForChild("Firespeed")
local ReloadText = TopRight:WaitForChild("Reload")
local RangeText = TopRight:WaitForChild("Range")

--Icon Template
local IconTemplate = Menu:WaitForChild("Icon")
IconTemplate:Destroy()

function TableConcat(t1,t2)
	for i=1,#t2 do
		t1[#t1+1] = t2[i]
	end
	return t1
end

function displayItems() 
	local items = TableConcat(ServerStorage.Guns, ServerStorage.Melees)
	
end