WobbleComponent = class("WobbleComponent", Component)

function WobbleComponent:__init()
    self.value = love.math.random(0, (2*math.pi))
end