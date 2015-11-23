return function(self, dt)
	print(self.name, " is thinking")
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
	elseif self.hp < 50 or charging then
		if distance(self:getX(), self:getY(), self.core.x, self.core.y) >= self.core.r + self:getRadius() + 2 then
			self:moveTo(self.core.x, self.core.y, self.core.r)
		else
			self:charge()
		end
	elseif not self.home then
		self:buildHome()
	elseif not self.thoughts["cleared"] then
		for objectName, objectType in pairs(objects) do
			for i, object in ipairs(objectType) do
				if self.color[1] ~= object.color[1] or
					self.color[2] ~= object.color[2] or
					self.color[3] ~= object.color[3] then
					self:attack(object)
				end
			end
		end
		self.thoughts["cleared"] = true
	elseif not self.thoughts["fort"] then
		self.queue:pushRight({key = "buildPolygon", n = 20, vertices = buildRegPolygon(self.core.x, self.core.y, self.core.r*10, 20, 0)})
		self.thoughts["fort"] = true
	else
		self:goHome()
	end
end,
function(self)
	self.personality = {a = 0.5, d = 0, n = 0.5}
end