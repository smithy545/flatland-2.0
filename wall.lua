wall = class:new()

function wall:init(vertices, color)
	self.vertices = vertices
	self.hp = 20
	self.color = color or {0,0,0}

	if vertices[1].x < vertices[2].x then
		self.x1 = vertices[1].x
		self.x2 = vertices[2].x
		self.y1 = vertices[1].y
		self.y2 = vertices[2].y
	else
		self.x1 = vertices[2].x
		self.x2 = vertices[1].x
		self.y1 = vertices[2].y
		self.y2 = vertices[1].y
	end

	self.length = distance(self.x1, self.y1, self.x2, self.y2)

	self.body = love.physics.newBody(world, (self.x1 + self.x2) / 2, (self.y1 + self.y2) / 2)
	self.shape = love.physics.newEdgeShape(self.x1, self.y1, self.x2, self.y2)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
end

function wall:draw()
	love.graphics.setColor(self.color)
	love.graphics.line(self.x1, self.y1, self.x2, self.y2)
end

function wall:collide(x, y, color)
	if color == self.color then
		return false
	end
	if math.floor(distance(x, y, self.x1, self.y1) + distance(x, y, self.x2, self.y2)) == math.floor(self.length) then
		return true
	end

	return false
end

function wall:getX()
	return self.body:getX()
end

function wall:getY()
	return self.body:getY()
end

function wall:getRadius()
	return self.length
end