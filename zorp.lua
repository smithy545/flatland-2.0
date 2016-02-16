zorp = class:new()

function zorp:init(x, y, sides)
	self.type = "zorp"
	self.name = "zorp "..x..y
	self.speed = 150
	self.turnSpeed = 10
	self.damage = 10
	self.hp = 25
	self.n = sides
	self.r = 25
	self.body = love.physics.newBody(world, x, y, "dynamic")
	self.vertices = self:buildVerts()
	if sides < 3 then
		self.shape = love.physics.newCircleShape(25)
	else
		self.shape = love.physics.newPolygonShape(self:drawVerts())
	end
	self.fixture = love.physics.newFixture(self.body, self.shape, 1)
	self.fixture:setMask(1)
	self.body:setLinearDamping(0.1)
	self.charging = false
	self.queue = Queue:new()
	self.events = Queue:new()
	self.color = {70, 130, 180}
	self.personality = {a = 0, d = 0, n = 0}
	self.thoughts = {}
	x1,y1,xn1,yn1 = 0,0,0,0
end

function zorp:draw()
	love.graphics.setColor(self.color[1] + (1-self.hp/100)*(128-self.color[1]),
						   self.color[2] + (1-self.hp/100)*(128-self.color[2]),
						   self.color[3] + (1-self.hp/100)*(128-self.color[3]))

	if self.n < 3 then
		love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.r)
	else
		love.graphics.polygon("fill", self:drawVerts())
	end
	love.graphics.setColor(0,0,0)
	love.graphics.line(self:getX(), self:getY(),
						self:getX() + math.cos(self.body:getAngle())*self.shape:getRadius(),
						self:getY() + math.sin(self.body:getAngle())*self.shape:getRadius())

	love.graphics.print(self.fixture:getMask(), self.body:getX(), self.body:getY(), self.body:getAngle())
	love.graphics.line(x1,y1,x1+50*xn1,y1+50*yn1)
end

function zorp:move(d)
	-- Converting to Lua physics
	self.body:setX(self.body:getX() + d*math.cos(self.body:getAngle()))
	self.body:setY(self.body:getY() + d*math.sin(self.body:getAngle()))
end

function zorp:path(x, y)
	
end

function zorp:emptyQueue()
	self.queue = Queue:new()
end

function zorp:moveTo(x, y, r)
	if r then
		self.queue:pushRight({key = "moveToArea", x = x, y = y, r = r, dir = getAngle})
	end
	self.queue:pushRight({key = "moveTo", x = x, y = y, dir = getAngle})
end

function zorp:charge()
	self.queue:pushRight({key = "charge"})
end

function zorp:turn(theta)
	self.body:setAngle(self.body:getAngle() + theta)
end

function zorp:update(dt)
	local x, y = self.body:getPosition()
	local r = self.r
	local item = self.queue:peekRight()

	if not item then
		self:think(dt)
	elseif item["key"] == "moveTo" then
		world:rayCast(self:getX(), self:getY(), self:getX()+10*math.cos(self:getAngle()),self:getY()+10*math.sin(self:getAngle()), castCallback)
		local diff = self:getAngle() - item.dir(x, y, item.x, item.y)
		if math.abs(diff) > self.turnSpeed*dt then
			if diff > 0 then
				self:turn(-self.turnSpeed*dt)
			else
				self:turn(self.turnSpeed*dt)
			end
		else
			if distance(x, y, item.x, item.y) > 2*self.speed*dt then
				self:move(self.speed*dt)
			else
				self.queue:popRight()
			end
		end
	elseif item["key"] == "moveToArea" then
		local diff = self:getAngle() - item.dir(x, y, item.x, item.y)
		if math.abs(diff) > self.turnSpeed*dt then
			if diff > 0 then
				self:turn(-self.turnSpeed*dt)
			else
				self:turn(self.turnSpeed*dt)
			end
		else
			if distance(x, y, item.x, item.y) > 2*self.speed*dt + item.r then
				self:move(self.speed*dt)
			else
				self.queue:popRight()
			end
		end
	elseif item["key"] == "pathTo" then
		path = {}
		for i=1,100 do
			path[i].x = x + i*(item.x - x)/100
			path[i].y = y + i*(item.y - y)/100
			if checkCollisions(path[i].x, path[i].y, objects) then

			end
		end
	elseif item["key"] == "charge" then
		self.hp = self.hp + 10*dt
		if self.hp >= 100 then
			self.hp = 100
			self.queue:popRight()
		end
	elseif item["key"] == "buildHome" then
		self.queue:popRight()
		self:goHome()
		for i=1,5 do
			self:buildWall({item.vertices[i], item.vertices[(i%5)+1]})
		end
	elseif item["key"] == "buildWall" then
		table.insert(objects["walls"], item.w)
		item.w.fixture:setMask(self.fixture:getMask())
		self.queue:popRight()
	elseif item["key"] == "buildPolygon" then
		self.queue:popRight()
		for i=1,item.n do
			local w = wall:new({item.vertices[i], item.vertices[(i%item.n)+1]})
			self:buildWall(w.vertices)
		end
	elseif item["key"] == "attack" then
		if distance(x, y, item.x, item.y) > item.r + r + self.speed*dt then
			self:moveTo(item.x, item.y, item.r)
		else
			item.target.hp = item.target.hp - self.damage*dt
			if item.target.hp <= 0 then
				self.queue:popRight()
			end
		end
	elseif item["key"] == "function" then
		item:func()
	end

	self.vertices = self:buildVerts()
end

function zorp:think(dt)

end

function zorp:buildVerts()
	local theta = self:getAngle() % (2*math.pi)
	local vertices = {}
	for i=0, self.n - 1 do
		table.insert(vertices, Vector.new(math.floor(self:getX() + self.r*math.cos(theta + i*(2*math.pi)/self.n)),
								math.floor(self:getY() + self.r*math.sin(theta + i*(2*math.pi)/self.n))))
	end

	return vertices
end

function zorp:buildHome()
	local x, y
	local r = self.r
	x = self.core.x + (2*math.random(0,1)-1)*self.core.r*(2 + 2*math.random())
	y = self.core.y + (2*math.random(0,1)-1)*self.core.r*(2 + 2*math.random())
	
	self.home = {x=x, y=y, r=r*3}
	self.home.vertices = buildRegPolygon(x, y, r*3, 5, getAngle(x, y, self.core.x, self.core.y))
	self.queue:pushRight({key = "buildHome", vertices = self.home.vertices})
	self:goHome()
end

function zorp:goHome()
	self:moveTo(self.home.x, self.home.y)
end

function zorp:buildWall(vertices)
	self.queue:pushRight({key = "buildWall", w = wall:new(vertices, self.color)})
	self:moveTo((vertices[1].x + vertices[2].x) / 2, (vertices[1].y + vertices[2].y) / 2)
end

function zorp:attack(target)
	self.queue:pushRight({key = "attack", x = target:getX(), y = target:getY(), r = target:getRadius(), target = target})
end

function zorp:path(x, y)
	local stepx, stepy
	stepx = math.abs(self:getX()-x)/100
	stepy = math.abs(self:getY()-y)/100
	pathpoints = {}
	for itemx=self:getX(),x,stepx do
		for itemy=self:getY(),y,stepy do
			table.insert(pathpoints, {itemx, itemy})
		end
	end


	return nil
end

function zorp:getAngle()
	return self.body:getAngle()
end

function zorp:getX()
	return self.body:getX()
end

function zorp:getY()
	return self.body:getY()
end

function zorp:getRadius()
	return self.r
end

function zorp:drawVerts()
	return buildDrawVerts(self.vertices)
end

function castCallback(fixture, x, y, xn, yn, fraction)
	x1,y1,xn1,yn1 = x,y,xn,yn
	return -1
end