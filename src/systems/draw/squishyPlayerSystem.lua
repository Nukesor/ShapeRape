SquishyPlayerSystem = class("SquishyPlayerSystem", System)

function SquishyPlayerSystem:playerMoved(event)
	local player = table.firstElement(stack:current().engine:getEntityList("PlayerNodeComponent"))
	local drawable = player:get("DrawableComponent")

	local anim = player:get("AnimateComponent")
	if anim then 
		tween.stop(anim.tweenID)
		if anim.sx then drawable.sx = anim.sx end
		if anim.sy then drawable.sy = anim.sy end
		player:remove("AnimateComponent")
	end
	local scaleKey = "sy"
	if event.direction == "up" or event.direction == "down" then scaleKey = "sx" end

	local targetObject = {}
	targetObject[scaleKey] = drawable[scaleKey] - (drawable[scaleKey]/10)

	player:add(AnimateComponent(0.1, drawable, targetObject, "outQuad", 
		self.animationDone, {self, scaleKey, drawable[scaleKey], player}))
	player:get("AnimateComponent")[scaleKey] = drawable[scaleKey]
end

function SquishyPlayerSystem:animationDone(scaleKey, originalSize, player)
	local targetObject = {}
	targetObject[scaleKey] = originalSize
	if player:get("AnimateComponent") == nil then
		player:add(AnimateComponent(0.1, player:get("DrawableComponent"), targetObject, "inQuad"))
	end
	player:get("AnimateComponent")[scaleKey] = originalSize
end
