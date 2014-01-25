KeyDownSystem = class("KeyDownSystem", System)

function KeyDownSystem.fireEvent(self, event)

    down = love.keyboard.isDown("up")
    print("up")
end