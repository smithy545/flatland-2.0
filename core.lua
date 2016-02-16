core = class:new()

function core:init(x, y, colori, coloro)
	self.type = "core"
	self.r = 50
	self.x = x
	self.y = y
	self.hp = 80
	self.colori = colori or {0, 76, 153}
	self.color = coloro or {70, 130, 180}
	self.zorps = {}
	self.body = love.physics.newBody(world, x, y)
	self.shape = love.physics.newCircleShape(self.r)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
end

function core:draw()
	-- inner color: (0, 76, 153)
	-- outer color: (204, 255, 229)
	for i=1,self.r do
		love.graphics.setColor(self.colori[1] + i * (self.color[1] - self.colori[1]) / self.r,
								self.colori[2] + i * (self.color[2] - self.colori[2]) /self.r,
								self.colori[3] + i * (self.color[3] - self.colori[3]) / self.r)
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
	return checkPointCircle(x, y, self.x, self.y, self.r)
end

function core:getX()
	return self.x
end

function core:getY()
	return self.y
end

function core:getRadius()
	return self.r
end