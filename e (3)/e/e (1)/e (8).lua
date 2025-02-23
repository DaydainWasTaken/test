local MPS = game:GetService("MarketplaceService")
local BadgeService = game:GetService("BadgeService")

local RS = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")

local Libraries = RS:WaitForChild("Libraries")
local ServerLibraries = SSS:WaitForChild("Libraries")

local InfNum = require(Libraries:WaitForChild("InfiniteMath"))

local DataManager = require(ServerLibraries:WaitForChild("DataManager"))
local Config = require(Libraries:WaitForChild("Config"))
local CardConfig = require(Libraries:WaitForChild("Cards"))
local AscensionUpgradeConfig = require(Libraries:WaitForChild("AscensionConfig"))

local Remotes = RS:WaitForChild("Remotes")

local TENTH = InfNum.new("0.1")
local ONE = InfNum.new("1")
local TWO = InfNum.new("2")




function findClosestIndex(t, x)
	local closestIndex = nil
	local closestDiff = 1000000000000

	for i, value in ipairs(t) do
		local diff = InfNum.abs(value - x)

		if diff < InfNum.new(closestDiff) then
			closestDiff = diff
			closestIndex = i
		end
	end

	return closestIndex
end

local function UpdateLevel(plr: Player)
	
	local data = DataManager.GetData(plr)
	
	if data.Exp >= data.ExpToFinish then
		data.Exp -= data.ExpToFinish
		data.Level += ONE
		--if data.Level % InfNum.new(10) == InfNum.new(0) then
		data.Ducktonium += InfNum.new(0.1) * data.Dectonium_Mult
		--end
		data.ExpToFinish *= InfNum.new(1.5)
		UpdateLevel(plr)
	end
	
end

local function UpgradeMaximumDuckProfits(plr)
	
	local data = DataManager.GetData(plr)
	--print("Data as table is below, dropdownable")
	--print(data)
	
	local price = data.DuckProfit1Cost * (ONE - data.PermGlobalSavings)

	if data.Ducks >= price then
		
		local minMult = InfNum.new("1.00001")
		local costmult = data.DuckProfit1CostMultiplierMultiplier -- (ONE + ((data.DuckProfit1CostMultiplierMultiplier - ONE) * (ONE - data.PermDuckProfitSavingsAmount)))
		if costmult < minMult then
			costmult = minMult
		end
		local costmultmult = InfNum.new(1.0015) -- (ONE + ((InfNum.new(1.0015) - ONE) * (ONE - data.PermDuckProfitSavingsAmount)))
		if costmultmult < minMult then
			costmultmult = minMult
		end
		--print(`Cost Multiplier: {costmult}`)
		--print(`Cost Multiplier Multiplier: {costmultmult}`)
		
		data.Ducks -= price
		data.DuckMaxProfits *= 2 -- data.PermDuckProfit1Effectiveness
		data.DuckProfit1Cost *= data.DuckProfit1CostMultiplier
		data.DuckProfit1Cost = InfNum.floor(data.DuckProfit1Cost)
		data.DuckProfit1CostMultiplier *= costmult
		data.DuckProfit1CostMultiplierMultiplier *= costmultmult
		return true
	end
	
	return false
	
end

local function UpgradeMaximumDuckProfitsMax(plr)
	local data = DataManager.GetData(plr)

	local price = function()
		return data.DuckProfit1Cost * (ONE - data.PermGlobalSavings)
	end
	
	local p = price()
	
	while true do
		local b = false
		for i = 1, 2500 do
			if not UpgradeMaximumDuckProfits() then
				b = true
			end
		end
		if b then
			break
		end
		task.wait()
	end

	return false
end


local function UpgradeMaximumDucks(plr)
	
	local data = DataManager.GetData(plr)

	local idx = findClosestIndex(Config.MaximumDuckLevels, data.MaximumDucks) + 1
	local newMaximumDucks = Config.MaximumDuckLevels[idx]

	if newMaximumDucks then
		local cost = data.DuckMax1Cost * (ONE - data.PermGlobalSavings)
		if data.Ducks >= cost then
			data.Ducks -= cost
			data.DuckMax1Cost *= 5
			data.DuckMax1Cost = InfNum.floor(data.DuckMax1Cost)
		else
			return false
		end
		data.MaximumDucks = InfNum.new(newMaximumDucks)
		return true
	else
		return false
	end
	
end

local function UpgradeDuckSpawnrate(plr)
	
	local data = DataManager.GetData(plr)

	local idx = findClosestIndex(Config.SpawnrateDucksLevels, data.DuckSpawnRate) + 1
	local newSpawnrate = Config.SpawnrateDucksLevels[idx]

	if newSpawnrate then
		local cost = data.DuckSpawnrate1Cost * (ONE - data.PermGlobalSavings)
		if data.Ducks >= cost then
			data.Ducks -= cost
			data.DuckSpawnrate1Cost *= 4.015
			data.DuckSpawnrate1Cost = InfNum.floor(data.DuckSpawnrate1Cost)
		else
			return false
		end
		data.DuckSpawnRate = InfNum.new(newSpawnrate)
		return true
	else
		return false
	end
	
end

local function UpgradePermMaximumDuckProfits(plr)
	
	local data = DataManager.GetData(plr)
	
	local price = ((ONE - data.PermEggSavings) * data.PermDuckProfitMultiplier1Cost) * data.FrugalFledgling_Mult
	
	if data.Eggs >= price then
		data.Eggs -= price
		data.PermDuckProfitMultiplier1Cost *= 3
		data.PermDuckProfitMultiplier1Cost = InfNum.floor(data.PermDuckProfitMultiplier1Cost)
		data.PermDuckProfitMultiplier1 *= 2
		data.PermDuckProfitMultiplier1Level += ONE
		return true
	else
		return false
	end
	
end

local function UpgradePermMaximumDuckProfitsMax(plr)
	local data = DataManager.GetData(plr)

	local price = (ONE - data.PermEggSavings) * data.PermDuckProfitMultiplier1Cost * data.FrugalFledgling_Mult

	if data.Eggs >= price then
		local totalUpgrades = InfNum.floor(InfNum.log(data.Eggs / price) / InfNum.log(3))

		local totalCost = price * (3^totalUpgrades - 1) / 2

		if data.Eggs >= totalCost then
			data.Eggs -= totalCost

			data.PermDuckProfitMultiplier1 *= 2^totalUpgrades
			data.PermDuckProfitMultiplier1Cost *= 3^totalUpgrades
			data.PermDuckProfitMultiplier1Cost = InfNum.floor(data.PermDuckProfitMultiplier1Cost)
			data.PermDuckProfitMultiplier1Level += totalUpgrades
			
			if data.Eggs >= ((ONE - data.PermEggSavings) * data.PermDuckProfitMultiplier1Cost) then
				task.wait()
				UpgradePermMaximumDuckProfits(plr)
				UpgradePermMaximumDuckProfitsMax(plr)
			end

			return true
		end
	end

	-- Return false if not enough eggs or no valid upgrade path
	return false
end


local function UpgradePermGlobalSavings(plr)
	
	local data = DataManager.GetData(plr)
	
	if data.PermGlobalSavings >= InfNum.new(0.85) then
		return false
	end
	
	local price = ((ONE - data.PermEggSavings) * data.PermGlobalSavingsCost) * data.FrugalFledgling_Mult
	
	if data.Eggs >= price then
		data.Eggs -= price
		data.PermGlobalSavingsCost *= 3.5
		data.PermGlobalSavingsCost = InfNum.floor(data.PermGlobalSavingsCost)
		data.PermGlobalSavings += InfNum.new(0.05)
		return true
	else
		return false
	end
	
end

local function UpgradePermRarity(plr)
	
	local data = DataManager.GetData(plr)
	
	if data.PermSuperDuckChance >= InfNum.new(10) then
		return false
	end
	
	local price = ((ONE - data.PermEggSavings) * data.PermSuperDuckChanceCost) * data.FrugalFledgling_Mult
	
	if data.Eggs >= price then
		data.Eggs -= price
		data.PermSuperDuckChanceCost += 1
		data.PermSuperDuckChance += 1
		return true
	end
	
end

local function UpgradePermHitboxSize(plr)
	
	local data = DataManager.GetData(plr)
	
	if data.PermHitboxBought >= InfNum.new("3") then
		return false
	end
	
	local price = ((ONE - data.PermEggSavings) * data.PermHitboxSizeCost) * data.FrugalFledgling_Mult
	
	if data.Eggs >= price then
		data.Eggs -= price
		data.PermHitboxSize += 0.5
		data.PermHitboxSizeCost *= 2.5
		data.PermHitboxBought += InfNum.new("1")
		return true
	else
		return false
	end
	
end

local function UpgradeEggProfit2(plr)
	
	local data = DataManager.GetData(plr)
	local price = data.PermEggProfitMultiplier2Cost
	
	if data.Feathers >= price then
		data.Feathers -= price
		data.PermEggProfitMultiplier2 *= 2
		data.PermEggProfitMultiplier2Cost *= 2.25
		return true
	else
		return false
	end
	
end

local function UpgradeEggProfit2Max(plr)
	local data = DataManager.GetData(plr)

	local price = data.PermEggProfitMultiplier2Cost

	if data.Feathers >= price then
		local totalUpgrades = InfNum.floor(InfNum.log(data.Feathers / price) / InfNum.log(2))

		local totalCost = price * (2^totalUpgrades - 1)

		if data.Feathers >= totalCost then
			data.Feathers -= totalCost

			data.PermEggProfitMultiplier2 *= 2^totalUpgrades
			data.PermEggProfitMultiplier2Cost *= 2^totalUpgrades
			data.PermEggProfitMultiplier2Cost = InfNum.floor(data.PermEggProfitMultiplier2Cost)
			
			if data.Feathers >= (data.PermEggProfitMultiplier2Cost) then
				task.wait()
				UpgradeEggProfit2(plr)
				UpgradeEggProfit2Max(plr)
			end

			return true
		end
	end

	return false
end


local function UpgradeEggSavings(plr)
	
	local data = DataManager.GetData(plr)
	local price = data.PermEggSavingsCost
	
	if data.PermEggSavings >= InfNum.new(0.85) then
		return false
	end
	
	if data.Feathers >= price then
		data.Feathers -= price
		data.PermEggSavings += InfNum.new(0.05)
		data.PermEggSavingsCost *= InfNum.new(4.0)
		return true
	else
		return false
	end
	
end

local function UpgradeHitboxSizeExtra(plr)
	
	local data = DataManager.GetData(plr)
	local price = data.PermHitboxSizeExtraCost
	
	if data.PermHitboxSizeExtra >= InfNum.new(1.5) then
		return false
	end
	
	if data.Feathers >= price then
		data.Feathers -= price
		data.PermHitboxSizeExtra += TENTH -- add 0.1 to data.PermHitboxSizeExtra
		data.PermHitboxSizeExtraCost *= InfNum.new(6.5) -- double data.PermHitboxSizeExtraCost
		return true
	else
		return false
	end
	
end

local function UpgradeWalkspeed(plr)
	
	local data = DataManager.GetData(plr)
	local price = data.Perm2SpeedCost
	
	if data.Perm2Speed >= InfNum.new(25) then
		return false
	end
	
	if data.Feathers >= price then
		data.Feathers -= price
		data.Perm2Speed += 1
		data.Perm2SpeedCost *= 1.75
		data.Perm2SpeedCost = InfNum.round(data.Perm2SpeedCost)
		return true
	else
		return false
	end
	
end

local function UpgradeMaximumFeatherProfits(plr)
	
	local data = DataManager.GetData(plr)
	local price = data.PermFeatherMultiplierCost
	
	if data.Puddles >= price then
		data.Puddles -= price
		data.PermFeatherMultiplier *= TWO
		data.PermFeatherMultiplierCost *= TWO
		return true
	else
		return false
	end
	
end

local function UpgradeMaximumFeatherProfitsMax(plr)
	local data = DataManager.GetData(plr)

	local price = data.PermFeatherMultiplierCost

	if data.Puddles >= price then
		local totalUpgrades = InfNum.floor(InfNum.log(data.Puddles / price) / InfNum.log(2))
		local totalCost = price * (2^totalUpgrades - 1)

		if data.Puddles >= totalCost then
			data.Puddles -= totalCost
			
			data.PermFeatherMultiplier *= 2^totalUpgrades
			data.PermFeatherMultiplierCost *= 2^totalUpgrades
			data.PermFeatherMultiplierCost = InfNum.floor(data.PermFeatherMultiplierCost)
			
			if data.Puddles >= (data.PermFeatherMultiplierCost) then
				task.wait()
				UpgradeMaximumFeatherProfits(plr)
				UpgradeMaximumFeatherProfitsMax(plr)
			end

			return true
		end
	end
	
	return false
end


local function UpgradePrestigeSavings(plr)
	
	print('upgrading prestige savings')
	
	local data = DataManager.GetData(plr)
	local price = data.PermPrestigeCostReductionCost
	
	if data.PermPrestigeCostReduction >= InfNum.new(0.851) then
		print(`reduction is larger than max: {data.PermPrestigeCostReduction}`)
		return false
	end
	
	if data.Puddles >= price then
		data.Puddles -= price
		data.PermPrestigeCostReduction += InfNum.new(0.05)
		data.PermPrestigeCostReductionCost *= InfNum.new(2.15)
		return true
	else
		return false
	end
	
end

local function UpgradeRebirthSavings(plr)
	
	print('upgrading rebirth savings')

	local data = DataManager.GetData(plr)
	local price = data.PermRebirthCostReductionCost
	
	print(tostring(data.PermRebirthCostReduction))
	print(tostring(data.PermPrestigeCostReduction))
	
	if data.PermRebirthCostReduction >= InfNum.new(0.85) then
		print('reduction is larger than max')
		return false
	end

	if data.Puddles >= price then
		data.Puddles -= price
		data.PermRebirthCostReduction += InfNum.new(0.05)
		data.PermRebirthCostReductionCost *= InfNum.new(2.05)
		return true
	else
		return false
	end

end

local function upgradeMax(func, ...)
	local args = {...}
	
	local a = table.unpack(args)
	
	while func(a) do
		for i = 1,500 do
			if not func(a) then
				break
			end
		end
		task.wait(0.08)
	end
end

local lastId = 0

local function lMaxRemote(remote: RemoteEvent, func: (any) -> (any))
	local id = lastId + 1
	local n = `maxDebounce_{id}`
	remote.OnServerEvent:Connect(function(plr)
		if plr:GetAttribute(n) then
			return
		end
		plr:SetAttribute(n, true)
		pcall(function()
			func(plr)
		end)
		plr:SetAttribute(n, false)
	end)
end

local function maxRemote(remote: RemoteEvent, func: (any) -> (any))
	local id = lastId + 1
	lastId = id
	local n = `maxDebounce_{id}`
	remote.OnServerEvent:Connect(function(plr)
		if plr:GetAttribute(n) then
			return
		end
		plr:SetAttribute(n, true)
		upgradeMax(func, plr)
		plr:SetAttribute(n, false)
	end)
end

Remotes.UpdateLevel.Event:Connect(UpdateLevel)

Remotes.UpgradeMaxDuckProfits.OnServerEvent:Connect(UpgradeMaximumDuckProfits)
Remotes.UpgradeDuckSpawnrate.OnServerEvent:Connect(UpgradeDuckSpawnrate)
Remotes.UpgradeMaximumDucks.OnServerEvent:Connect(UpgradeMaximumDucks)

Remotes.UpgradePermDuckProfits.OnServerEvent:Connect(UpgradePermMaximumDuckProfits)
Remotes.UpgradePermGlobalSavings.OnServerEvent:Connect(UpgradePermGlobalSavings)
Remotes.UpgradePermRarity.OnServerEvent:Connect(UpgradePermRarity)
Remotes.UpgradePermHitboxSize.OnServerEvent:Connect(UpgradePermHitboxSize)

Remotes.UpgradeEggProfits.OnServerEvent:Connect(UpgradeEggProfit2)
Remotes.UpgradeEggSavings.OnServerEvent:Connect(UpgradeEggSavings)
Remotes.UpgradeHitboxSizeExtra.OnServerEvent:Connect(UpgradeHitboxSizeExtra)
Remotes.UpgradePermSpeed.OnServerEvent:Connect(UpgradeWalkspeed)

Remotes.UpgradeMaximumFeatherProfits.OnServerEvent:Connect(UpgradeMaximumFeatherProfits)
Remotes.UpgradePrestigeSavings.OnServerEvent:Connect(UpgradePrestigeSavings)
Remotes.UpgradeRebirthSavings.OnServerEvent:Connect(UpgradeRebirthSavings)

maxRemote(Remotes.UpgradeMaxDuckProfitsMax, UpgradeMaximumDuckProfits)
maxRemote(Remotes.UpgradeDuckSpawnrateMax, UpgradeDuckSpawnrate)
maxRemote(Remotes.UpgradeMaximumDucksMax, UpgradeMaximumDucks)

maxRemote(Remotes.UpgradePermDuckProfitsMax, UpgradePermMaximumDuckProfits)
maxRemote(Remotes.UpgradePermGlobalSavingsMax, UpgradePermGlobalSavings)
maxRemote(Remotes.UpgradePermRarityMax, UpgradePermRarity)
maxRemote(Remotes.UpgradePermHitboxSizeMax, UpgradePermHitboxSize)

maxRemote(Remotes.UpgradeEggProfitsMax, UpgradeEggProfit2)
maxRemote(Remotes.UpgradeHitboxSizeExtraMax, UpgradeHitboxSizeExtra)
maxRemote(Remotes.UpgradePermSpeedMax, UpgradeWalkspeed)
maxRemote(Remotes.UpgradeEggSavingsMax, UpgradeEggSavings)

maxRemote(Remotes.UpgradeMaximumFeatherProfitsMax, UpgradeMaximumFeatherProfits)
maxRemote(Remotes.UpgradePrestigeSavingsMax, UpgradePrestigeSavings)
maxRemote(Remotes.UpgradeRebirthSavingsMax, UpgradeRebirthSavings)

local function Layer1Reset(data)
	local function reset(key)
		data[key] = Config.CompatTemplate[key]
	end
	reset("Ducks")
	reset("DuckMaxProfits")
	reset("DuckSpawnRate")
	reset("MaximumDucks")
	reset("DuckProfit1Cost")
	reset("DuckProfit1CostMultiplier")
	reset("DuckProfit1CostMultiplierMultiplier")
	reset("DuckMax1Cost")
	reset("DuckSpawnrate1Cost")
end

local function Layer2Reset(data)
	Layer1Reset(data)
	local function reset(key)
		data[key] = Config.CompatTemplate[key]
	end
	reset("Eggs")
	reset("EggMaxProfits")
	reset("DuckMaxProfitMultiplier1")
	reset("PermDuckProfitMultiplier1")
	reset("PermDuckProfitMultiplier1Level")
	reset("PermDuckProfitMultiplier1Cost")
	reset("PermSuperDuckChance")
	reset("PermSuperDuckChanceCost")
	reset("PermDuckProfitSavingsAmount")
	reset("PermGlobalSavings")
	reset("PermGlobalSavingsCost")
	reset("PermHitboxSize")
	reset("PermHitboxSizeCost")
	reset("PermHitboxBought")
	reset("Rebirth1Cost")
	reset("Rebirth1Count")
end

local function Layer3Reset(data)
	Layer2Reset(data)
	local function reset(key)
		data[key] = Config.CompatTemplate[key]
	end
	reset("Feathers")
	reset("PermHitboxSizeMult")
	reset("Rebirth2Cost")
	reset("Rebirth2Count")
	reset("ExtraDuckProfitMultiplier")
	reset("PermEggProfitMultiplier2")
	reset("PermEggProfitMultiplier2Level")
	reset("PermEggProfitMultiplier2Cost")
	reset("PermEggSavings")
	reset("PermEggSavingsCost")
	reset("PermHitboxSizeExtra")
	reset("PermHitboxSizeExtraCost")
	--reset("Perm2Speed")
	--reset("Perm2SpeedCost")
	reset("Rebirth2Cost")
end

local function Layer4Reset(data)
	Layer3Reset(data)
	local function reset(key)
		data[key] = Config.CompatTemplate[key]
	end
	reset('Puddles')
	reset('PermFeatherMultiplier')
	reset('PermFeatherMultiplierCost')
	reset('PermPrestigeCostReduction')
	reset('PermPrestigeCostReductionCost')
	reset('PermRebirthCostReduction')
	reset('PermRebirthCostReductionCost')
	reset('Level')
	reset('ExpToFinish')
	reset('Exp')
	reset('Ducktonium')
	reset('OwnedCards')
	reset('CurrentCardSelection')
	reset('Cards_DuckMult')
	reset('Cards_EggMult')
	reset('Cards_HitboxSize')
	reset('Autocollector')
end

function roll(weightTable)
	local totalWeight = 0
	for _, weight in pairs(weightTable) do
		totalWeight = totalWeight + weight
	end
	
	local randomValue = math.random() * totalWeight
	
	
	local cumulativeWeight = 0
	for index, weight in pairs(weightTable) do
		cumulativeWeight = cumulativeWeight + weight
		if randomValue <= cumulativeWeight then
			return index
		end
	end
end

local function RefreshCards(plr)
	local data = DataManager.Data[plr]
	
	local len = 0
	for _, _ in pairs(CardConfig) do
		len += 1
	end
	local cardsPossible = math.clamp(len - #data.OwnedCards, 0, 3)
	
	local prizeTable = {}
	
	for i, card in pairs(CardConfig) do
		prizeTable[i] = card.Weight
	end
	
	--data.CurrentCardSelection = {}
	local cardSel = {}
	
	for i = 1, cardsPossible do
		local c = roll(prizeTable)
		while table.find(data.OwnedCards, c) or table.find(cardSel, c) do
			print('rand card')
			c = roll(prizeTable)
			--task.wait()
		end
		table.insert(cardSel, c)
	end
	data.CurrentCardSelection = cardSel
end

Remotes.Island1Rebirth.OnServerEvent:Connect(function(plr)
	
	--print(`rebirth {plr.Name}`)
	
	local data = DataManager.GetData(plr)
	
	local eggValue = ((data.Rebirth1Cost * (InfNum.new(1) + (data.PermDuckProfitMultiplier1Level * (TENTH * (InfNum.new("1.10") ^ data.PermDuckProfitMultiplier1Level)))))) * (ONE - data.PermRebirthCostReduction)
	
	if data.Ducks < eggValue then
		--print(`{plr.Name} only has {data.Ducks} ducks`)
		return
	end
	
	print("rebirthing")
	
	data.Eggs += ((InfNum.floor(data.Ducks / eggValue) * data.PermEggProfitMultiplier2) * data.GamepassEggMult) * data.Cards_EggMult * data.EggMania_Mult
	
	Layer1Reset(data)
	
	data.Rebirth1Count += InfNum.new(1)
	 
	--data.Rebirth1Cost *= InfNum.new(Config.Rebirth1CostMultiplier)
	
	Remotes.ClearDucks:FireClient(plr)
	Remotes.ServerClearDucks:Fire(plr)
	
	data.Ducks = InfNum.new("0")
	
	print("rebirthed")
	
	print(`count: {tostring(data.Rebirth1Count)}`)
	
	if data.Rebirth1Count == InfNum.new(1) then
		Remotes.EggShopTutorialArrows:FireClient(plr)
	elseif data.Rebirth1Count >= InfNum.new(3) then
		if not table.find(data.Islands, "Island Two") then
			table.insert(data.Islands, "Island Two")
		end
		if not table.find(data.Islands, "Island Three") then
			table.insert(data.Islands, "Island Three")
		end
	end
	
end)

Remotes.ServerRemoteClearDucks.OnServerEvent:Connect(function(plr)
	Remotes.ClearDucks:FireClient(plr)
	Remotes.ServerClearDucks:Fire(plr)
end)

Remotes.Island3Rebirth.OnServerEvent:Connect(function(plr)
	
	local data = DataManager.GetData(plr)
	local prestigeCost = ((data.Rebirth2Cost * (ONE - data.PermPrestigeCostReduction))) * (ONE - data.PermPrestigeCostReduction)
	
	if data.Eggs < prestigeCost then
		return
	end
	
	local feathers = InfNum.floor(data.Eggs / prestigeCost)
	
	data.Feathers += feathers * data.PermFeatherMultiplier * data.GamepassFeatherMult * data.FeatheredFortune_Mult
	data.Rebirth2Count += ONE
	data.CareerRebirth2Count += ONE
	
	Remotes.ClearDucks:FireClient(plr)
	Remotes.ServerClearDucks:Fire(plr)
	
	if not table.find(data.Islands, "Island Four") then
		table.insert(data.Islands, "Island Four")
	end
	
	Layer2Reset(data)
	
end)

Remotes.Island4Rebirth.OnServerEvent:Connect(function(plr)
	
	local data = DataManager.GetData(plr)
	local island4RebirthCost = (data.Rebirth3Cost)
	
	if data.Feathers < island4RebirthCost then
		return
	end
	
	local puddles = InfNum.floor((data.Feathers / island4RebirthCost) * data.SplashyRiches_Mult)
	
	data.Puddles += puddles
	
	Remotes.ClearDucks:FireClient(plr)
	Remotes.ServerClearDucks:Fire(plr)
	
	if (not table.find(data.Islands, "Island Five")) and (data.Puddles >= InfNum.new("1500000000")) then
		table.insert(data.Islands, "Island Five")
	end
	
	Layer3Reset(data)

end)

Remotes.Ascend.OnServerEvent:Connect(function(plr)
	local data = DataManager.GetData(plr)
	local ascendCost = InfNum.new("1500000000") -- 1.5B
	
	if data.Puddles < ascendCost then
		return
	end
	
	local goldenDucks = InfNum.floor(data.Puddles / ascendCost)
	
	data.GoldenDucks += goldenDucks
	data.Ascensions += InfNum.new("1")
	data.Puddles = InfNum.new("0")
	
	Remotes.ClearDucks:FireClient(plr)
	Remotes.ServerClearDucks:Fire(plr)
	
	Layer4Reset(data)
end)

local function unlockUpg(plr, upgName)
	local data = DataManager.GetData(plr)
	if not table.find(data.UnlockedAscensionUpgrades, upgName) then
		table.insert(data.UnlockedAscensionUpgrades, upgName)
	end
end

Remotes.AscensionUpgrades.DuckMania.OnServerEvent:Connect(function(plr)
	local data = DataManager.GetData(plr)
	AscensionUpgradeConfig.DuckMania.ServerUpgrade(plr, data)
end)

Remotes.AscensionUpgrades.EggMania.OnServerEvent:Connect(function(plr)
	local data = DataManager.GetData(plr)
	AscensionUpgradeConfig.EggMania.ServerUpgrade(plr, data)
end)

Remotes.AscensionUpgrades.XpSurge.OnServerEvent:Connect(function(plr)
	local data = DataManager.GetData(plr)
	AscensionUpgradeConfig.XpSurge.ServerUpgrade(plr, data)
end)

Remotes.AscensionUpgrades.UglyDuckling.OnServerEvent:Connect(function(plr)
	local data = DataManager.GetData(plr)
	AscensionUpgradeConfig.UglyDuckling.ServerUpgrade(plr, data)
end)

Remotes.AscensionUpgrades.FrugalFledgling.OnServerEvent:Connect(function(plr)
	local data = DataManager.GetData(plr)
	AscensionUpgradeConfig.FrugalFledgling.ServerUpgrade(plr, data)
end)

Remotes.AscensionUpgrades.Dectonium.OnServerEvent:Connect(function(plr)
	local data = DataManager.GetData(plr)
	AscensionUpgradeConfig.Dectonium.ServerUpgrade(plr, data)
end)

Remotes.AscensionUpgrades.FeatheredFortune.OnServerEvent:Connect(function(plr)
	local data = DataManager.GetData(plr)
	AscensionUpgradeConfig.FeatheredFortune.ServerUpgrade(plr, data)
end)

Remotes.AscensionUpgrades.SplashyRiches.OnServerEvent:Connect(function(plr)
	local data = DataManager.GetData(plr)
	AscensionUpgradeConfig.SplashyRiches.ServerUpgrade(plr, data)
end)

Remotes.AscensionUpgrades.MultiUpgrade.OnServerEvent:Connect(function(plr, upgradeCount: number, upgradeName: string)
	if plr:GetAttribute("MultiUpgrading") then
		return
	end
	plr:SetAttribute("MultiUpgrading", true)
	local data = DataManager.GetData(plr)
	local upgrade = AscensionUpgradeConfig[upgradeName]
	
	if not upgrade.HasCounter then
		return
	end
	
	local expectedData = upgrade.GetExpectedData()
	local dataToPass = {}
	
	--print(expectedData)
	
	for _, expected in pairs(expectedData) do
		--print(expected)
		dataToPass[expected] = table.clone(data[expected])
	end
	
	local upgradeStep = upgrade.GetNextUpgrade(plr, dataToPass)
	
	local upgradesDone = 0
	while true do
		if upgradesDone >= upgradeCount then
			break
		end
		for i = 1, 100 do
			if upgradesDone >= upgradeCount then
				break
			end
			if (not upgrade.HasEnough(plr, dataToPass)) then
				print("Player cannot upgrade")
				return
			end
			if ((upgrade.IsMaxxed) and upgrade.IsMaxxed(plr, upgradeStep)) then
				break
			end
			upgrade.ServerUpgrade(plr, dataToPass)
			for index, value in pairs(upgradeStep) do
				dataToPass[index] = value
			end
			upgradeStep = upgrade.GetNextUpgrade(plr, dataToPass)
			upgradesDone += 1
		end
		task.wait(0.08)
	end
	
	--print(dataToPass)
	
	for dataKey, dataValue in pairs(dataToPass) do
		data[dataKey] = dataValue
	end
	plr:SetAttribute("MultiUpgrading", false)
end)

Remotes.PromptGamepass.OnServerEvent:Connect(function(plr, id)
	
	MPS:PromptGamePassPurchase(plr, id)
	
end)

Remotes.CollectPresent.OnServerInvoke = function(plr)
	local data = DataManager.Data[plr]
	while not data do
		data = DataManager.Data[plr]
		task.wait()
	end
	if data.Winter_2024PresentCollected then
		return false
	end
	if data.Winter2024_Candycanes >= InfNum.new(8) then
		data.Winter_2024PresentCollected = true
		data.DoubleDuckRewardTimer = InfNum.new("10")
		coroutine.wrap(function() BadgeService:AwardBadge(plr.UserId, 1383956438527633) end)()
		return true
	end
	return false
end

local skinPurchaseDevProductID = 2681081491
local skinThatIsMoreExpensiveDevProductID = 2954364789
local skinThatIsMoreExpensiveButLessThanTheOtherOneDevProductID = 3000926038

local skinsThatAreMoreExpensiveBecauseLanRecomendedThis = {
	'Ascension'
}

local skinsThatAreMoreExpensiveButNotAsMuchAsTheOtherTableBecauseLanReccomendedThis = {
	'Cool'
}

Remotes.PurchaseSkin.OnServerEvent:Connect(function(plr, skinName)
	if plr:GetAttribute("buying_skin") then
		return
	end
	
	-- fetch data
	print("Fetching data...")
	local data = nil
	repeat data = DataManager.Data[plr]; task.wait(); until data ~= nil
	print("Data Fetched")
	
	if table.find(data.Skins, skinName) then
		print("Player already has skin")
		return
	end
	
	local pId = skinPurchaseDevProductID
	if table.find(skinsThatAreMoreExpensiveBecauseLanRecomendedThis, skinName) then
		print('skin is slightly more expensive')
		pId = skinThatIsMoreExpensiveDevProductID
	elseif table.find(skinsThatAreMoreExpensiveButNotAsMuchAsTheOtherTableBecauseLanReccomendedThis, skinName) then
		print('skin is slightly more exepsneisve but not as much')
		pId = skinThatIsMoreExpensiveButLessThanTheOtherOneDevProductID
	end
	
	plr:SetAttribute("buying_skin", true)
	
	-- register purchase event
	local connection
	connection = MPS.PromptProductPurchaseFinished:Connect(function(userId, productId, isPurchased)
		-- ensure the purchase is from the player and is for the skin
		print(`Purchase completed on product {productId}`)
		if userId == plr.UserId and productId == pId then
			if isPurchased then
				-- add the skin to the player's inventory
				table.insert(data.Skins, skinName)
				Remotes.PlayChaChing:FireClient(plr)
				data.Skin = skinName
			end
			plr:SetAttribute("buying_skin", false)
			connection:Disconnect()
		end
	end)
	
	-- prompt purchase
	MPS:PromptProductPurchase(plr, pId)
end)

Remotes.EquipSkin.OnServerEvent:Connect(function(plr, skinName)
	
	-- fetch data
	local data = nil
	repeat data = DataManager.Data[plr]; task.wait(); until data ~= nil
	
	if table.find(data.Skins, skinName) then
		data.Skin = skinName
	--else
		--plr:Kick('Exploiting Detected')
	end
	
end)

Remotes.BuyCard.OnServerEvent:Connect(function(plr, cardIdx)
	local data = DataManager.Data[plr]
	local cardName = data.CurrentCardSelection[cardIdx]
	local card = CardConfig[cardName]
	local cardCost = InfNum.new(tostring(card.Cost))
	if data.Ducktonium >= cardCost then
		data.Ducktonium -= cardCost
		table.insert(data.OwnedCards, cardName)
		-- refresh cards
		RefreshCards(plr)
		card.ObtainFunc(plr, data)
	end
end)

Remotes.RefreshCards.OnServerEvent:Connect(function(plr)
	local data = DataManager.Data[plr]
	if data.Ducktonium > InfNum.new(0) then
		data.Ducktonium -= ONE
		RefreshCards(plr)
	end
end)

Remotes.RefreshCardsBindable.Event:Connect(RefreshCards)

local codes = {
	
	["1234567890"] = function(plr: Player)
		return "Thanks for... Nothing?"
	end,
	
	["TYFOR50K"] = function(plr: Player)
		local data = DataManager.Data[plr]
		data.Ducks += InfNum.new("1000000")
		return "You've been rewarded 1 Million Ducks!"
	end,
	
	["NEWUPDATE"] = function(plr: Player)
		local data = DataManager.Data[plr]
		data.Ducktonium += InfNum.new("3")
		return "You've been rewarded 3 Ducktonium."
	end,
	
	["IWANTAUTOCOLLECTOR!"] = function(plr: Player)
	local data = DataManager.Data[plr]
	data.Ducktonium += InfNum.new("5")
		return "You've been rewarded 3 Ducktonium."
	end,
	
	["MOBILECOMPENSATION"] = function(plr: Player)
		local data = DataManager.Data[plr]
		data.Ducktonium += InfNum.new("0.5")
		return "You've been rewarded 0.5 Ducktonium, sorry for the bugs."
	end,

	--["SkinExample"] = function(plr: Player)
	--local data = DataManager.Data[plr]
	--table.insert(data.Skins, "SkinNameHere")
	--return "reward text here"
	--end,

	--["DUCKTONIUM"] = function(plr: Player)
	--	local data = DataManager.Data[plr]
	--	data.Ducktonium += InfNum.new("0.0001")
	--	return "You've been rewarded 0.0001 Ducktonium!"
	--end,
	--["Sigma"] = function(plr: Player)
	--	local data = DataManager.Data[plr]
	--	table.insert(data.Skins, "Sigma")
	--	return "DON'T MESS WITH THE TRUE SIGMAS! (You were given the thumb skin.)"
	--end,
	
	--["GiveDucksExample"] = function(plr: Player)
	--local data = DataManager.Data[plr]
	--data.Ducks += InfNum.new("10")
	--return "You've been given 10 ducks"
	--end,
	
	--["CODESAREHERE2025"] = function(plr: Player)
	--	local data = DataManager.Data[plr]
	--	data.Ducktonium += InfNum.new("1")
	--	return "You've been rewarded 1 Ducktonium!"
	--end,

	--["NetheriticNetherite"] = function(plr: Player)
	--	local data = DataManager.Data[plr]
	--	table.insert(data.Skins, "Subspace")
	--	return "You've been rewarded the Subspace Tripmine skin!"
	--end,

	--["RLG"] = function(plr: Player)
	--	local data = DataManager.Data[plr]
	--	table.insert(data.Skins, "RollingVIP")
	--	return "Thanks for the bug report!"
	--end,
}

Remotes.RedeemCode.OnServerInvoke = function(plr: Player, code: string)
	local data = DataManager.Data[plr]
	local func = codes[code]
	if func then
		if not data.RedeemedCodes[code] then
			data.RedeemedCodes[code] = InfNum.new("1")
			return true, func(plr)
		else
			return false, "Already Redeemed!"
		end
	else
		return false, "Failed"
	end
end

Remotes.Donate.OnServerEvent:Connect(function(plr, amount)
	local donationProductID = nil
	
	if plr:GetAttribute("donating_process") then
		return
	end
	
	for _, info in pairs(Config.DonationTable) do
		if info[1] == amount then
			donationProductID = info[2]
			break
		end
	end
	if donationProductID then
		MPS:PromptProductPurchase(plr, donationProductID)
		plr:SetAttribute("donating_process", true)
		local connection
		connection = MPS.PromptProductPurchaseFinished:Connect(function(userId, productId, isPurchased)
			if userId == plr.UserId and productId == donationProductID then
				if isPurchased then
					local data = DataManager.Data[plr]
					data.Donated += InfNum.new(tostring(amount))
					plr:SetAttribute("donating_process", false)
					connection:Disconnect()
				else
					plr:SetAttribute("donating_process", false)
					connection:Disconnect()
				end
			end
		end)
	end
end)

MPS.PromptGamePassPurchaseFinished:Connect(function(plr, id, scs)
	if scs then
		DataManager.UpdateGamepassByID(plr, id)
		table.insert(DataManager.ForceUpdate, plr)
	end
end)

while task.wait(1.0) do
	for _, player in pairs(game:GetService("Players"):GetPlayers()) do
		player:SetAttribute("MultiUpgrading", false)
	end
end
