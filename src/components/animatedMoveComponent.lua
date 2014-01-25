AnimatedMoveComponent = class("AnimatedMoveComponent", Component)

function AnimatedMoveComponent:__init(targetX, targetY, targetNode)
	self.targetX = targetX
	self.targetY = targetY
	self.targetNode = targetNode
end