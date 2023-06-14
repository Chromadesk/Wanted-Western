local CART = game:GetService("ServerStorage").Entities:WaitForChild("Snake Oil Stand")
local CurrentMap = workspace:WaitForChild("Map")

function getApplicableSpawns(map)
	local spawns = {}
	local i = 1
	for _,v in pairs(map:GetChildren()) do
		if v.Name == "Snake Oil Spawn" then
			v.Transparency = 1
			spawns[i] = v
			i += 1
		end
	end
	return spawns
end

function canCartSpawn(applicableSpawns)
	for _,v in pairs(applicableSpawns) do
		if v:FindFirstChild("Snake Oil Stand") then
			return false
		end
	end
	return true
end

function runCartCycle(map)
	CurrentMap.Destroying:Connect(function()
		wait(2)
		CurrentMap = workspace:WaitForChild("Map")
		runCartCycle(CurrentMap)
	end)
	
	local applicableSpawns = getApplicableSpawns(map)
	while CurrentMap do
		if canCartSpawn(applicableSpawns) then
			local newCart = CART:Clone()
			local spawnPoint = applicableSpawns[math.random(1, #applicableSpawns)]
			newCart.Parent = spawnPoint
			
			newCart:SetPrimaryPartCFrame(
				CFrame.new(spawnPoint.Position) *
					(newCart.BulletIgnore.Otherbox.CFrame - newCart.BulletIgnore.Otherbox.CFrame.Position)
			)

			---newCart:SetPrimaryPartCFrame(newCart.BulletIgnore.Otherbox.CFrame * CFrame.Angles(0, math.rad(45), 0))
		end
		wait(60)
	end
end

runCartCycle(CurrentMap)