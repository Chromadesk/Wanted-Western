local melee = script.Parent
local UserInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local meleeStats = melee:WaitForChild("Stats")

local regDamage = meleeStats.Damage.Value
local regFireSpeed = meleeStats.Firespeed.Value

local damage = regDamage
local firespeed = regFireSpeed

local pauseFireInput = false

while not melee.Parent:FindFirstChild("HumanoidRootPart") do
	melee.AncestryChanged:Wait()
end

local character = melee.Parent
local player = game.Players:GetPlayerFromCharacter(character)

melee.HitRE.OnClientEvent:Connect( --When the melee gets a hit
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

local idleAnimation = script:WaitForChild("Idle")
local moveAnimation = script:WaitForChild("Move")
local attackAnimation = script:WaitForChild("Attack")

character:WaitForChild("Animations").Idle.AnimationId = idleAnimation.AnimationId
character:WaitForChild("Animations").Move.AnimationId = moveAnimation.AnimationId
local attackTrack = character.Humanoid:LoadAnimation(attackAnimation) -- 1 second

local function fireMelee()
	print("fireMelee()")
	melee.FireRE:FireServer(damage, firespeed)
	attackTrack:Play(nil,nil,1 / firespeed)
	wait(firespeed)
	pauseFireInput = false
end

local gameOver = false
local function processInput(input, eventProcessed)

	if gameOver or eventProcessed or pauseFireInput or character.Humanoid.Health <= 0 then return end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		pauseFireInput = true
		fireMelee()
	end
end

UserInputService.InputBegan:Connect(processInput)

game:GetService("ReplicatedStorage").PlayerDataRequestRE.OnClientEvent:Connect(function()
	gameOver = true
end)