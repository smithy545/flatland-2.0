home = class:new()

function home:init(x, y, r)
	self.x = x
	self.y = y
	self.r = r
	self.hp = 150
end

function home:collide(x, y)
	return checkPointCircle(x, y, self.x, self.y, self.r)
end

function home:draw()
	love.graphics.setColor(0, 0, 0)
	local drawVerts = {}
	for i, a in pairs(self.vertices) do
		table.insert(drawVerts, a.x)
		table.insert(drawVerts, a.y)
	end

	love.graphics.polygon("line", drawVerts)
	love.graphics.circle("line", self.x, self.y, self.r)
end