function love.load()
	require "class"
	require "vector"
	require "geometry"
	require "queue"
	require "wall"
	require "zorp"
	require "hero"
	require "core"
	require "utilities"

	-- Set up objects lists
	objects = {}
	objects["hero"] = {}
	objects["zorps"] = {}
	objects["cores"] = {}
	objects["walls"] = {}
	selected = {}
	selectBox = nil
	enabledZorps = {}
	enabledZorps["default.lua"] = nil
	enabledZorps["peter.lua"] = true
	enabledZorps["test.lua"] = nil

	-- Physics
	METER = 64
	love.physics.setMeter(METER) -- 64px meter
	world = love.physics.newWorld(0, 0, true)
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)
	pause = false
	gridOn = false
	gridSize = 10

	--table.insert(objects["hero"], hero:new(-200, 0, 3))

	-- Set up some zorps
	math.randomseed(os.time())
	local filenum = 1
	for i, filename in ipairs(love.filesystem.getDirectoryItems("zorps/")) do
		if enabledZorps[filename] then
			local cx, cy
			coreTaken = true
			while coreTaken do
				cx, cy = math.random(0,400), math.random(0,400)
				coreTaken = false
				for j, c in ipairs(objects["cores"]) do
					if c:collide(cx, cy) then
						coreTaken = true
					end
				end
			end
			objects["cores"][filenum] = core:new(cx, cy)
			local zsides = 0 --math.random(0,2) + math.random(0,2) + math.random(0,2)
			for j=3*filenum - 2,3*filenum do
				table.insert(objects["zorps"], zorp:new(cx + 10*objects["cores"][filenum].r*math.cos(j*math.pi*2/3), cy + 10*objects["cores"][filenum].r*math.sin(j*math.pi*2/3), zsides))
				local init
				objects["zorps"][j].think, init = loadfile("lua_game/zorps/" .. filename)()
				if init then
					init(objects["zorps"][j])
				end
				objects["zorps"][j].name = tostring(j)
			end
			filenum = filenum + 1
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

	if pause then
		return
	end

	world:update(dt)

	mx, my = toScale(love.mouse.getX(), love.mouse.getY())
	if selectBox then
		selectBox.w = mx - selectBox.x
		selectBox.h = my - selectBox.y
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

	for i, object in ipairs(selected) do
		print(object.name, object:getX(), object:getY())
	end
end

function love.draw()
	mx, my = toScale(love.mouse.getX(), love.mouse.getY())

	-- Viewing Translation
	love.graphics.translate(tVec.x, tVec.y)
	love.graphics.scale(scale)

	for objectName, objectType in pairs(objects) do
		for i, object in ipairs(objectType) do
			object:draw()
			local x, y, w, h = object.fixture:getBoundingBox() -- w and h are really x2 and y2 here
			w = w - x -- adjusting to appropriate width
			h = h - y -- adjusting to appropriate height
			love.graphics.setColor(255,0,0)
			love.graphics.rectangle("line", x, y, w, h)
		end
	end

	if selectBox then
		love.graphics.setColor(255,0,0)
		love.graphics.rectangle("line", selectBox.x, selectBox.y, selectBox.w, selectBox.h)
	end

	love.graphics.print(mx..","..my, mx, my, 0)
end

function love.mousepressed(x, y, button)
	if button == "wu" then
		scale = scale + scale / 8
	elseif button == "wd" then
		scale = scale - scale / 8
	elseif button == "l" then
		selectBox = {x = toScaleX(x), y = toScaleY(y), w = 0, h = 0}
	end
end

function love.mousereleased(x, y, button)
	if button == "l" then
		selected = selectObjects(selectBox)
		selectBox = nil
	elseif button == "r" then
		local scaledX, scaledY = toScale(x,y)
		for i, object in ipairs(objects["hero"][1].selected) do
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

function love.keyreleased(key)
	if(key == " ") then
		pause = not pause
	elseif(key == "m") then
		if objects["hero"][1] then
			if objects["hero"][1].mode == "hero" then
				objects["hero"][1].mode = "command"
				objects["hero"][1].selected = {}
			else
				objects["hero"][1].mode = "hero"
			end
		end
	elseif(key == "g") then
		gridOn = not gridOn
	elseif(key == "escape") then
		love.event.quit()
	end
end

function love.quit()
	print("Thanks for playing!")
end

function beginContact(a, b, coll)

end

function endContact(a, b, coll)

end

function preSolve(a, b, coll)

end

function postSolve(a, b, coll, normalimpulse, tangentimpulse2, normalimpulse2, tangentimpulse2)

end