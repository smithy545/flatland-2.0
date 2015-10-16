core = class:new()

function core:init(x, y, colori, coloro)
	self.name = "core"
	self.r = 100
	self.x = x
	self.y = y
	self.colori = colori or {0, 76, 153}
	self.coloro = coloro or {204, 255, 229}
	self.zorps = {}
end

function core:draw()
	-- inner color: (0, 76, 153)
	-- outer color: (204, 255, 229)
	for i=1,self.r do
		love.graphics.setColor(self.colori[1] + i * (self.coloro[1] - self.colori[1]) / self.r,
								self.colori[2] + i * (self.coloro[2] - self.colori[2]) /self.r,
								self.colori[3] + i * (self.coloro[3] - self.colori[3]) / self.r)
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

function core:collide(x, y)
	if distance(x, y, self.x, self.y) <= self.r then
		return true
	end

	return false
end