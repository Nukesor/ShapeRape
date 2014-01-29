PlayerColorSystem = class("PlayerColorSystem", System)

function PlayerColorSystem:update(dt)
    local player = table.firstElement(self.targets)
    local color = player:getComponent("ColorComponent")
    local dt = dt *200
    if color.r > 0 and color.b == 0 then
        color.r = color.r - dt
        color.g = color.g + dt
        if color.r < 0 then
            color.r = 0
            color.g = 255
        end
    elseif color.g > 0 and color.r == 0 then
        color.g = color.g - dt
        color.b = color.b + dt
        if color.g < 0 then
            color.g = 0
            color.b = 255
        end
    elseif color.b > 0 and color.g == 0 then
        color.b = color.b - dt
        color.r = color.r + dt
        if color.b < 0 then
            color.b = 0
            color.r = 255
        end
    end

    color.r = 255
    color.g = 255
    color.b = 255
end

function PlayerColorSystem:getRequiredComponents()
    return {"PlayerNodeComponent"}
end
