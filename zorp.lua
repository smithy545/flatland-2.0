zorp = class:new()

local temp = 0

function zorp:init(x, y, sides, irregular)
	self.name = "zorp"
	self.anglesum = 180*(sides - 2)
	self.regular = not irregular
	self.angles = {}
	self.speed = 10
	self.x = x
	self.y = y
	self.r = 50							-- radius
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
	self.vertices = self:buildVerts()
end

function zorp:draw()
	love.graphics.setColor(70,130,180)
	local drawVerts = {}
	for i, a in pairs(self.vertices) do
		table.insert(drawVerts, a.x)
		table.insert(drawVerts, a.y)
	end

	love.graphics.polygon("fill", drawVerts)
	if self.n > 3 then
		love.graphics.circle("line", self.x, self.y, self.r)
	end
end

function zorp:translate(dx, dy)
	self.x = self.x + dx
	self.y = self.y + dy
end

function zorp:move(d)
	local x = self.x + d*math.cos(self.dir)
	local y = self.y + d*math.sin(self.dir)
	if not self:checkPolyCollision(buildRegPolygon(x, y, self.r, self.n, self.dir), objects) then
		self.x = x -- self.r * math.cos(self.dir)
		self.y = y -- self.r * math.sin(self.dir)
	end
end

function zorp:changeDir(theta)
	self.dir = self.dir + theta
end

-- This is basically the same as changeDir but with collision detection
function zorp:turn(theta)
	local x = self.x + self.r*math.cos(self.dir + theta)
	local y = self.y + self.r*math.sin(self.dir + theta)
	if self:checkPolyCollision(buildRegPolygon(x, y, self.r, self.n, self.dir + theta), objects) then
		self:changeDir(theta)
	end
end

function zorp:update(dt)
	temp = temp + dt
	self:think(temp)
	if temp > 0.1 then
		temp = 0
	end

	self.vertices = self:buildVerts()
end

function zorp:think(dt)
	if not self.core then
		local d
		for i, core in ipairs(objects["cores"]) do
			if d == nil or distance(core.x, core.y, self.x, self.y) < d then
				d = distance(core.x, core.y, self.x, self.y)
				self.core = core
				table.insert(core.zorps, self)
			end
		end
	end

	if distance(self.x, self.y, self.core.x, self.core.y) > 100 then
		self.dir = getAngle(self.x, self.y, self.core.x, self.core.y)
		self:move(self.speed*dt)
	else

	end

end

-- Checks if the point is in the zorp
-- Using Barycentric method from blackpawn.com
function zorp:collide(x, y)
	local v = self.vertices
	if self.n == 3 then
		local d00, d01, d02, d11, d12, v0, v1, v2
		v0 = v[3] - v[1]
		v1 = v[2] - v[1]
		v2 = Vector.new(x,y) - v[1]
		d00 = v0:dot(v0)
		d01 = v0:dot(v1)
		d02 = v0:dot(v2)
		d11 = v1:dot(v1)
		d12 = v1:dot(v2)

		local invDenom = 1 / (d00 * d11 - d01 * d01)
		local u = (d11 * d02 - d01 * d12) * invDenom
		local v = (d00 * d12 - d01 * d02) * invDenom

		return (u >= 0) and (v >= 0) and (u + v < 1)
	else
		if distance(self.x, self.y, x, y) <= self.r then
			return true
		else
			return false
		end
	end
end

function zorp:collidePoly(vertices, object)
	for i, v in ipairs(vertices) do
		if object:collide(v.x, v.y) then
			return true
		end
	end

	return false
end

function zorp:checkPointCollision(x, y, objects)
	for i, objectType in pairs(objects) do
		for j, object in ipairs(objectType) do
			if object ~= self and object:collide(x, y) then
				return true
			end
		end
	end

	return false
end

function zorp:checkPolyCollision(vertices, objects)
	for i, objectType in pairs(objects) do
		for j, object in ipairs(objectType) do
			if object ~= self and self:collidePoly(vertices, object) then
				return true
			end
		end
	end

	return false
end

function zorp:buildVerts()
	local theta = self.dir % (2*math.pi)
	local vertices = {}
	for i=0, self.n - 1 do
		table.insert(vertices, Vector.new(math.floor(self.x + self.r*math.cos(theta + i*(2*math.pi)/self.n)),
								math.floor(self.y + self.r*math.sin(theta + i*(2*math.pi)/self.n))))
	end

	return vertices
end