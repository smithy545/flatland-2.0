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
	if self.core then
		if self.core:isClose(self.x, self.y) then
		else
			self.dir = getAngle(self.x, self.y, self.core.x, self.core.y)
			self:move(1)
		end
	else
		local d
		for i, core in ipairs(objects["cores"]) do
			if d == nil or distance(core.x, core.y, self.x, self.y) < d then
				d = distance(core.x, core.y, self.x, self.y)
				self.core = core
			end
		end
	end
	--[[
	if temp >= 0.04 then
		local test = self.dir
		self.dir = self.dir + math.rad(5*math.random()*math.random(-1, 1))
	end
	]]--
end

function zorp:collide(x, y)
	return true
end