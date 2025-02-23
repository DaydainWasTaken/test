local RS = game:GetService("ReplicatedStorage")
local Remotes = RS:WaitForChild("Remotes")

local DataStoreService = game:GetService("DataStoreService")

local DuckLBStore = DataStoreService:GetOrderedDataStore("DuckLBStoreDev1")
local LevelLBStore = DataStoreService:GetOrderedDataStore("LevelLBStoreDev1")
local DonateLBStore = DataStoreService:GetOrderedDataStore("DonatedLBStoreDev1")

local DataManager = require(game:GetService("ServerScriptService"):WaitForChild("Libraries"):WaitForChild("DataManager"))
local InfNum = require(RS:WaitForChild("Libraries"):WaitForChild("InfiniteMath"))

local lb = {HighestDucks = {}}

local names = {}

game:GetService("Players").PlayerAdded:Connect(function(plr)
	task.wait(5.0)
	Remotes.UpdateLeaderboards:FireClient(plr, lb)
	
end)

local Ranks = RS:WaitForChild("Ranks")
local rankTable = {
	[1] = Ranks.Gold,
	[2] = Ranks.Silver,
	[3] = Ranks.Bronze,
	[4] = Ranks.Diamond,
	[5] = Ranks.Diamond
}

game:GetService("RunService").Heartbeat:Connect(function()
	--print('heartbeat')
	--print(lb)
	for i, plr: Player in pairs(game:GetService("Players"):GetPlayers()) do
		for rank, info in pairs(lb.HighestDucks) do
			--print(plr.UserId)
			if plr.UserId == info.PlayerUserID then
				local char = plr.Character
				if char then
					local head = char:FindFirstChild("Head")
					if head then
						local nametag = head:FindFirstChild("Nametag")
						local rankTag = rankTable[rank]
						if not nametag then
							if rankTag then
								nametag = rankTag:Clone()
							else
								nametag = RS:WaitForChild("Ranks").Normal:Clone()
							end
						end
						nametag.Name = "Nametag"
						nametag:WaitForChild("BillboardGui"):WaitForChild("Txt").Text = `#{rank}`
						--if not head:FindFirstChild("TagWeld") then
						--local weld = Instance.new("Weld", head)
						--weld.Name = "TagWeld"
						--weld.Part0 = head
						--nametag.Position = head.Position
						--weld.Part1 = nametag
						--end
						nametag.Parent = head
						nametag.Anchored = true
						if nametag then
							nametag.Position = head.Position
						end
					end
				end
			end
		end
	end
end)

task.wait(65.0)

while true do
	print('loop')
	task.defer(function()
		--if DataManager.DataKey ~= "_Production1" then
			--return
		--end
		for _, player in game:GetService("Players"):GetPlayers() do
			if player.UserId <= 0 then
				continue
			end
			local data = DataManager.Data[player]
			DuckLBStore:SetAsync(player.UserId, data.HighestDucks:ConvertForLeaderboards())
			LevelLBStore:SetAsync(player.UserId, data.Level:ConvertForLeaderboards())
			DonateLBStore:SetAsync(player.UserId, data.Donated:ConvertForLeaderboards())
		end
		
		local LevelPages = LevelLBStore:GetSortedAsync(false, 100)
		local LevelTop = LevelPages:GetCurrentPage()
		
		local DuckPages = DuckLBStore:GetSortedAsync(false, 100)
		local DuckTop = DuckPages:GetCurrentPage()
		
		local DonationPages = DonateLBStore:GetSortedAsync(false, 100)
		local DonationTop = DonationPages:GetCurrentPage()
		
		lb = {Levels = {}, HighestDucks = {}, Donated = {}}
		
		for rank, data in LevelTop do
			--print(`{rank}. {InfiniteMath:ConvertFromLeaderboards(data.value)}`)
			local value = InfNum.floor(InfNum:ConvertFromLeaderboards(data.value))
			local name = nil
			local scs = false
			local iter = false
			
			if names[data.key] then
				name = names[data.key]
				scs = true
			end
			
			repeat
				if iter then
					task.wait(0.5)
				end
				scs, _ = pcall(function() name = game:GetService("Players"):GetNameFromUserIdAsync(data.key) end)
				iter = true
			until scs
			
			names[data.key] = name
			
			local userid = data.key
			lb.Levels[rank] = {
				PlayerName = name,
				PlayerUserID = data.key,
				Value = {value.first, value.second}
			}
		end
		
		for rank, data in DuckTop do
			print(rank)
			--print(`{rank}. {InfiniteMath:ConvertFromLeaderboards(data.value)}`)
			local value = InfNum:ConvertFromLeaderboards(data.value)
			local name = nil
			local scs = false
			local iter = false

			if names[data.key] then
				name = names[data.key]
				scs = true
			end

			repeat
				if iter then
					task.wait(0.5)
				end
				scs, _ = pcall(function() name = game:GetService("Players"):GetNameFromUserIdAsync(data.key) end)
				iter = true
			until scs

			names[data.key] = name
			local userid = data.key
			lb.HighestDucks[rank] = {
				PlayerName = name,
				PlayerUserID = data.key,
				Value = {value.first, value.second}
			}
		end
		
		for rank, data in DonationTop do
			--print(`{rank}. {InfiniteMath:ConvertFromLeaderboards(data.value)}`)
			local value = InfNum:ConvertFromLeaderboards(data.value)
			local name = nil
			local scs = false
			local iter = false

			if names[data.key] then
				name = names[data.key]
				scs = true
			end

			repeat
				if iter then
					task.wait(0.5)
				end
				scs, _ = pcall(function() name = game:GetService("Players"):GetNameFromUserIdAsync(data.key) end)
				iter = true
			until scs

			names[data.key] = name
			local userid = data.key
			lb.Donated[rank] = {
				PlayerName = name,
				PlayerUserID = data.key,
				Value = {value.first, value.second}
			}
		end
		
		Remotes.UpdateLeaderboards:FireAllClients(lb)
	end)
	
	task.wait(90.0)
	
end
