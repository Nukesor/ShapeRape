AnimateSystem = class("AnimateSystem", System)

function AnimateSystem:update(dt)
	for index, entity in pairs(self.targets) do
		local anim = entity:getComponent("AnimateComponent")
		if anim.tweenID == nil then
			anim.tweenID = tween(anim.time, anim.subject, anim.target, anim.easing, anim.callback, self, entity)
		end
	end
	tween.update(dt)
end

function AnimateSystem:animationDone(entity)
	local anim = entity:getComponent("AnimateComponent")
	entity:removeComponent("AnimateComponent")
	anim.callback(unpack(anim.callbackArgs))
end