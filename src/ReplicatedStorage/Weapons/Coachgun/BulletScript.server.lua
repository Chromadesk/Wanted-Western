--Spawn & fire bullets
--Control bullet collisions (bullet v player, bullet v accessory, bullet v bullet, bullet v part)

--swag

local gun = script.Parent
local tweenService = game:GetService("TweenService")

local player = nil
local damage = nil
local projectileSpeed = nil

local function spawnMetalClump(bullet)
	local clump = Instance.new("Part")
	clump.CFrame = bullet.CFrame
	clump.Name = "Metal Clump"
	clump.Size = Vector3.new(0.6,0.6,0.6)
	clump.Shape = Enum.PartType.Ball
	clump.Color = Color3.new(163, 162, 165)
	clump.Material = "CorrodedMetal"
	clump.Anchored = false
	local collisionSound = gun.Collisionsound:Clone()
	collisionSound.Parent = clump
	
	clump.Parent = workspace
	
	collisionSound:Play()
	collisionSound.Ended:Connect(function() clump:Destroy() end)
end

local function getBullet(character, damage)
	local bullet = Instance.new("Part")
	bullet.Name = "Bullet"
	bullet.Size = Vector3.new(0.2, 0.2, 2)
	bullet.Color = Color3.fromRGB(255, 237, 134)
	bullet.Material = "Neon"
	bullet.Anchored = false
	bullet.CanCollide = false
	bullet.CastShadow = false
	
	bullet.Touched:Connect(
		function(toucher)
			if not toucher then return end
			for i,v in ipairs(character:GetDescendants()) do
				if toucher == v then return end
			end
			--Hitting a player
			if toucher.Parent and toucher.Parent:FindFirstChild("Humanoid") then
				local originalHealth = toucher.Parent.Humanoid.Health -- bad way of determining the actual amount of damage done
				toucher.Parent.Humanoid:TakeDamage(damage)

				toucher.Parent.Data.LastAttacker.Value = player.Name
				
				gun.HitRE:FireClient(player, toucher.Parent, originalHealth - toucher.Parent.Humanoid.Health)
			end
			--Hitting a bullet
			if toucher.Name == "Bullet" then
				spawnMetalClump(bullet)
			end
			--Things to ignore if hit
			if toucher.Parent and toucher.Parent:IsA("Accessory") or
				toucher.Parent and toucher.Parent.Parent:IsA("Accessory") or
				toucher.Parent and toucher.Parent.Name == "BulletIgnore" or
				toucher.Parent and toucher.Name == "Snake Oil Spawn"
			then return end
			bullet:Destroy()
		end
	)
	return bullet
end

local function spawnBullet(player, damage, projectileSpeed)
	local character = workspace:WaitForChild(player.Name)
	local bullet = getBullet(character, damage)
	bullet.CFrame = character.HumanoidRootPart.CFrame
	bullet.CFrame = bullet.CFrame:ToWorldSpace(CFrame.new(0, 0, -1))
	bullet.Parent = workspace
	local tweenInfo = TweenInfo.new(projectileSpeed,Enum.EasingStyle.Linear,Enum.EasingDirection.In,0,false,0)
	local tweenGoal = {CFrame = bullet.CFrame:ToWorldSpace(CFrame.new(0,0,-100))}
	local tween = tweenService:Create(bullet, tweenInfo, tweenGoal)
	gun.Handle.Firesound:Play()
	tween:Play()
	tween.Completed:Connect(function() bullet:Destroy() end)
end


gun.FireRE.OnServerEvent:Connect(
	function(a, b, c)
		player = a
		damage = b
		projectileSpeed = c
		spawnBullet(player, damage, projectileSpeed)
	end
)