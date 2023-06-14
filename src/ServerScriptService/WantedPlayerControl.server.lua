local wantedRemote = game.ReplicatedStorage.WantedRE
local wantedCharacter = nil
local bounty = 100

wantedRemote.OnServerEvent:Connect(function(player, character)
	if character then
		if wantedCharacter and character.Name == wantedCharacter.Name then --If the received player is already wanted, increase bounty
			bounty = math.round(bounty * 1.25)
			wantedCharacter.Data.CurrentBounty.Value = bounty
		else
			if workspace:FindFirstChild(character.Name) then
				if wantedCharacter and workspace:FindFirstChild(character.Name).Data.Killstreak
					< wantedCharacter.Data.Killstreak then return end
				
				wantedCharacter = workspace:FindFirstChild(character.Name)
				wantedCharacter.Data.IsWanted.Value = true
				wantedCharacter.Data.CurrentBounty.Value = bounty
			else -- If the recieved player was not found, assume it means the wanted player died and clear their status.
				wantedCharacter = nil
				bounty = 100
			end
		end
	else -- If the recieved player was not found, assume it means the wanted player died and clear their status.
		wantedCharacter.Data.CurrentBounty.Value = 0
		wantedCharacter = nil
		bounty = 100
	end
	wantedRemote:FireAllClients(wantedCharacter, bounty)
end)