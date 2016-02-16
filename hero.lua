hero = zorp:inherit()

function hero:init(x, y, sides, irregular)
	self.type = "hero"
	self.anglesum = 180*(sides - 2)
	self.regular = not irregular
	self.angles = {}
	self.x = x
	self.y = y
	self.r = 50						-- radius
	self.dir = 0 						-- direction
	self.n = sides 						-- number of sides
	self.speed = 100						-- speed of travel
	self.core = {x=0,y=0,r=10}
	self.mode = "hero"
	self.hp = 50
	self.color = {255, 69, 0}
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
	self.vertices = buildRegPolygon(self.x, self.y, self.r, self.n, self.dir)
end

function hero:draw()
	love.graphics.setColor(self.color)
	local drawVerts = {}
	for i, a in pairs(self.vertices) do
		table.insert(drawVerts, a.x)
		table.insert(drawVerts, a.y)
	end
	love.graphics.polygon("fill", drawVerts)
	if self.selectBox then
		love.graphics.rectangle("line", self.selectBox.x1, self.selectBox.y1, self.selectBox.w, self.selectBox.h)
	end
end

function hero:update(dt)
	local mousex, mousey = toScale(love.mouse.getX(), love.mouse.getY())
	
	self:setDir(getAngle(self.x, self.y, mousex, mousey))

	if self.mode == "hero" then
		if love.mouse.isDown("l") and not self:collide(mousex, mousey) then
			self:move(self.speed*dt)
		elseif love.mouse.isDown("r") then
			self:move(-1*self.speed*dt)
		end
	end

	self.vertices = buildRegPolygon(self.x, self.y, self.r, self.n, self.dir)
end

function hero:setDir(phi)
	if not self:checkPolyCollision(buildRegPolygon(self.x, self.y, self.r, self.n, phi), objects) then
		self.dir = phi
	end
end