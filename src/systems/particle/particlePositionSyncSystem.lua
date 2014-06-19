ParticlePositionSyncSystem = class("ParticlePositionSyncSystem", System)

function ParticlePositionSyncSystem:update()
    for k, entity in pairs(self.targets) do
        entity:get("ParticleComponent").particle:setPosition(
        	entity:get("PositionComponent").x + (stack:current().nodeWidth/2), 
        	entity:get("PositionComponent").y + (stack:current().nodeWidth/2))
    end
end

function ParticlePositionSyncSystem:requires()
    return {"ParticleComponent", "PositionComponent"}
end