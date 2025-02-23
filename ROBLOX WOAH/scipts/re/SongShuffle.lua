local RS = game:GetService("ReplicatedStorage")
local Music = RS:WaitForChild("BgMusic")

while true do
	local MusicChildren = Music:GetChildren()
	local Song = MusicChildren[math.random(1, #MusicChildren)]
	
	Song:Play()
	Song.Ended:Wait()
end
