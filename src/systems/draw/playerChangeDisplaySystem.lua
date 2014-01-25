PlayerChangeDisplaySystem = class("PlayerChangeDisplaySystem", System)

function PlayerChangeDisplaySystem:__init()
end

function PlayerChangeDisplaySystem:draw()
    love.graphics.setColor(255, 255, 255, 255)
    local nodeWidth = stack:current().nodeWidth
    local middleoffset = nodeWidth/2

    for index, entity in pairs(self.targets) do
        local drawable = entity:getComponent("DrawableComponent")
        local pos = entity:getComponent("PositionComponent")
        local posXnew = pos.x + middleoffset
        local posYnew = pos.y + middleoffset

        local offsetX = (drawable.image:getWidth())/2+love.math.random(0,10)
        local offsetY = (drawable.image:getHeight())/2+love.math.random(0,10)

        love.graphics.setColor(love.math.random(0, 255), love.math.random(0, 255), love.math.random(0, 255))

        local max = stack:current().size
        local count = entity:getComponent("PlayerChangeCountComponent").count+0.1
        -- Draws the Picture. If Entity is near to the beginng or the end of the screen, the Entity is drawed on both sides for sideChangeSystem animation.
        love.graphics.draw(drawable.image, posXnew, posYnew, drawable.r, drawable.sx*(count/max), drawable.sy*(count/max), offsetX, offsetY)
    end
end

function PlayerChangeDisplaySystem:getRequiredComponents()
    return {"PlayerChangeCountComponent"}
end
