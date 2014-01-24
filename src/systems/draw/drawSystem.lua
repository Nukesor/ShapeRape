DrawSystem = class("DrawSystem", System)

function DrawSystem:draw()
    for index, entity in pairs(self.targets) do
        local position = entity:getComponent("PositionComponent")
        love.graphics.draw(entity:getComponent("DrawableComponent").image, position.x, position.y)
    end
end

function DrawSystem:getRequiredComponents()
    return {"DrawableComponent", "PositionComponent"}
end
