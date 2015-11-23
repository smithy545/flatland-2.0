return function(self, dt)
end,
function(self)
	self.personality = {a = 0.5, d = 0, n = 0.5}
	self.color = {255, 255, 0}
	self.body:setX(0)
	self.body:setY(0)
	self:turn(math.pi / 4)
end