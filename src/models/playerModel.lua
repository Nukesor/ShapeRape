PlayerModel = class("PlayerModel", Entity)

function PlayerModel:__init(start, nodeWidth)
    local scaledsize = (nodeWidth/resources.images.square:getWidth())*0.9

    self:addComponent(PlayerNodeComponent(start))
    self:addComponent(ShapeComponent("circle"))
    self:addComponent(DrawableComponent(resources.images.circle, 0, scaledsize, scaledsize, 0, 0))
    self:addComponent(ParticleComponent(resources.images.circle, 500))
    self:addComponent(PlayerChangeCountComponent())

    local position = self:getComponent("PlayerNodeComponent").node:getComponent("PositionComponent")
    self:addComponent(PositionComponent(position.x, position.y))
    selfColor = ColorComponent(255, 0, 0)
    self:addComponent(selfColor)
    local particle = self:getComponent("ParticleComponent").particle
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