GameOverSystem = class("GameOverSystem", System)

function GameOverSystem:update(dt)
    stack:current().actionBar = stack:current().actionBar - dt*8
    if stack:current().actionBar < 0 then
        save:saveHighscore(stack:current().score)
        stack:push(GameOverState())
    end
end