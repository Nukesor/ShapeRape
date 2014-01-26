WobbleSystem = class("WobbleSystem", System)


function WobbleSystem:update(dt)
    for index, entity in pairs(self.targets) do
        entity:getComponent("WobbleComponent").value = entity:getComponent("WobbleComponent").value + dt*2 + 4*dt*((100-stack:current().actionBar)/100)
        if entity:getComponent("WobbleComponent").value > 2*math.pi
        	or entity:getComponent("PlayerNodeComponent") == nil then
            entity:getComponent("WobbleComponent").value = 0
        end
    end
end

function WobbleSystem:getRequiredComponents()
    return {"WobbleComponent"}
end