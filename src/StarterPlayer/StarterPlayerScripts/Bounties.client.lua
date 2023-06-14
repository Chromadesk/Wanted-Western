--Clones the character as a dummy and places them into the bounty GUI viewport
--Sends player to WantedPlayerControl to see if they are applicable to be Wanted

local player = game:GetService("Players").LocalPlayer
local tweenService = game:GetService("TweenService")

local playerGUI = nil
local bountyGUI = nil
local frame = nil
local viewport = nil

local guiActive = false
local bountyDummy = nil

local minBountyKillstreak = 3 --THE MINIMUM KILLSTREAK FOR A PLAYER TO BE APPLICABLE FOR THE WANTED POSTER

function showGUI()
	if not bountyGUI.Enabled then
		bountyGUI.Enabled = true
		local tweenInfo = TweenInfo.new(3,Enum.EasingStyle.Linear,Enum.EasingDirection.In,0,false,0)
		local tweenGoal = {Position = UDim2.new(0, 0, 1, 0)}
		local tween = tweenService:Create(frame, tweenInfo, tweenGoal)
		tween:Play()
		local i = 3
		if math.random(1, 100) > 3 then
			script.BountyAdd2:Play()
			script.BountyAdd2.Ended:Wait()
			repeat
				script.BountyAdd1:Play()
				i -= 1
				wait(0.7)
			until i == 0
		else
			script.BountySwagged:Play()
		end
	end
end

function hideGUI()
	if bountyGUI.Enabled then
		local tweenInfo = TweenInfo.new(3,Enum.EasingStyle.Linear,Enum.EasingDirection.In,0,false,0)
		local tweenGoal = {Position = UDim2.new(0, 0, 2, 0)}
		local tween = tweenService:Create(frame, tweenInfo, tweenGoal)
		tween:Play()
		script.BountyRemoved:Play()
		guiActive = false
		tween.Completed:Connect(function() bountyGUI.Enabled = false end)
	end
end

function placePlayerinGUI(wantedCharacter, bounty)
	frame:WaitForChild("PlayerName").Text = wantedCharacter.Name
	frame:WaitForChild("PlayerBounty").Text = "$" ..bounty .." BOUNTY"
	
	local viewportCamera = Instance.new("Camera")
	viewportCamera.Name = "ViewportCamera"
	viewport.CurrentCamera = viewportCamera
	viewportCamera.Parent = workspace

	wantedCharacter.Archivable = true
	if bountyDummy then bountyDummy:Destroy() end
	bountyDummy = wantedCharacter:Clone()
	repeat wait() until bountyDummy

	for _,v in pairs(bountyDummy:GetChildren()) do -- SKIN HIM!!!!, finds scripts and guns and removes them
		if v:IsA("Accessory") then
			if v:FindFirstChild("GunScript") or v:FindFirstChild("MeleeScript") then
				v:Destroy()
			end
		end
		if v:IsA("Script") then v:Destroy() end
	end

	bountyDummy.Name = bountyDummy.Name .. "Dummy"
	bountyDummy.Parent = workspace
	bountyDummy.HumanoidRootPart.CFrame = CFrame.new(0,0,0)
	bountyDummy.Parent = viewport

	viewportCamera.CFrame = CFrame.new(Vector3.new(0, bountyDummy.Head.Position.Y, -2), bountyDummy.Head.Position)
end

function manageKillstreak(character)
	local killStreakObj = character:WaitForChild("Data").Killstreak
	killStreakObj.Changed:Connect(function()
		if killStreakObj.Value >= minBountyKillstreak then
			game.ReplicatedStorage.WantedRE:FireServer(character)
		end
		if killStreakObj.Value > player.PlayerScripts.PlayerData.WantedCount.Value then
			player.PlayerScripts.PlayerData.WantedCount.Value = killStreakObj.Value
		end
	end)
end

game.ReplicatedStorage.WantedRE.OnClientEvent:Connect(function(wantedCharacter, bounty)
	if wantedCharacter then
		placePlayerinGUI(wantedCharacter, bounty)
		showGUI()
		if wantedCharacter.Name == player.Name then --This way WantedRE doesn't get 1000000 messages saying "YO THE WANTED PLAYER DIED!!!"
			wantedCharacter.Humanoid.Died:Wait()
			game.ReplicatedStorage.WantedRE:FireServer(nil)
		end
	else
		hideGUI()
	end
end)

player.CharacterAdded:Connect(function(character)
	playerGUI = player:WaitForChild("PlayerGui")
	bountyGUI = playerGUI:WaitForChild("BountyGui")
	frame = bountyGUI:WaitForChild("Frame")
	viewport = frame:WaitForChild("PlayerCam")
	manageKillstreak(character)
end)