local player:Player = game:GetService("Players").LocalPlayer
local starterGUI:PlayerGui = player:WaitForChild("PlayerGui")

local optionFrame = script.Parent
local joinButton = optionFrame:WaitForChild("JoinButton")
local storeButton = optionFrame:WaitForChild("StoreButton")
local inventoryButton = optionFrame:WaitForChild("InventoryButton")
local settingsButton = optionFrame:WaitForChild("SettingsButton")
joinButton:WaitForChild("MapName").Text = game:GetService("ReplicatedStorage").MapName.Value

joinButton.MouseButton1Click:Connect(function()
	starterGUI:WaitForChild("StoreGui").Enabled = false
	game:GetService("ReplicatedStorage").TeamChangeRE:FireServer("Playing")
end)

storeButton.MouseButton1Click:Connect(function()
	starterGUI:WaitForChild("StoreGui").Enabled = true
end)