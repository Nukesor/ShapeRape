GameOverSystem = class("GameOverSystem", System)

function GameOverSystem:update(dt)
    if stack:current().actionBar < 0 then
        stack:push(GameOverState())
    end
end