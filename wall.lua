wall = class:new()

function wall:init(vertices, color)
	self.hp = 20
	self.color = color or {0,0,0}
	self.type = "wall"

	self.x1 = vertices[1].x
	self.x2 = vertices[2].x
	self.y1 = vertices[1].y
	self.y2 = vertices[2].y

	self.length = distance(self.x1, self.y1, self.x2, self.y2)

	self.body = love.physics.newBody(world, 0, 0)
	self.shape = love.physics.newEdgeShape(self.x1, self.y1, self.x2, self.y2)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
end

function wall:draw()
	love.graphics.setColor(self.color)
	love.graphics.line(self.x1, self.y1, self.x2, self.y2)
end

function wall:getX()
	return (self.x1+self.x2)/2
end

function wall:getY()
	return (self.y1+self.y2)/2
end

function wall:getRadius()
	return self.length
end