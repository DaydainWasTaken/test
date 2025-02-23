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

--local duck = RS:WaitForChild("Duck")
--local superDuck = RS:WaitForChild("SuperDuck")
--local superRareDuck = RS:WaitForChild("SuperRareDuck")

local bounds = workspace:WaitForChild("DuckSpawn1Bounds")
local ducks = workspace:WaitForChild("Ducks")

local boundA = bounds["1"]
local boundB = bounds["2"]

local function randomPos(_a: Vector3, _b: Vector3)
	local a = Vector3.min(_a, _b)
	local b = Vector3.max(_a, _b)
	return Vector3.new(
		math.random(a.X, b.X),
		math.random(a.Y, b.Y),
		math.random(a.Z, b.Z)
	)
end

local idx = 0
local ducks = {}

local function spawnDuck(plr, a, b)
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
	ducks[plr] = ducks[plr] or {}
	
	local len = 0
	for i, v in pairs(ducks[plr]) do
		if v == nil then
			continue
		end
		len += 1
	end
	
	local data = DataManager.GetData(plr)
	
	if infnum(len) < data.MaximumDucks then
		local idx = (#ducks[plr]) + 1
		local uglyDucklingMult = data.UglyDuckling_Mult
		--print(uglyDucklingMult)
		local isSuperRareDuck =	infnum(math.random(1, 10000)) < uglyDucklingMult
		--print(isSuperRareDuck)
		local isSuperDuck = InfNum.new(math.random(1,100)) <= data.PermSuperDuckChance -- 1/100 chance of super duck (10x profit duck)
		local duckType = ((isSuperRareDuck and 3) or (isSuperDuck and 2)) or 1
		ducks[plr][idx] = duckType
		RS:WaitForChild("Remotes"):WaitForChild("ReplicateDuck"):FireClient(plr, a, b, idx, duckType)
		return true
	else
		return false
	end
end

RS:WaitForChild("Remotes").CollectDuck.OnServerEvent:Connect(function(plr, idx)
	if not ducks[plr][idx] then
		return
	end
	local profitMul = 1
	if ducks[plr][idx] == 2 then
		profitMul = 10
	elseif ducks[plr][idx] == 3 then
		profitMul = 1000
	end
	--profitMul *= 1000000000
	local data = DataManager.GetData(plr)
	--print(data.ExtraDuckMult2)
	data.Ducks += (Config.GetProfitPerDuck(data) * profitMul * data.ExtraDuckMult2 * data.DuckMania_Mult)
	ducks[plr][idx] = nil
	data.Exp += InfNum.new(1) * data.XpSurge_Mult
	RS:WaitForChild("Remotes").UpdateLevel:Fire(plr)
end)

RS:WaitForChild("Remotes").ServerClearDucks.Event:Connect(function(plr)
	for i, v in pairs(ducks[plr]) do
		ducks[plr][i] = nil
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
		
		if not data then
			continue
		end
		
		timesSinceLastSpawn[v] += delta
		if (infnum(timesSinceLastSpawn[v]) > data.DuckSpawnRate) then
			--print("spawning duck")
			if spawnDuck(v, boundA.Position, boundB.Position) then
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



