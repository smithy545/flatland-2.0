-- Checks if a box is within another box
-- Returns true if colliding, false otherwise
function checkCollisionBox(x1, y1, w1, h1, x2, y2, w2, h2)
	return x1 < x2 + w2 and
	x2 < x1 + w1 and
	y1 < y2 + h2 and
	y2 < y1 + h1
end

-- Returns the vertices of a regular polygon centered at (x, y) with
-- a distance r from the center to each of its vertices pointing in the given direction
function buildRegPolygon(x, y, r, sides, direction)
	local theta = direction % (2*math.pi)
	local vertices = {}
	for i=0,(2*math.pi),((2*math.pi)/sides) do
		table.insert(vertices, math.floor(x + r*math.cos(theta + i)))
		table.insert(vertices, math.floor(y + r*math.sin(theta + i)))
	end
	return vertices
end

-- Returns the angle between the two vectors
function getAngle(x1, y1, x2, y2)
	dx = x2 - x1
	dy = y2 - y1
	theta = math.atan(math.abs(dy / dx))
	if dx > 0 and dy > 0 then
		return theta
	elseif dx < 0 and dy > 0 then
		return math.pi - theta
	elseif dx < 0 and dy < 0 then
		return theta + math.pi
	elseif dx > 0 and dy < 0 then
		return 2*math.pi - theta
	elseif dx == 0 then
		if dy > 0 then
			return math.pi / 2
		elseif dy < 0 then
			return 3 * (math.pi / 2)
		end
	elseif dy == 0 then
		if dx > 0 then
			return 0
		elseif dx < 0 then
			return math.pi
		end
	end

	return 0
end

-- Returns true if the two numbers are within 1 (or the given parameter) of each other
-- returns false otherwise
function isClose(a, b, closeness)
	d = 1
	if closeness then
		d = closeness
	end

	if math.abs(a - b) <= d then
		return true
	end

	return false
end