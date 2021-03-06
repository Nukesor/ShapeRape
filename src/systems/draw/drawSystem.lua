DrawSystem = class("DrawSystem", System)

function DrawSystem:draw()
    local player 
    local nodeWidth = stack:current().nodeWidth
    local middleoffset = nodeWidth/2

    for index, entity in pairs(self.targets) do
        local drawable = entity:get("DrawableComponent")
        local pos = entity:get("PositionComponent")
        local posXnew = pos.x + middleoffset
        local posYnew = pos.y + middleoffset

        local offsetX = (drawable.image:getWidth())/2
        local offsetY = (drawable.image:getHeight())/2

        local color
        if entity:get("ColorComponent") then
            local color = entity:get("ColorComponent")
            love.graphics.setColor(color.r, color.g, color.b)
        end

        -- Draws the Picture. If Entity is near to the beginng or the end of the screen, the Entity is drawed on both sides for sideChangeSystem animation.
        if entity:get("WobbleComponent") then
            scale = 1 + 0.1*math.sin(entity:get("WobbleComponent").value)
            love.graphics.draw(drawable.image, posXnew, posYnew, drawable.r, drawable.sx*scale, drawable.sy*scale, offsetX, offsetY)
        else
            love.graphics.draw(drawable.image, posXnew, posYnew, drawable.r, drawable.sx, drawable.sy, offsetX, offsetY)
        end


--        VERSION VON SVEN         
--        color = entity:get("ColorComponent")
--        love.graphics.setColor(color.r, color.g, color.b)
--        end
--
--        -- Draws the Picture. If Entity is near to the beginng or the end of the screen, the Entity is drawed on both sides for sideChangeSystem animation.
--        love.graphics.draw(drawable.image, posXnew, posYnew, drawable.r, drawable.sx, drawable.sy, offsetX, offsetY)
--        love.graphics.setColor(color.r, color.g, color.b, 100)
--        love.graphics.setBlendMode("additive")
--        love.graphics.draw(drawable.image, posXnew, posYnew, drawable.r, drawable.sx * 1.2, drawable.sy * 1.2, offsetX, offsetY)
--        love.graphics.setBlendMode("alpha")
--        love.graphics.setColor(color.r, color.g, color.b, 255)
    end
end

function DrawSystem:requires()
    return {"DrawableComponent", "PositionComponent"}
end
