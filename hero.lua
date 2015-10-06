hero = zorp:inherit()

function hero:init(x, y, sides, irregular)
	self.anglesum = 180*(sides - 2)
	self.regular = not irregular
	self.angles = {}
	self.x = x
	self.y = y
	self.size = 50						-- radius
	self.dir = 0 						-- direction
	self.n = sides 						-- number of sides
	self.speed = 100						-- speed of travel
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

function hero:draw()
	love.graphics.setColor(255, 69, 0)
	love.graphics.polygon("fill", self.vertices)
end

function hero:update(dt)
	mousex, mousey = love.mouse.getPosition()
	self.dir = getAngle(self.x + tVec.x, self.y + tVec.y, mousex, mousey)

	if love.mouse.isDown("l") and not (isClose(self.x, mousex - tVec.x) and isClose(mousey - tVec.y, self.y)) then
		self:move(self.speed*dt)
	end

	self.vertices = buildRegPolygon(self.x, self.y, self.size, self.n, self.dir)
end