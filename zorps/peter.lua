return function(self, dt)
	if not self.core then
		local d
		for i, core in ipairs(objects["cores"]) do
			if d == nil or distance(core.x, core.y, self:getX(), self:getY()) < d then
				d = distance(core.x, core.y, self:getX(), self:getY())
				self.core = core
			end
		end
		if self.core then
			table.insert(self.core.zorps, self)
		end
	elseif not self.home then
		self:buildHome()
	else
	end
end,
function(self)
	self.color = {255, 0, 0}
	self.personality = {a = 0, d = 1, n = 0}
	self.n = 4
	self.fixture:setMask(2)
end