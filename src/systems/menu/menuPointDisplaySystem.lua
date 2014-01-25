MenuPointDisplaySystem = class("MenuPointDisplaySystem", System)

function MenuPointDisplaySystem:__init()
    local screenWidth = love.graphics.getWidth()
    for index, item in pairs(stack:current().menupoints) do
        item.x = (screenWidth/2)-100
        item.y = -200
        tween.start(0.5/index, item, {x = item.x, y = 200 + (100 * index)}, "inOutExpo", self.animationFinished, self)
    end
end

function MenuPointDisplaySystem:update(dt)
    tween.update(dt)
end

function MenuPointDisplaySystem:draw()
    local menu = stack:current()
    for index, item in pairs(menu.menupoints) do
        love.graphics.setColor(255, 255, 255, 255)
        if menu.index == index then
            love.graphics.print(item[1], item.x, item.y, 0, 1.5, 1.5)
        else
            love.graphics.print(item[1], item.x, item.y)
        end
    end
end

function MenuPointDisplaySystem:animationFinished()
end