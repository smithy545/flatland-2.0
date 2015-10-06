core = class:new()

function core:init(x, y)
	self.r = 100
	self.x = x
	self.y = y
	self.gradient = self.r / 100	-- The radius step of the different shaded circles to draw within outline
	self.zorps = {}
end

function core:draw()
	-- inner color: (0, 76, 153)
	-- outer color: (204, 255, 229)
	for i=1,self.r,self.gradient do
		love.graphics.setColor(0 + i * 255 / self.r, 0 + i * 255 /self.r, 0 + i * 255 / self.r)
		love.graphics.circle("line", self.x, self.y, i, 100)
	end
end

function core:addZorp(zorp)
	table.insert(zorps, zorp)
end

function core:isClose(x, y)
	if distance(x, y, self.x, self.y) <= self.r + 100 then
		return true
	end

	return false
end