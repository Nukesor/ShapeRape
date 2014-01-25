AnimatedMoveComponent = class("AnimatedMoveComponent", Component)

function AnimatedMoveComponent:__init(targetX, targetY, originX, originY, targetNode)
	self.targetX = targetX
	self.targetY = targetY
	self.targetNode = targetNode
	self.originX = originX
	self.originY = originY
end