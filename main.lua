function love.load()
	require "class"
	require "vector"
	require "geometry"
	require "utilities"
	require "wall"
	require "home"
	require "zorp"
	require "hero"
	require "core"
	require "test"

	-- Set up objects lists
	objects = {}
	objects["hero"] = {}
	objects["zorps"] = {}
	objects["cores"] = {}
	objects["walls"] = {}
	objects["test"] = {}

	-- Physics
	METER = 64
	love.physics.setMeter(METER) -- 64px meter
	world = love.physics.newWorld(0, 0, true)

	--table.insert(objects["test"], testSphere:new())
	--table.insert(objects["hero"], hero:new(-200, 0, 3))

	-- Set up some zorps
	math.randomseed(os.time())
	for i, filename in ipairs(love.filesystem.getDirectoryItems("zorps/")) do
		local cx, cy
		coreTaken = true
		while coreTaken do
			cx, cy = math.random(0,400), math.random(0,400)
			coreTaken = false
			for i, c in ipairs(objects["cores"]) do
				if c:collide(cx, cy) then
					coreTaken = true
				end
			end
		end
		objects["cores"][i] = core:new(cx, cy)
		local zsides = 0 --math.random(0,2) + math.random(0,2) + math.random(0,2)
		for j=3*(i-1) + 1,3*i do
			table.insert(objects["zorps"], zorp:new(cx + 10*objects["cores"][i].r*math.cos(j*math.pi*2/3), cy + 10*objects["cores"][i].r*math.sin(j*math.pi*2/3), zsides))
			local init
			objects["zorps"][j].think, init = loadfile("lua_game/zorps/" .. filename)()
			if init then
				init(objects["zorps"][j])
			end
			objects["zorps"][j].name = tostring(j)
		end
	end

	-- Other
	scrollSpeed = 200 							-- speed at which screen scrolls
	tVec = {x = love.window.getWidth() / 2,
			y = love.window.getHeight() / 2}	-- translation vector
	scale = 1									-- scaling scalar

	love.window.setTitle("Flatland")
	love.graphics.setBackgroundColor(255,255,255)
	love.window.setMode(800,600)
end

function love.update(dt)
	world:update(dt)

	if love.keyboard.isDown("w") then
		tVec.y  = tVec.y + scrollSpeed*dt
	elseif love.keyboard.isDown("s") then
		tVec.y  = tVec.y - scrollSpeed*dt
	end
	if love.keyboard.isDown("a") then
		tVec.x  = tVec.x + scrollSpeed*dt
	elseif love.keyboard.isDown("d") then
		tVec.x  = tVec.x - scrollSpeed*dt
	end

	for objectName, objectType in pairs(objects) do
		for i, object in ipairs(objectType) do
			if object.hp <= 0 then
				table.remove(objects[objectName], i)
			elseif object.update then
				object:update(dt)
			end
		end
	end

end

function love.draw()
	-- Viewing Translation
	love.graphics.translate(tVec.x, tVec.y)
	love.graphics.scale(scale)

	for objectName, objectType in pairs(objects) do
		for i, object in ipairs(objectType) do
			object:draw()
		end
	end

end

function love.mousepressed(x, y, button)
	if button == "wu" then
		scale = scale + scale / 8
	elseif button == "wd" then
		scale = scale - scale / 8
	elseif button == "l" then
		if objects["hero"][1] then
			if objects["hero"][1].mode == "command" then
				objects["hero"][1].selectBox = {x1 = toScaleX(x), y1 = toScaleY(y)}
			end
		end
	end
end

function love.mousereleased(x, y, button)
	if objects["hero"][1] then
		if objects["hero"][1].mode == "command" then
			if button == "l" then
				objects["hero"][1]:select(x, y)
			elseif button == "r" then
				local scaledX, scaledY = toScale(x,y)
				for i, object in ipairs(objects["hero"][1].selected) do
					if object.name == "test" then
						object.body:applyForce((Vector(scaledX, scaledY) - Vector(object.x, object.y)):unpack())
					else
						object:emptyQueue()
						local attacking = false
						for i, target in ipairs(objects["zorps"]) do
							if target:collide(scaledX, scaledY) then
								object:attack(target)
								attacking = true
							end
						end
						if not attacking then
							object:moveTowards(scaledX, scaledY, 0)
						end
					end
				end
			end
		end
	end
end

function love.keyreleased(key)
	if(key == " ") then
		love.mouse.setRelativeMode(not love.mouse.getRelativeMode())
	elseif(key == "m") then
		if objects["hero"][1] then
			if objects["hero"][1].mode == "hero" then
				objects["hero"][1].mode = "command"
				objects["hero"][1].selected = {}
			else
				objects["hero"][1].mode = "hero"
			end
		end
	elseif(key == "escape") then
		love.event.quit()
	end
end

function love.quit()
	print("Thanks for playing!")
end
