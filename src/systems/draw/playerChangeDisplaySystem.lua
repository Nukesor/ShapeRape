PlayerChangeDisplaySystem = class("PlayerChangeDisplaySystem", System)

function PlayerChangeDisplaySystem:__init()
    self.rate = 500
end

function PlayerChangeDisplaySystem:draw()
    for index, entity in pairs(self.targets) do
        particle = entity:get("ParticleComponent").particle
        particle:setEmissionRate(self.rate*entity:get("PlayerChangeCountComponent").count/stack:current().size)
    end
end

function PlayerChangeDisplaySystem:requires()
    return {"PlayerChangeCountComponent"}
end
