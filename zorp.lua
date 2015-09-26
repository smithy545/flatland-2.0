zorp = class:new()

local temp = 0

function zorp:init(x, y, sides, irregular)
	self.anglesum = 180*(sides - 2)
	self.regular = not irregular
	self.angles = {}
	self.x = x
	self.y = y
	self.size = 50						-- radius
	self.dir = 0 						-- direction
	self.n = sides 						-- number of sides
	if regular then
		for i=1,5 do
			self.angles[i] = self.anglesum / sides
		end
	else
		-- irregular not supported yet
		for i=1,5 do
			self.angles[i] = self.anglesum / sides
		end
	end
	self.vertices = buildRegPolygon(self.x, self.y, self.size, self.n, self.dir)
end

function zorp:draw()
	love.graphics.setColor(70,130,180)
	love.graphics.polygon("fill", self.vertices)
end

function zorp:translate(dx, dy)
	self.x = self.x + dx
	self.y = self.y + dy
end

function zorp:move(d)
	self.x = self.x + d*math.cos(self.dir)
	self.y = self.y + d*math.sin(self.dir)
end

function zorp:changeDir(theta)
	self.dir = self.dir + theta
end

function zorp:update(dt)
	temp = temp + dt
	self:think(temp)
	if temp > 0.1 then
		temp = 0
	end

	self.vertices = buildRegPolygon(self.x, self.y, self.size, self.n, self.dir)
end

function zorp:think(dt)
	if math.random() >= 0.7 then
		self:move(1)
	end
	if temp >= 0.05 then
		local test = self.dir
		self.dir = self.dir + math.rad(math.random()*math.random(-1, 1))
	end
end