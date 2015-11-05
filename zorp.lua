zorp = class:new()

function zorp:init(x, y, sides, irregular)
	self.name = "zorp"
	self.anglesum = 180*(sides - 2)
	self.regular = not irregular
	self.angles = {}
	self.speed = 100
	self.hp = 25
	self.x = x
	self.y = y
	self.r = 25							-- radius
	self.dir = 0 						-- direction
	self.n = sides 						-- number of sides
	self.charging = false
	self.queue = Queue:new()
	self.color = {r = 70, g = 130, b = 180}
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
	love.graphics.setColor(self.color.r + (1-self.hp/100)*(128-self.color.r),
						   self.color.g + (1-self.hp/100)*(128-self.color.r),
						   self.color.b + (1-self.hp/100)*(128-self.color.r))
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
	local x = self.x + (d + self.r)*math.cos(self.dir)
	local y = self.y + (d + self.r)*math.sin(self.dir)
	if not self:checkCollision(x, y, objects) then
		self.x = x - self.r * math.cos(self.dir)
		self.y = y - self.r * math.sin(self.dir)
	end
end

function zorp:moveFree(d)
	self.x = self.x + d*math.cos(self.dir)
	self.y = self.y + d*math.sin(self.dir)
end

function zorp:path(x, y)
	
end

function zorp:moveTo(x, y)
	self.queue:pushRight({key = "moveTo", x = x, y = y, dir = getAngle(self.x, self.y, x, y)})
end

function zorp:moveTowards(x, y, r)
	self.queue:pushRight({key = "moveTowards", x = x, y = y, r = r, dir = getAngle(self.x, self.y, x, y)})
end

function zorp:charge()
	self.queue:pushRight({key = "charge"})
end

function zorp:changeDir(theta)
	self.dir = self.dir + theta
end

-- This is basically the same as changeDir but with collision detection
function zorp:turn(theta)
	if not self:checkPolyCollision(buildRegPolygon(self.x, self.y, self.r, self.n, self.dir + theta), objects) then
		self:changeDir(theta)
	end
end

function zorp:update(dt)
	local item = self.queue:peekRight()
	if not item then
		self:think(dt)
	elseif item["key"] == "moveTo" then
		if item.dir < self.dir and (self.dir - item.dir) > dt then
			self:turn(-dt)
		elseif item.dir > self.dir and (item.dir - self.dir) > dt then
			self:turn(dt)
		else
			if distance(self.x, self.y, item.x, item.y) > 2*self.speed*dt then
				self:move(self.speed*dt)
			else
				self.queue:popRight()
			end
		end
	elseif item["key"] == "moveTowards" then
		if item.dir < self.dir and (self.dir - item.dir) > dt then
			self:turn(-dt)
		elseif item.dir > self.dir and (item.dir - self.dir) > dt then
			self:turn(dt)
		else
			if distance(self.x, self.y, item.x, item.y) > item.r + self.r + self.speed*dt then
				self:move(self.speed*dt)
			else
				self.queue:popRight()
			end
		end
	elseif item["key"] == "pathTo" then
		
	elseif item["key"] == "charge" then
		self.hp = self.hp + 10*dt
		if self.hp >= 100 then
			self.hp = 100
			self.queue:popRight()
		end
	elseif item["key"] == "buildHome" then
		if distance(self.x, self.y, self.home.x, self.home.y) > 2*self.speed*dt then
			self:goHome()
		elseif checkPolyCollisions(self.home.vertices, objects) then
			self:buildHome()
		else
			table.insert(objects["homes"], self.home)
			self.queue:popRight()
		end
	end

	self.vertices = self:buildVerts()
end

function zorp:think(dt)

end

-- Checks if the point is in the zorp
-- Using Barycentric method from blackpawn.com
function zorp:collide(x, y)
	if self.n == 3 then
		return checkPointTriangle(x, y, self.vertices)
	elseif self.n == 4 then
		return checkPointSquare(x, y, self.x, self.y, self.r)
	else
		return checkPointCircle(x, y, self.x, self.y, self.r)
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

function zorp:checkCollision(x, y, objects)
	for i, objectType in pairs(objects) do
		for j, object in ipairs(objectType) do
			if object ~= self and object:collide(x, y) then
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

function zorp:buildHome()
	local x, y
	x = self.core.x + (2*math.random(0,1)-1)*self.core.r*(2 + 2*math.random())
	y = self.core.y + (2*math.random(0,1)-1)*self.core.r*(2 + 2*math.random())
	while checkPolyCollisions(buildRegPolygon(x, y, self.r*2, 5, getAngle(x, y, self.core.x, self.core.y)), objects) do
		x = self.core.x + (2*math.random(0,1)-1)*self.core.r*(2 + 2*math.random())
		y = self.core.y + (2*math.random(0,1)-1)*self.core.r*(2 + 2*math.random())
	end
	
	self.home = home:new(x, y, self.r*3)
	local home = self.home
	self.home.vertices = buildRegPolygon(home.x, home.y, home.r, 5, getAngle(home.x, home.y, self.core.x, self.core.y))
	self:goHome()
	self.queue:pushRight({key = "buildHome", home = self.home})
end

function zorp:goHome()
	self:moveTo(self.home.x, self.home.y)
end