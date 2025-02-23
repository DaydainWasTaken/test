local BadgeService = game:GetService("BadgeService")

local devs = {
	3204821431,
	3525750653,
	3529947965,
}

local DevMeetBadgeID = 600550764094248

while task.wait(2.0) do
	--print('heartbeat')
	for i, v in pairs(game:GetService("Players"):GetPlayers()) do
		--print('playerloop')
		if v.UserId == 3204821431 or v.UserId == 3525750653 or v.UserId == 3529947965 then
			--print('found dev')
			for j, w in pairs(game:GetService("Players"):GetPlayers()) do
				if not BadgeService:UserHasBadgeAsync(w.UserId, DevMeetBadgeID) then
					--print('rewarding')
					BadgeService:AwardBadge(w.UserId, DevMeetBadgeID)
				end
			end
			break
		end
	end
end
