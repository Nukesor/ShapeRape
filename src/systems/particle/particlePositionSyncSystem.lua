ParticlePositionSyncSystem = class("ParticlePositionSyncSystem", System)

function ParticlePositionSyncSystem:update()
    for k, entity in pairs(self.targets) do
        entity:getComponent("ParticleComponent").particle:setPosition(entity:getComponent("PositionComponent").x, entity:getComponent("PositionComponent").y)
    end
end

function ParticlePositionSyncSystem:getRequiredComponents()
    return {"ParticleComponent", "PositionComponent"}
end