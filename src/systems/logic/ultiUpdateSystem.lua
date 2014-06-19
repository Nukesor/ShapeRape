UltiUpdateSystem = class("UltiUpdateSystem", System)

function UltiUpdateSystem:update(dt)
    for index, entity in pairs(self.targets) do
        entity:get("UltiComponent").timer = entity:get("UltiComponent").timer - dt
        if entity:get("UltiComponent").timer < 0  then
            entity:get("ColorComponent").r = 255
            entity:get("ColorComponent").b = 0
            entity:get("ColorComponent").g = 0
            entity:remove("UltiComponent")
        else
            entity:get("ColorComponent").r = love.math.random(0, 255)
            entity:get("ColorComponent").g = love.math.random(0, 255)
            entity:get("ColorComponent").b = love.math.random(0, 255)
            stack:current().shaketimer = 0.1
            stack:current().translate = 1
        end
    end
end

function UltiUpdateSystem:requires()
    return {"UltiComponent"}
end