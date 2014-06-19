PlayerModel = class("PlayerModel", Entity)

function PlayerModel:__init(start, nodeWidth)
    local scaledsize = (nodeWidth/resources.images.square:getWidth())*0.9

    self:add(PlayerNodeComponent(start))
    self:add(ShapeComponent("circle"))
    self:add(DrawableComponent(resources.images.circle, 0, scaledsize, scaledsize, 0, 0))
    self:add(ParticleComponent(resources.images.circle, 500))
    self:add(PlayerChangeCountComponent())

    local position = self:get("PlayerNodeComponent").node:get("PositionComponent")
    self:add(PositionComponent(position.x, position.y))
    selfColor = ColorComponent(255, 0, 0)
    self:add(selfColor)
    local particle = self:get("ParticleComponent").particle
    particle:setEmissionRate(100)
    particle:setSpeed(40, 80)
    particle:setSizes(0.03, 0.04)
    particle:setColors(255, 0, 0, 255,
                        0, 255, 0, 255, 
                        0, 0, 255, 0)
    particle:setEmitterLifetime(-1) -- Zeit die der Partikelstrahl anhält
    particle:setParticleLifetime(0.2, 1.2) -- setzt Lebenszeit in min-max
    particle:setDirection(0)
    particle:setSpread(360)
    particle:setRadialAcceleration(20, 30)
    particle:setPosition(position.x+nodeWidth/2, position.y+nodeWidth/2)
    particle:start()
end