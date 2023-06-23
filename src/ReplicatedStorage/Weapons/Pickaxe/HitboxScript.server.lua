local melee = script.Parent
local tweenService = game:GetService("TweenService")

local player = nil
local damage = nil
local fireSpeed = nil
local character = nil

local debounce = false

melee.MeleeHitbox.Touched:Connect(
	function(toucher)
		print(toucher)
		if not toucher or debounce then return end
		for i,v in ipairs(character:GetDescendants()) do
			if toucher == v then return end
		end
		--Hitting a player
		if toucher.Parent and toucher.Parent:FindFirstChild("Humanoid") then
			local originalHealth = toucher.Parent.Humanoid.Health -- bad way of determining the actual amount of damage done
			toucher.Parent.Humanoid:TakeDamage(damage)

			toucher.Parent.Data.LastAttacker.Value = player.Name

			melee.HitRE:FireClient(player, toucher.Parent, originalHealth - toucher.Parent.Humanoid.Health)
		end
		--Things to ignore if hit
		if toucher.Parent and toucher.Parent:IsA("Accessory") or
			toucher.Parent and toucher.Parent.Parent:IsA("Accessory") or
			toucher.Parent and toucher.Parent.Name == "BulletIgnore" or
			toucher.Parent and toucher.Name == "Snake Oil Spawn"
		then return end
		
		print("disabling hitbox on melee")
		debounce = true
		melee.MeleeHitbox.CanTouch = false
	end)

function activateHitbox(player, damage, fireSpeed)
	wait(fireSpeed / 2)
	melee.Handle.Firesound.TimePosition = 0.2
	melee.Handle.Firesound:Play()
	debounce = false
	melee.MeleeHitbox.CanTouch = true
	print("yes touch")
	wait(0.2)
	print("no touch")
	melee.MeleeHitbox.CanTouch = false
end

melee.FireRE.OnServerEvent:Connect(
	function(a, b, c)
		player = a
		damage = b
		fireSpeed = c
		character = workspace:WaitForChild(player.Name)
		print("clicked")
		activateHitbox(player, damage, fireSpeed)
	end)