MenuPointDisplaySystem = class("MenuPointDisplaySystem", System)

function MenuPointDisplaySystem:draw()
    local menu = stack:current()
    for index, name in pairs(menu.menupoints) do
        love.graphics.setColor(255, 255, 255, 255)
        local x = love.graphics.getWidth() * 1/10
        local y = index * love.graphics.getWidth() * 1/10
        if menu.index == index then
            love.graphics.print(name[1], x, y, 0, 1.5, 1.5)
        else
            love.graphics.print(name[1], x, y)
        end
    end
end