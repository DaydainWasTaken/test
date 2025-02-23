local SSS = game:GetService("ServerScriptService")
local RS = game:GetService("ReplicatedStorage")
local Libraries = SSS:WaitForChild("Libraries")
local RSLibraries = RS:WaitForChild("Libraries")

local DataManager = require(Libraries:WaitForChild("DataManager"))
local InfNum = require(RSLibraries:WaitForChild("InfiniteMath"))

local candycanes = workspace:WaitForChild("Candycanes")

for i = 1, 8 do
	local candycane = candycanes:WaitForChild(tostring(i))
	candycane:WaitForChild("ClickDetector").MouseClick:Connect(function(plr)
		local data = DataManager.Data[plr]
		while not data do
			data = DataManager.Data[plr]
			task.wait()
		end
		data.Winter2024_Candycanes += InfNum.new("1")
		table.insert(data.Winter2024_CandycanesCollected, candycane.Name)
		--candycane:Destroy()
	end)
end
