function selectObjects(box)
	local centerx, centery
	selected = {}
	centerx = box.x + box.w / 2
	centery = box.y + box.h / 2


	for i, object in ipairs(objects["zorps"]) do
		if checkPointRect(object:getX(), object:getY(), centerx, centery, math.abs(box.w), math.abs(box.h)) then
			table.insert(selected, object)
		end
	end

	return selected
end