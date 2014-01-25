RandomRotationSystem = class("RandomRotationSystem", System)

function RandomRotationSystem:update(dt)
	for index, entity in pairs(self.targets) do
		if entity:getComponent("AnimateComponent") == nil then
			drawable = entity:getComponent("DrawableComponent")
			local rotation = math.ceil(love.math.random(-1,1))
			local anim = AnimateComponent(0.5 + love.math.random(0, 2), drawable, {r = drawable.r+(love.math.random(0,2))*rotation}, "linear")
			entity:addComponent(anim)
		end
	end
end

function RandomRotationSystem:getRequiredComponents()
	return {"DrawableComponent"}
end