DrawSystem = class("DrawSystem", System)

function DrawSystem:__init()
end

function DrawSystem:draw()
    love.graphics.setColor(255, 255, 255, 255)
    for index, entity in pairs(self.targets) do
        local drawable = entity:getComponent("DrawableComponent")
        local pos = entity:getComponent("PositionComponent")

        local nodeWidth = stack:current().nodeWidth
        local offsetX = math.ceil(nodeWidth - (1+drawable.sx)*(drawable.image:getWidth()))/2
        local offsetY = math.ceil(nodeWidth - (1+drawable.sy)*(drawable.image:getHeight()))/2
        print(nodeWidth)

        -- Draws the Picture. If Entity is near to the beginng or the end of the screen, the Entity is drawed on both sides for sideChangeSystem animation.
        love.graphics.draw(drawable.image, pos.x, pos.y, drawable.r, drawable.sx, drawable.sy, offsetX, offsetY)
    end
end

function DrawSystem:getRequiredComponents()
    return {"DrawableComponent", "PositionComponent"}
end
