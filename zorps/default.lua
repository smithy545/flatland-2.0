return function(self, dt)
	if not self.core then
		local d
		for i, core in ipairs(objects["cores"]) do
			if d == nil or distance(core.x, core.y, self.x, self.y) < d then
				d = distance(core.x, core.y, self.x, self.y)
				self.core = core
			end
		end
		table.insert(self.core.zorps, self)
	elseif self.hp < 50 or charging then
		if distance(self.x, self.y, self.core.x, self.core.y) >= self.core.r + self.r + 2 then
			self:moveTowards(self.core.x, self.core.y, self.core.r)
		else
			self:charge()
		end
	elseif not self.home then
		self:buildHome()
	end
end