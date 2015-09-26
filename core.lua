core = class:new()

function core:init(x, y)
	self.r = 100
	self.x = x
	self.y = y
end

function core:draw()
	love.graphics.setColor(176, 224, 230)
	love.graphics.circle("line", self.x, self.y, self.r, 100)
end