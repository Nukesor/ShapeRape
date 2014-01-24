PlayerControlSystem = class("PlayerControlSystem", System)

function PlayerControlSystem.fireEvent(self, event)
    local player = table.firstElement(self.targets)
    local container = player:getComponent("PlayerNodeComponent").node
    if event.key == "left" or event.key == "a" then
        player:getComponent("PlayerNodeComponent").node = container:getComponent("LinkComponent").left
    elseif event.key == "right" or event.key == "d" then
        player:getComponent("PlayerNodeComponent").node = container:getComponent("LinkComponent").right
    elseif event.key == "up" or event.key == "w" then
        player:getComponent("PlayerNodeComponent").node = container:getComponent("LinkComponent").up
    elseif event.key == "down" or event.key == "s" then
        player:getComponent("PlayerNodeComponent").node = container:getComponent("LinkComponent").down
    end
end

function PlayerControlSystem:getRequiredComponents()
    return {"PlayerNodeComponent"}
end