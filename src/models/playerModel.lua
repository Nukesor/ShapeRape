PlayerModel = class("PlayerModel", Entity)

function PlayerModel:__init(start, nodeWidth)
    local scaledsize = 0.3

    self:addComponent(PlayerNodeComponent(start))
    self:addComponent(CircleComponent())
    self:addComponent(DrawableComponent(resources.images.circle, 0, scaledsize, scaledsize, 0, 0))
    self:addComponent(ParticleComponent(resources.images.circle, 500))

    local position = self:getComponent("PlayerNodeComponent").node:getComponent("PositionComponent")
    self:addComponent(PositionComponent(position.x, position.y))
    local selfColor = ColorComponent(255, 255, 255)
    self:addComponent(selfColor)
    local particle = self:getComponent("ParticleComponent").particle
    particle:setEmissionRate(50)
    particle:setSpeed(40, 80)
    particle:setSizes(0.03, 0.04)
    particle:setColors(selfColor.r, selfColor.g, selfColor.b, 255, selfColor.r, selfColor.g, selfColor.b, 0)
    particle:setEmitterLifetime(-1) -- Zeit die der Partikelstrahl anhält
    particle:setParticleLifetime(0.2, 1) -- setzt Lebenszeit in min-max
    particle:setDirection(0)
    particle:setSpread(360)
    particle:setRadialAcceleration(20, 30)
    particle:start()

end