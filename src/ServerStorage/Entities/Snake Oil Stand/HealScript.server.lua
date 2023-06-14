local cart = script.Parent
--local salesman = cart.SnakeOilSalesman
local hitbox = cart:WaitForChild("BulletIgnore"):WaitForChild("Hitbox")
local primaryPart = cart.BulletIgnore:WaitForChild("Otherbox")
local healCount = 0
local maxHeals = 5 --Maximum healings before the cart leaves
local globalWait = 0
local isCartActive = true

function leaveSpawn()
	isCartActive = false
	primaryPart.Leave1:Play()
	primaryPart.Leave2:Play()
	wait(1)
	cart:Destroy()
end

hitbox.Touched:Connect(function(a)
	if globalWait == 0 and isCartActive and a.Parent and a.Parent:FindFirstChild("Humanoid") then
		if a.Parent.Humanoid.Health >= a.Parent.Humanoid.MaxHealth then return end
		a.Parent.Humanoid.Health += math.round(a.Parent.Humanoid.MaxHealth * 0.50)
		
		primaryPart.Heal1:Play()
		primaryPart.Heal1.Ended:Connect(function() primaryPart.Heal2:Play() end)
		
		if healCount == maxHeals then leaveSpawn() return end
		healCount += 1
		globalWait = 10
		repeat
			globalWait -= 1
			wait(1)
		until globalWait == 0
	end
end)