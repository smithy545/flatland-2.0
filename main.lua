function love.load()
	require "class"
	require "vector"
	require "geometry"
	require "utilities"
	require "home"
	require "zorp"
	require "hero"
	require "core"

	-- Set up objects lists
	objects = {}
	objects["hero"] = {hero:new(-200, 0, 3)}
	objects["zorps"] = {}
	objects["cores"] = {}
	objects["homes"] = {}
	-- Set up some zorps
	for i, filename in ipairs(love.filesystem.getDirectoryItems("zorps/")) do
		local cx, cy
		coreTaken = true
		while coreTaken do
			cx, cy = math.random(0,400), math.random(0,400)
			coreTaken = false
			for i, c in ipairs(objects["cores"]) do
				if c.collide(cx, cy) then
					coreTaken = true
				end
			end
		end
		objects["cores"][i] = core:new(cx, cy)
		local zsides = math.random(1,3) + math.random(1,3) + math.random(1,3)
		for j=1,3 do
			objects["zorps"][j] = zorp:new(cx + 10*objects["cores"][i].r*math.cos(j*math.pi*2/3), cy + 10*objects["cores"][i].r*math.sin(j*math.pi*2/3), zsides)
			objects["zorps"][j].think = loadfile("lua_game/zorps/" .. filename)()
			objects["zorps"][j].name = tostring(j)
		end
	end

	-- Other
	-- love.mouse.setCursor(love.mouse.newCursor(love.image.newImageData("maxresdefault.png")),0,0)
	math.randomseed(os.time())
	scrollSpeed = 200 							-- speed at which screen scrolls
	tVec = {x = love.window.getWidth() / 2,
			y = love.window.getHeight() / 2}	-- translation vector
	scale = 1									-- scaling scalar

	-- Test Variables

end

function love.update(dt)
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

	-- Zorps
	for i,v in ipairs(objects["zorps"]) do
		v:update(dt)
	end
	-- Hero
	objects["hero"][1]:update(dt)

end

function love.draw()
	-- Background
	love.graphics.setBackgroundColor(255,255,255)

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
	end
end

function love.mousereleased(x, y, button)
	
end

function love.mousemoved(x, y, dx, dy)

end

function love.keypressed(key)
	
end

function love.keyreleased(key)
	if(key == " ") then
		love.mouse.setRelativeMode(not love.mouse.getRelativeMode())
	elseif(key == "i") then
		objects.hero.draw = function() end
	elseif(key == "escape") then
		love.event.quit()
	end
end

function love.quit()
	print("Thanks for playing!")
end
