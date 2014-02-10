AnimatedMoveSystem = class("AnimatedMoveSystem", System)

function AnimatedMoveSystem:movementFinished(entity)
	local moveComp = entity:getComponent("AnimatedMoveComponent")
	entity:getComponent("PlayerNodeComponent").node = moveComp.targetNode
	entity:removeComponent("AnimatedMoveComponent")
end

function AnimatedMoveSystem:update(dt)
	for index, entity in pairs(self.targets) do
		local moveComp = entity:getComponent("AnimatedMoveComponent")
		local position = entity:getComponent("PositionComponent")

		if moveComp.tweenID == nil then
			moveComp.tweenID = 
				tween.start(0.1, position, {x = moveComp.targetX, y = moveComp.targetY}, "outBack", self.movementFinished, self, entity)
		end
	end
	tween.update(dt)
end

function AnimatedMoveSystem:requires()
	return {"AnimatedMoveComponent", "PositionComponent"}
end