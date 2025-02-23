age = 7 --account age goes here
msg = "Your account needs to be "..age.." days or older to play."

game.Players.PlayerAdded:connect(function(plr)
	if plr.AccountAge <= age then
		plr:Kick(msg)
		else
	end
end)