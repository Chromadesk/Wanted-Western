--Make camera top-down and follow player
--Follow killer on death. If killer dies, follow their killer, etc.
--If player is a spectator makes camera focus on map object CameraFocus

local player = game:GetService("Players").LocalPlayer
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local character = script.Parent

local target = workspace:WaitForChild("Map"):WaitForChild("CameraFocus")

function watchKillerOrMap()
	if character and character:FindFirstChild("Data") and character.Data:FindFirstChild("LastAttacker") and workspace:FindFirstChild(character.Data.LastAttacker.Value) then
		target = workspace:FindFirstChild(character.Data.LastAttacker.Value):FindFirstChild("HumanoidRootPart")
	else
		target = workspace:WaitForChild("Map"):WaitForChild("CameraFocus")
	end
end

player.Changed:Connect(function()
	if player.Team == game:GetService("Teams").Playing then
		target = character:WaitForChild("HumanoidRootPart")
		character:WaitForChild("Humanoid").Died:Connect(watchKillerOrMap)
	else
		watchKillerOrMap()
	end
end)

camera.CameraSubject = target
camera.CameraType = Enum.CameraType.Scriptable

runService.RenderStepped:Connect(function()
	if not target then return end
	camera.CFrame = CFrame.new(target.Position) * CFrame.new(Vector3.new(0, 30, 0), Vector3.new(0.1, 0, 0))
end)