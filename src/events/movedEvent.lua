MovedEvent = class("MovedEvent", Event)

function MovedEvent:__init(direction)
    self.direction = direction
end