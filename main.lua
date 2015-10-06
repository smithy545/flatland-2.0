function love.load()
	require "class"
	require "geometry"
	require "zorp"
	require "hero"
	require "core"

	-- Set up objects lists
	objects = {}
	objects["hero"] = hero:new(0, 0, 3)
	objects["zorps"] = {}
	objects["cores"] = {}
	-- Set up some zorps
	for i=1,3 do
		objects["zorps"][i] = zorp:new(200, i*200, i + 2)
		objects["zorps"][i]:translate(50*i, 50*i)
		objects["zorps"][i]:changeDir(60*i)
	end
	-- Set up some cores
	for i=1,1 do
		objects["cores"][i] = core:new(0,0)
	end

	-- Other
	love.mouse.setRelativeMode(false)
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
	objects["hero"]:update(dt)

end

function love.draw()
	-- Background
	love.graphics.setBackgroundColor(255,255,255)

	-- Viewing Translation
	love.graphics.translate(tVec.x, tVec.y)
	love.graphics.scale(scale)

	-- Zorps
	for i, zorp in ipairs(objects["zorps"]) do
		zorp:draw()
	end
	-- Cores
	for i, core in ipairs(objects["cores"]) do
		core:draw()
	end
	-- Hero
	objects.hero:draw()
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
	end
end

function love.quit()
	print("Thanks for playing!")
end
