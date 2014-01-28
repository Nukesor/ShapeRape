GameOverSystem = class("GameOverSystem", System)

function GameOverSystem:__init()
    self.elapsedTime = 7
end

function GameOverSystem:update(dt)
    local player = table.firstElement(self.targets)
    if not player then
        self.elapsedTime = self.elapsedTime + dt*0.1
        stack:current().actionBar = stack:current().actionBar - dt*(self.elapsedTime)
    end
    if stack:current().actionBar < 0 then
        save:saveHighscore(stack:current().score)
        stack:push(GameOverState())
    end
end

function GameOverSystem:getRequiredComponents()
    return {"UltiComponent"}
end