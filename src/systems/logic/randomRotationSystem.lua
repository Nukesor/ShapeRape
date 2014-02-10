RandomRotationSystem = class("RandomRotationSystem", System)

function RandomRotationSystem:update(dt)
    local intensity = 1

    intensity = math.abs(stack:current().actionBar-100)/20

	for index, entity in pairs(self.targets) do
		if entity:getComponent("AnimateComponent") == nil and entity:getComponent("PlayerNodeComponent") == nil then
			drawable = entity:getComponent("DrawableComponent")
			local rotation = love.math.random(0, 2)
			if rotation >= 1 then
				rotation = 1
			else
				rotation = -1
			end
			local time = 1 + love.math.random(1,2)
			local targetR = drawable.r + (love.math.random(1,3))*(rotation*intensity)
			local anim = AnimateComponent(time, drawable, {r = targetR}, "inOutCubic")
			entity:addComponent(anim)
		end
	end
end

function RandomRotationSystem:requires()
	return {"DrawableComponent"}
end