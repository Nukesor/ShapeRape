PlayerControlSystem = class("PlayerControlSystem", System)

function PlayerControlSystem.fireEvent(event)
    if event.key == "left" or event.key == "a" then

    elseif event.key == "right" or event.key == "d" then

    elseif event.key == "up" or event.key == "w" then

    elseif event.key == "down" or event.key == "s" then

    end
end