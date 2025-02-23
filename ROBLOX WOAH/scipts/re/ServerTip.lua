local RS = game:GetService("ReplicatedStorage")
local Remotes = RS:WaitForChild("Remotes")

local TipInvertal = 120
local Tips = {
	"You earn 1 Ducktonium for every 10 times you level up.",
	"Use code CODESAREHERE2025",
	"The profits upgrades never max.",
	"Join the group to know about updates ahead of time so you are up to date on the latest information.",
	"You can purchase various essential upgrades in the <b>Egg Shop</b> if you rebirth",
	"Ducktonium is used on the purple island.",
	"You earn XP from collecting ducks and rebirthing",
	"You can buy a machine that collects ducks for you if you get the card for it.",
	"Collect ducks...? I'm running out of ideas.",
	"Does anyone really read these?",
	"MrDucks2279 and Irludure are the only real owners...",
	"You should totally donate!! (Please we need this)"
}

while task.wait(TipInvertal) do
	Remotes.BroadcastTip:FireAllClients(Tips[math.random(1, #Tips)])
	task.wait(TipInvertal)
end
