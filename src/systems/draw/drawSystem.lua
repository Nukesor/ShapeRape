DrawSystem = class("DrawSystem", System)

function DrawSystem:__init()
end

function DrawSystem:draw()
    love.graphics.setColor(255, 255, 255, 255)
    local nodeWidth = stack:current().nodeWidth
    local middleoffset = nodeWidth/2

    local rotateflag = 0.05
    if (love.math.random(0,5) < 2) then
    	rotateflag = 0.05
    end

    for index, entity in pairs(self.targets) do
        local drawable = entity:getComponent("DrawableComponent")
        local pos = entity:getComponent("PositionComponent")
        local posXnew = pos.x + middleoffset
        local posYnew = pos.y + middleoffset

        local offsetX = (drawable.image:getWidth())/2+love.math.random(0,10)
        local offsetY = (drawable.image:getHeight())/2+love.math.random(0,10)

        drawable.r = drawable.r + rotateflag

        if entity:getComponent("ColorComponent") then
        	local color = entity:getComponent("ColorComponent")
        	love.graphics.setColor(color.r, color.g, color.b)
        end

        -- Draws the Picture. If Entity is near to the beginng or the end of the screen, the Entity is drawed on both sides for sideChangeSystem animation.
        love.graphics.draw(drawable.image, posXnew, posYnew, drawable.r, drawable.sx, drawable.sy, offsetX, offsetY)
    end
end

function DrawSystem:getRequiredComponents()
    return {"DrawableComponent", "PositionComponent"}
end
