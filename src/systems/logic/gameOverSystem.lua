GameOverSystem = class("GameOverSystem", System)

function GameOverSystem:update(dt)
    if stack:current().actionBar < 0 then
        save:saveHighscore(stack:current().highscore)
        stack:push(GameOverState())
    end
end