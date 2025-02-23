local part = Instance.new('Part')
part.Anchored = true
part.Position = Vector3.new(10,4,10)

part.Parent = workspace

--workspace:WaitForChild('Baseplate'):Destroy()

local a = true

while a do
	local boom = Instance.new('Explosion')
	task.wait()
	boom.Position = part.Position
	boom.BlastRadius = 20
	boom.BlastPressure = 10000000
	boom.Parent = workspace
end



