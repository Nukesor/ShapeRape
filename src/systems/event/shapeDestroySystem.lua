ShapeDestroySystem = class("ShapeDestroySystem", System)

function ShapeDestroySystem:fireEvent(event)
    local bomb = false
    for index, entity in pairs(self.targets) do
        bomb = true
        if entity:get("ShapeComponent").shape == event.shape then
            entity:remove("ShapeComponent")
            entity:remove("DrawableComponent")
            entity:remove("ColorComponent")
            if entity:get("PowerUpComponent") then
                entity:remove("PowerUpComponent")
            end

            local nodeWidth = stack:current().nodeWidth/2
            local position = entity:get("PositionComponent")
            explosion = Entity()

            explosion:add(ParticleTimerComponent(0.6, 0.6))
            explosion:add(ParticleComponent(resources.images[event.shape], 400))
            explosion:add(position)

            local radius = 100/nodeWidth
            local particle = explosion:get("ParticleComponent").particle
            particle:setEmissionRate(400)
            particle:setSpeed((radius*50), (radius*3))
            particle:setSizes(0.1, 0.1)
            particle:setColors(255, 255, 255, 255,
                                255, 255, 0, 255,
                                200, 0, 0, 255,
                                255, 100, 0, 10)
            particle:setPosition(position.x+nodeWidth, position.y+nodeWidth)
            particle:setEmitterLifetime(0.6) -- Zeit die der Partikelstrahl anhält
            particle:setParticleLifetime(0.5, 0.6) -- setzt Lebenszeit in min-max
            -- particle:setOffset(x, y) -- Punkt um den der Partikel rotiert
            particle:setRotation(0, 360) -- Der Rotationswert des Partikels bei seiner Erstellung
            particle:setDirection(0)
            particle:setSpread(360)
            particle:setRadialAcceleration((radius*-7.5), (radius*-7.5))
            particle:start()
            stack:current().engine:addEntity(explosion)
        end
    end
    if bomb then
        stack:current().shaketimer = 0.5
        stack:current().translate = 10
    end
end

function ShapeDestroySystem:requires()
    return {"ShapeComponent", "LinkComponent"}
end