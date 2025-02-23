local RS = game:GetService("ReplicatedStorage")
local Libraries = RS:WaitForChild("Libraries")
local InfiniteMath = require(Libraries:WaitForChild("InfiniteMath"))

local function num(n)
	local infiniteNum = InfiniteMath.new(n)
	print(`creating template num ({infiniteNum.first}, {infiniteNum.second})`)
	return {value = {infiniteNum.first, infiniteNum.second}, inf = true}
end

local template = require(Libraries.Config).Template

return template
