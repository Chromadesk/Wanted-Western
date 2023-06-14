script.Parent.Touched:Connect(function(a)
	if a.Name == "Bullet" or a.Name == "MeleeHitbox" then script.Parent:Destroy() end
end)