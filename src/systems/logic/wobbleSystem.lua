WobbleSystem = class("WobbleSystem", System)


function WobbleSystem:update(dt)
    for index, entity in pairs(self.targets) do
        entity:get("WobbleComponent").value = entity:get("WobbleComponent").value + dt*2 + 4*dt*((100-stack:current().actionBar)/100)
        if entity:get("WobbleComponent").value > 2*math.pi
        	or entity:get("PlayerNodeComponent") == nil then
            entity:get("WobbleComponent").value = 0
        end
    end
end

function WobbleSystem:requires()
    return {"WobbleComponent"}
end