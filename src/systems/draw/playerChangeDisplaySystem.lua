PlayerChangeDisplaySystem = class("PlayerChangeDisplaySystem", System)

function PlayerChangeDisplaySystem:__init()
    self.next = {circle = "square",
                square = "triangle",
                triangle = "circle"}
end

function PlayerChangeDisplaySystem:draw()
    local nodeWidth = stack:current().nodeWidth
    local middleoffset = nodeWidth/2

    for index, entity in pairs(self.targets) do
        local shape = entity:getComponent("ShapeComponent").shape
        local pos = entity:getComponent("PositionComponent")
        local posXnew = pos.x + middleoffset
        local posYnew = pos.y + middleoffset

        local offsetX = (resources.images[self.next[shape]]:getWidth())/2+love.math.random(0,10)
        local offsetY = (resources.images[self.next[shape]]:getHeight())/2+love.math.random(0,10)

        local color = entity:getComponent("ColorComponent")
        love.graphics.setColor(0, 0, 0, 255)

        local max = stack:current().size
        local count = entity:getComponent("PlayerChangeCountComponent").count
        -- Draws the Picture. If Entity is near to the beginng or the end of the screen, the Entity is drawed on both sides for sideChangeSystem animation.
        love.graphics.draw(resources.images[self.next[shape]], posXnew, posYnew, drawable.r, 0.2*(count/max), 0.2*(count/max), offsetX, offsetY)
    end
end

function PlayerChangeDisplaySystem:getRequiredComponents()
    return {"PlayerChangeCountComponent"}
end
