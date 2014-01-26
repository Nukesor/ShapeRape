RandomRotationSystem = class("RandomRotationSystem", System)

function RandomRotationSystem:update(dt)
	local player
    local intensity = 1
    for index, entity in pairs(self.targets) do
        if entity:getComponent("PlayerNodeComponent") then
            player = entity
            intensity = math.abs(stack:current().actionBar-100)/20
        end 
    end
	for index, entity in pairs(self.targets) do
		if entity:getComponent("AnimateComponent") == nil then
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

function RandomRotationSystem:getRequiredComponents()
	return {"DrawableComponent"}
end