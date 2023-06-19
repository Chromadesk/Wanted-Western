local piano = script.Parent
local song = piano:WaitForChild("MusicPlayer"):WaitForChild("Song")
local touchPart = piano:WaitForChild("TouchPart")

touchPart.Touched:Connect(function(a)
	if not song.IsPlaying then
		if a and a.Parent and a.Parent:FindFirstChild("Humanoid") then
			song:Play()
		end
	end
end)