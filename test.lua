testSphere = class:new()

function testSphere:init()
	self.x = 100
	self.y = 100
	self.r = 30
	self.hp = 1000
	self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
	self.shape = love.physics.newCircleShape(self.r)
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
	self.name = "test"
end

function testSphere:draw()
	love.graphics.setColor(193, 47,14)
	love.graphics.circle("fill", self.x, self.y, self.r)
end

function testSphere:update(dt)
	self.x = self.body:getX()
	self.y = self.body:getY()
end

function testSphere:collide(x, y, color)
	return false
end