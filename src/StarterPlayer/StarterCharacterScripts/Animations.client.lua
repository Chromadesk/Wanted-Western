--Set, Load, and Play idle and move animations
--Disables player from climbing

local moveAnimation = script:WaitForChild("Move")
local idleAnimation = script:WaitForChild("Idle")

local Char = script.Parent
local Humanoid = Char:WaitForChild("Humanoid")

local moveTrack = Humanoid:LoadAnimation(moveAnimation)
local idleTrack = Humanoid:LoadAnimation(idleAnimation)

moveAnimation.Changed:Connect(function() moveTrack = Humanoid:LoadAnimation(moveAnimation) end)
idleAnimation.Changed:Connect(function() idleTrack = Humanoid:LoadAnimation(idleAnimation) end)

Humanoid.Running:Connect(function(movementSpeed)
	if movementSpeed > 0 then
		if not moveTrack.IsPlaying then
			idleTrack:Stop()
			moveTrack:Play()
		end
	else
		if moveTrack.IsPlaying then
			moveTrack:Stop()
			idleTrack:Play()
		end
	end
end)

Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)