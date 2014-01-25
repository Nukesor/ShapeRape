GameOverSystem = class("GameOverSystem", System)

function GameOverSystem:update(dt)
    if stack:current().actionBar < 0 then
        save:saveHighscore(stack:current().score)
        stack:push(GameOverState())
    end
end