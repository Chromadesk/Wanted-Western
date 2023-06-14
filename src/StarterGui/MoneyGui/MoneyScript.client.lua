local player = game:GetService("Players").LocalPlayer
local totalMoney = player:WaitForChild("Inventory"):WaitForChild("TotalMoney")

local moneyDisplay = script.Parent:WaitForChild("Frame"):WaitForChild("Amount")

function comma_value(amount)
	local formatted = amount
	while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

totalMoney.Changed:Connect(function()
	moneyDisplay.Text = "$" ..comma_value(tostring(totalMoney.Value))
end)