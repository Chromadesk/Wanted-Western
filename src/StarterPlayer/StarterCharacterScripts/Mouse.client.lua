--Make player look at mouse
--Replace mouse cursor

local Run = game:GetService("RunService")
local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local Mouse = Player:GetMouse()
Mouse.Icon = script:WaitForChild("Cursor").Texture

Run.RenderStepped:Connect(function()
	HRP.CFrame = CFrame.lookAt(HRP.CFrame.Position, Vector3.new(Mouse.Hit.Position.X, HRP.CFrame.Position.Y, Mouse.Hit.Position.Z))
end)