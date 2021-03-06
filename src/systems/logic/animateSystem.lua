AnimateSystem = class("AnimateSystem", System)

function AnimateSystem:update(dt)
	for index, entity in pairs(self.targets) do
		local anim = entity:get("AnimateComponent")
		if anim.tweenID == nil then
			anim.tweenID = tween(anim.time, anim.subject, anim.target, anim.easing, self.animationDone, self, entity)
		end
	end
	tween.update(dt)
end

function AnimateSystem:animationDone(entity)
	local anim = entity:get("AnimateComponent")
	if anim then
		entity:remove("AnimateComponent")
		if anim.callback then anim.callback(unpack(anim.callbackArgs)) end
	end
end

function AnimateSystem:requires()
	return {"AnimateComponent"}
end