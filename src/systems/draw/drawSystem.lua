DrawSystem = class("DrawSystem", System)

function DrawSystem:__init()
end

function DrawSystem:draw()
    love.graphics.setColor(255, 255, 255, 255)
    for index, entity in pairs(self.targets) do
        local drawable = entity:getComponent("DrawableComponent")
        local pos = entity:getComponent("PositionComponent")

        -- Draws the Picture. If Entity is near to the beginng or the end of the screen, the Entity is drawed on both sides for sideChangeSystem animation.
        love.graphics.draw(drawable.image, pos.x, pos.y, drawable.r, drawable.sx, drawable.sy, drawable.ox, drawable.oy)
    end
end

function DrawSystem:getRequiredComponents()
    return {"DrawableComponent", "PositionComponent"}
end
