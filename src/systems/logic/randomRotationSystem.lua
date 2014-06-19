RandomRotationSystem = class("RandomRotationSystem", System)

function RandomRotationSystem:update(dt)
    local intensity = 1

    intensity = math.abs(stack:current().actionBar-100)/20

	for index, entity in pairs(self.targets) do
		if entity:get("AnimateComponent") == nil and entity:get("PlayerNodeComponent") == nil then
			drawable = entity:get("DrawableComponent")
			local rotation = love.math.random(0, 2)
			if rotation >= 1 then
				rotation = 1
			else
				rotation = -1
			end
			local time = 1 + love.math.random(1,2)
			local targetR = drawable.r + (love.math.random(1,3))*(rotation*intensity)
			local anim = AnimateComponent(time, drawable, {r = targetR}, "inOutCubic")
			entity:add(anim)
		end
	end
end

function RandomRotationSystem:requires()
	return {"DrawableComponent"}
end