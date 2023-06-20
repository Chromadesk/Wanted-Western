--Reload gun
--Play gun sounds & hitsound
--Collect player m1 and R inputs
--Load AmmoGUI onto player
--Control AmmoGUI (animation, removing and adding bullets)

local gun = script.Parent
local UserInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local gunStats = gun:WaitForChild("Stats")

local regDamage = gunStats.Damage.Value
local regAmmo = gunStats.Ammo.Value
local regFireSpeed = gunStats.Firespeed.Value
local regReloadTime = gunStats.ReloadTime.Value -- In seconds. If speedloader is off, will automatically divide the time.
local projectileSpeed = gunStats.ProjectileSpeed.Value -- How many seconds it takes to travel 100 blocks
local speedLoader = gunStats.SpeedLoader.Value

local damage = regDamage
local ammo = regAmmo
local firespeed = regFireSpeed
local reloadTime = regReloadTime

local pauseFireInput = false

while not gun.Parent:FindFirstChild("HumanoidRootPart") do
	gun.AncestryChanged:Wait()
end

local character = gun.Parent
local player = game.Players:GetPlayerFromCharacter(character)

gun.HitRE.OnClientEvent:Connect( --When the gun gets a hit
	function(hitPlayer, damageDealt)
		character.Sounds.Hitsound:Play()
		
		local damageNumberGUI = Instance.new("BillboardGui")
		damageNumberGUI.ExtentsOffsetWorldSpace = Vector3.new(math.random(-1, 1), -2, math.random(-1, 1))
		damageNumberGUI.AlwaysOnTop = true
		damageNumberGUI.Size = UDim2.new(0, 200, 0, 50)
		
		local damageNumber = Instance.new("TextLabel")
		damageNumber.Name = "DamageNumber"
		damageNumber.BackgroundTransparency = 1
		damageNumber.FontFace.Weight = Enum.FontWeight.Bold
		damageNumber.Text = tostring(damageDealt)
		damageNumber.TextSize = math.random(10, 15)
		damageNumber.Size = UDim2.new(0, 200, 0, 50)
		damageNumber.Font = Enum.Font.Merriweather
		
		if damageDealt == 0 then damageNumber.TextColor3 = Color3.fromRGB(255, 255, 255) end
		if damageDealt >= 1 then damageNumber.TextColor3 = Color3.fromRGB(0, 255, 0) end
		
		damageNumber.Parent = damageNumberGUI
		damageNumberGUI.Parent = hitPlayer.Head
		
		wait(1)
		damageNumberGUI:Destroy()
	end
)

local reloadAnimation = script:WaitForChild("Reload")
local reloadLoopAnimation = script:WaitForChild("Reload Loop")
local reloadExitAnimation = script:WaitForChild("Reload Exit")
local reloadTrack1 = character.Humanoid:LoadAnimation(reloadAnimation) -- 1 second
local reloadTrack2 = character.Humanoid:LoadAnimation(reloadLoopAnimation) -- 0.1 seconds
local reloadTrack3 = character.Humanoid:LoadAnimation(reloadExitAnimation) -- 0.1 seconds

local playerGUI = player:WaitForChild("PlayerGui")
if playerGUI:FindFirstChild("AmmoGUI") then
	playerGUI:FindFirstChild("AmmoGUI"):Destroy()
end
gun.AmmoGUI.Parent = playerGUI
local GUIAmmo = playerGUI:WaitForChild("AmmoGUI")
local GUIFrame = GUIAmmo:WaitForChild("Frame")
local GUICylinder = GUIFrame:WaitForChild("Cylinder")
local GUIBullets = {
	GUIFrame:WaitForChild("Bullet 1"),
	GUIFrame:WaitForChild("Bullet 2"),
	GUIFrame:WaitForChild("Bullet 3"),
	GUIFrame:WaitForChild("Bullet 4"),
	GUIFrame:WaitForChild("Bullet 5"),
	GUIFrame:WaitForChild("Bullet 6"),
}

local function addAmmo(count, speed)
	--THIS IS ADD AMMO!!
	ammo += count
	local tweenInfo = TweenInfo.new(firespeed,Enum.EasingStyle.Linear,Enum.EasingDirection.In,0,false,0)
	local tweenGoal = {Rotation = GUIFrame.Rotation + 60}
	local tween = tweenService:Create(GUIFrame, tweenInfo, tweenGoal)
	local i = regAmmo
	while count > 0 do
		if not GUIBullets[i].Visible then
			GUIBullets[i].Visible = true
			count -= 1
			if (speed > 0) then tween:Play() end
			return
		else i -= 1 end
	end
end

local function spendAmmo(count)
	--This is Spend Ammo !!
	ammo -= count
	local tweenInfo = TweenInfo.new(firespeed,Enum.EasingStyle.Linear,Enum.EasingDirection.In,0,false,0)
	local tweenGoal = {Rotation = GUIFrame.Rotation - 60}
	local tween = tweenService:Create(GUIFrame, tweenInfo, tweenGoal)
	local i = 1
	while count > 0 do
		if GUIBullets[i].Visible then
			GUIBullets[i].Visible = false
			count -= 1
			tween:Play()
			return
		else i += 1 end
	end
end

local function fireGun()
	if ammo > 0 then
		gun.FireRE:FireServer(damage,projectileSpeed)
		spendAmmo(1)
	else
		gun.Emptysound:Play()
	end
	wait(firespeed)
	pauseFireInput = false
end

local function reload()
	if ammo == regAmmo then pauseFireInput = false return end
	if speedLoader then
		gun.Reloadsound1:Play()
		reloadTrack1:Play(nil,nil,1 / reloadTime)
		addAmmo(regAmmo, -1)
		wait(reloadTime)
		reloadTrack1:Stop()
	else
		gun.Reloadsound1:Play()
		reloadTrack1:Play()
		gun.Reloadsound2:Play()
		wait(1)
		while ammo ~= regAmmo do
			reloadTrack2:Play(nil,nil,0.1 / (reloadTime / regAmmo))
			gun.Reloadsound2:Play()
			addAmmo(1, (reloadTime / regAmmo))
			wait(reloadTime / regAmmo)
		end
		gun.Reloadsound2:Stop()
		gun.Reloadsound1:Play()
		reloadTrack2:Stop()
	end
	reloadTrack3:Play()
	pauseFireInput = false
end

local gameOver = false
local function processInput(input, eventProcessed)
	
	if gameOver or eventProcessed or pauseFireInput or character.Humanoid.Health <= 0 then return end
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		pauseFireInput = true
		fireGun()
	end
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode.Name == "R" then
			pauseFireInput = true
			reload()
		end
	end
end

UserInputService.InputBegan:Connect(processInput)

game:GetService("ReplicatedStorage").PlayerDataRequestRE.OnClientEvent:Connect(function()
	gameOver = true
end)