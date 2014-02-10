MenuPointDisplaySystem = class("MenuPointDisplaySystem", System)

function MenuPointDisplaySystem:__init()
    for index, item in pairs(stack:current().menupoints) do
        tween.start(0.5/index, item, {x = item.targetX, y = item.targetY}, "inOutExpo", self.animationFinished, self)
    end
end

function MenuPointDisplaySystem:update(dt)
    tween.update(dt)
end

function MenuPointDisplaySystem:draw()
    local menu = stack:current()
    for index, item in pairs(menu.menupoints) do
        if menu.index == index then
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.setFont(resources.fonts.CoolFont40)
            love.graphics.print(item[1], item.x, item.y - love.graphics.getFont():getHeight() / 2)
        else
            love.graphics.setColor(255, 255, 255, 200)
            love.graphics.setFont(resources.fonts.CoolFont)
            love.graphics.print(item[1], item.x, item.y - love.graphics.getFont():getHeight() / 2)
        end
    end
end

function MenuPointDisplaySystem:animationFinished()
end
