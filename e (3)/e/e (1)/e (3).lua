-- Variables
local PhysicsService = game:GetService("PhysicsService")
local PlayerService = game:GetService("Players")

-- Collision group set-up
--PhysicsService:CreateCollisionGroup("PlayerCharacters")
PhysicsService:CollisionGroupSetCollidable("PlayerCharacters", "PlayerCharacters", false)

-- Functions & connections
local function characterAdded(character)
	for _, bodyPart in pairs(character:GetChildren()) do
		if bodyPart:IsA("BasePart") then
			PhysicsService:SetPartCollisionGroup(bodyPart, "PlayerCharacters")
		end
	end
end

local function playerAdded(player)
	player.CharacterAdded:Connect(characterAdded)

	if player.Character then
		characterAdded(player.Character)
	end
end

for _, player in pairs(PlayerService:GetPlayers()) do
	playerAdded(player)
end

PlayerService.PlayerAdded:Connect(playerAdded)
