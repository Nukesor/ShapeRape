UltiUpdateSystem = class("UltiUpdateSystem", System)

function UltiUpdateSystem:update(dt)
    for index, entity in pairs(self.targets) do
        entity:getComponent("UltiComponent").timer = entity:getComponent("UltiComponent").timer - dt
        if entity:getComponent("UltiComponent").timer < 0  then
            entity:getComponent("ColorComponent").r = 255
            entity:getComponent("ColorComponent").b = 0
            entity:getComponent("ColorComponent").g = 0
            entity:removeComponent("UltiComponent")
        else
            entity:getComponent("ColorComponent").r = love.math.random(0, 255)
            entity:getComponent("ColorComponent").g = love.math.random(0, 255)
            entity:getComponent("ColorComponent").b = love.math.random(0, 255)
            stack:current().shaketimer = 0.1
            stack:current().translate = 1
        end
    end
end

function UltiUpdateSystem:getRequiredComponents()
    return {"UltiComponent"}
end