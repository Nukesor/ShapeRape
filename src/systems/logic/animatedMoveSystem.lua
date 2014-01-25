AnimatedMoveSystem = class("AnimatedMoveSystem", System)

function AnimatedMoveSystem:update()
	for index, entity in pairs(self.targets) do
		local moveComp = entity:getComponent("AnimatedMoveComponent")
		local position = entity:getComponent("PositionComponent")

		local addValue = 10

		if moveComp.targetX < position.x - addValue then position.x = position.x - addValue
		elseif moveComp.targetX > position.x + addValue then position.x = position.x + addValue
		else position.x = moveComp.targetX end
		if moveComp.targetY < position.y - addValue then position.y = position.y - addValue
		elseif moveComp.targetY > position.y + addValue then position.y = position.y + addValue
		else position.y = moveComp.targetY end

		if position.x == moveComp.targetX and position.y == moveComp.targetY then
			entity:getComponent("PlayerNodeComponent").node = moveComp.targetNode
			entity:removeComponent("AnimatedMoveComponent")
		end
	end
end

function AnimatedMoveSystem:getRequiredComponents()
	return {"AnimatedMoveComponent", "PositionComponent"}
end