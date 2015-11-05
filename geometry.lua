-- Checks if a box is within another box
-- Returns true if colliding, false otherwise
function checkDoubleBox(x1, y1, w1, h1, x2, y2, w2, h2)
	return x1 < x2 + w2 and
	x2 < x1 + w1 and
	y1 < y2 + h2 and
	y2 < y1 + h1
end

function checkDoubleSquare(x1, y1, r1, x2, y2, r2)
	return x1 - r1/2 < x2 + r2/2 and
	x2 - r2/2 < x1 + r1/2 and
	y1 - r1/2 < y2 + r2/2 and
	y2 - r2/2 < y1 + r1/2
end

function checkPointSquare(x1, y1, x2, y2, r2)
	return x1 < x2 + r/2 and
	x2 - r/2 < x1 and
	y1 < y2 + r/2 and
	y2 - r/2 < y1
end

function checkPointCircle(x1, y1, x2, y2, r)
	return distance(x1,y1,x2,y2) <= r
end

function checkDoubleCircle(x1, y1, r1, x2, y2, r2)
	return math.abs(x1 - x2) <= r1 + r2 and math.abs(y1 - y2) <= r1 + r2
end

function checkCollisions(x, y, objects)
	for objectName, objectType in pairs(objects) do
		for i, object in ipairs(objectType) do
			if object:collide(x, y) then
				return true
			end
		end
	end

	return false
end

function checkPolyCollisions(vertices, objects)
	for i, v in ipairs(vertices) do
		if checkCollisions(v.x, v.y, objects) then
			return true
		end
	end

	return false
end

function checkPointTriangle(x, y, v)
	local d00, d01, d02, d11, d12, v0, v1, v2
	local v0 = v[3] - v[1]
	local v1 = v[2] - v[1]
	local v2 = Vector.new(x,y) - v[1]
	d00 = v0:dot(v0)
	d01 = v0:dot(v1)
	d02 = v0:dot(v2)
	d11 = v1:dot(v1)
	d12 = v1:dot(v2)

	local invDenom = 1 / (d00 * d11 - d01 * d01)
	local u = (d11 * d02 - d01 * d12) * invDenom
	local v = (d00 * d12 - d01 * d02) * invDenom

	return (u >= 0) and (v >= 0) and (u + v < 1)
end

-- Returns the vertices of a regular polygon centered at (x, y) with
-- a distance r from the center to each of its vertices pointing in the given direction
function buildRegPolygon(x, y, r, sides, direction)
	local theta = direction % (2*math.pi)
	local vertices = {}
	for i=0,sides - 1 do
		table.insert(vertices, Vector.new(math.floor(x + r*math.cos(theta + i*(2*math.pi)/sides)),
								math.floor(y + r*math.sin(theta + i*(2*math.pi)/sides))))
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
	d = closeness or 2

	if math.abs(a - b) <= d then
		return true
	end

	return false
end

-- Returns distance between two points
function distance(x1, y1, x2, y2)
	return math.sqrt(math.pow(x1-x2,2) + math.pow(y1-y2,2))
end

-- Returns the dot product of two vectors
-- From rosettacode.org/wiki/Dot_product
function dot(a, b)
	local prod = 0
	for i, aa in ipairs(a) do
		prod = prod + aa * b[i]
	end

	return prod
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end