DrawSystem = class("DrawSystem", System)

function DrawSystem:__init()
end

function DrawSystem:draw()
    local player 
    love.graphics.setColor(255, 255, 255, 255)
    local nodeWidth = stack:current().nodeWidth
    local middleoffset = nodeWidth/2

    local rotateflag = 0
    local player
    local intensity = 1
    for index, entity in pairs(self.targets) do
        if entity:getComponent("PlayerNodeComponent") then
            player = entity
            intensity = player:getComponent("PlayerChangeCountComponent").count+1
        end 
    end

    for index, entity in pairs(self.targets) do
        local drawable = entity:getComponent("DrawableComponent")
        local pos = entity:getComponent("PositionComponent")
        local posXnew = pos.x + middleoffset
        local posYnew = pos.y + middleoffset

        local offsetX = (drawable.image:getWidth())/2
        local offsetY = (drawable.image:getHeight())/2

        drawable.r = drawable.r + rotateflag

        if entity:getComponent("ColorComponent") then
            local color = entity:getComponent("ColorComponent")
            love.graphics.setColor(color.r, color.g, color.b)
        end

        -- Draws the Picture. If Entity is near to the beginng or the end of the screen, the Entity is drawed on both sides for sideChangeSystem animation.
        love.graphics.draw(drawable.image, posXnew, posYnew, drawable.r*intensity, drawable.sx, drawable.sy, offsetX, offsetY)
    end
end

function DrawSystem:getRequiredComponents()
    return {"DrawableComponent", "PositionComponent"}
end
