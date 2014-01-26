GameOverSystem = class("GameOverSystem", System)

function GameOverSystem:update(dt)
    local player = table.firstElement(self.targets)
    if not player then
        stack:current().actionBar = stack:current().actionBar - dt*10 
    end
    if stack:current().actionBar < 0 then
        save:saveHighscore(stack:current().score)
        stack:push(GameOverState())
    end
end

function GameOverSystem:getRequiredComponents()
    return {"UltiComponent"}
end