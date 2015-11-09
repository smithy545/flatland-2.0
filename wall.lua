wall = class:new()

function wall:init(vertices)
	self.vertices = vertices
	self.hp = 150

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

	if self.x1 == self.x2 then
		self.slope = nil
	else
		self.slope = self.y2 - self.y1 / self.x2 - self.x1
	end
end

function wall:draw()
	love.graphics.setColor(255,0,0)
	love.graphics.line(self.x1, self.y1, self.x2, self.y2)
end

function wall:collide(x, y)
	if slope then
		if self.y1 < self.y2 then
			return x >= self.x1 and x <= self.x2 and y >= self.y1 and y <= self.y2
		else
			return x >= self.x1 and x <= self.x2 and y <= self.y1 and y >= self.y2
		end
	end

	if self.y1 < self.y2 then
		return x == self.x1 and y <= self.y2 and y >= self.y1
	end

	return x == self.x1 and y >= self.y2 and y <= self.y1
end