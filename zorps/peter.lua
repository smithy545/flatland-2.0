return function(self, dt)
	self.color = {r=255,g=0,b=0}
	if not self.core then
		local d
		for i, core in ipairs(objects["cores"]) do
			if d == nil or distance(core.x, core.y, self.x, self.y) < d then
				d = distance(core.x, core.y, self.x, self.y)
				self.core = core
			end
		end
		table.insert(self.core.zorps, self)
	elseif not self.home then
		self:buildHome()
	end
end