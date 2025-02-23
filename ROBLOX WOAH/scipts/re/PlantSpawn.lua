local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")

local Libraries = RS:WaitForChild("Libraries")
local ServerLibraries = SSS:WaitForChild("Libraries")

local Config = require(Libraries:WaitForChild("Config"))

local InfNum = require(Libraries:WaitForChild("InfiniteMath"))

local function infnum(n)
	return InfNum.new(n)
end

local DataManager = require(ServerLibraries:WaitForChild("DataManager"))

local duck = RS:WaitForChild("Duck")
local superDuck = RS:WaitForChild("SuperDuck")
local superRareDuck = RS:WaitForChild("SuperRareDuck")

local spots = workspace:WaitForChild("Island Two"):WaitForChild("FarmSpots")
local plantsContainer = workspace:WaitForChild("Plants")

local function randomSpot(spots)
	
	local children = spots:GetChildren()
	local len = #children
	
	local function fetch()
		return children[math.random(1, len)]
	end
	
	local chosen = fetch()
	while chosen:FindFirstChildOfClass("BillboardGui") do
		chosen = fetch()
	end
	return chosen
	
end

local function randomPlant()
	local ranNumber = math.random(1, Config.PlantChanceSum)
	local Weight = 0
	for Plant, Chance in pairs(Config.PlantChanceTable) do
		Weight += (Chance * 100)
		
		if Weight >= ranNumber then
			return Plant
		end
	end
end

local idx = 0
local plants = {}

local function spawnPlant(plr)
	
	--local pos = randomPos(a, b)
	
	--local isSuperDuck = math.random(1,100) == 1 -- 1/100 chance of super duck (10x profit duck)
	--local profitMul = nil
	
	--local v = nil
	
	--if not isSuperDuck then
	--	v = duck:Clone()
	--	v.Parent = ducks
	--	v.Position = pos
	--	profitMul = 1
	--else
	--	v = superDuck:Clone()
	--	v.Parent = ducks
	--	v.Position = pos
	--	profitMul = 10
	--end
	
	
	--local connection
	--connection = v.Touched:Connect(function(hit)
	--  local plr = game:GetService("Players"):GetPlayerFromCharacter(hit.Parent) 
	--	if plr then
	--		local data = DataManager.GetData(plr)
	--		data.Ducks += data.DuckMaxProfits * data.DuckMaxProfitMultiplier1 * profitMul
	--		v:Destroy()
	--		connection:Disconnect()
	--	end
	--end)
	plants[plr] = plants[plr] or {}
	
	local len = 0
	for i, v in pairs(plants[plr]) do
		if v == nil then
			continue
		end
		len += 1
	end
	
	local data = DataManager.GetData(plr)
	
	if infnum(len) < data.MaximumDucks then
		local idx = (#plants[plr]) + 1
		local plantType = randomPlant()
		plants[plr][idx] = plantType
		RS:WaitForChild("Remotes"):WaitForChild("ReplicateDuck"):FireClient(plr, a, b, idx, plantType)
		return true
	else
		return false
	end
	
end

RS:WaitForChild("Remotes").CollectPlant.OnServerEvent:Connect(function(plr, idx)
	if not plants[plr][idx] then
		return
	end
	local profitMul = 1
	if plants[plr][idx] == 2 then
		profitMul = 10
	elseif plants[plr][idx] == 3 then
		profitMul = 1000
	end
	--profitMul *= 1000000000
	local data = DataManager.GetData(plr)
	data.Ducks += data.DuckMaxProfits * data.DuckMaxProfitMultiplier1 * data.PermDuckProfitMultiplier1 * profitMul
	plants[plr][idx] = nil
end)

RS:WaitForChild("Remotes").ServerClearPlants.Event:Connect(function(plr)
	for i, v in pairs(plants[plr]) do
		plants[plr][i] = nil
	end
end)


local timesSinceLastSpawn = {}

game:GetService("RunService").Heartbeat:Connect(function(delta)
	
	for i, v in pairs(game:GetService("Players"):GetPlayers()) do
		
		--print(v.Name)
		
		--for i, v in pairs(DataManager.Data) do
			--print(i, v)
		--end
		
		local data = DataManager.GetData(v)
		
		if not timesSinceLastSpawn[v] then
			timesSinceLastSpawn[v] = 0
		end
		
		timesSinceLastSpawn[v] += delta
		if (infnum(timesSinceLastSpawn[v]) > data.DuckSpawnRate) then
			--print("spawning duck")
			if spawnPlant(v) then
				timesSinceLastSpawn[v] = 0
			end
		end
		
	end
		
end)

--script.Parent.MouseClick:Connect(function()
	--for i = 1, 10 do
		--spawnDuck(boundA.Position, boundB.Position)
		--task.wait()
	--end
--end)



