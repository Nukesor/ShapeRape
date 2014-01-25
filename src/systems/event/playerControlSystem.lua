PlayerControlSystem = class("PlayerControlSystem", System)

function PlayerControlSystem.fireEvent(self, event)
    local player = table.firstElement(self.targets)
    local container = player:getComponent("PlayerNodeComponent").node
    local keymap = {
        left = "left",
        a = "left",
        right = "right",
        d = "right",
        up = "up",
        w = "up",
        down = "down",
        s = "down"
    }

    if keymap[event.key] and player:getComponent("AnimatedMoveComponent") == nil then
        local targetNode = container:getComponent("LinkComponent")[keymap[event.key]]
        if targetNode then
            local targetPosition = targetNode:getComponent("PositionComponent")
            player:addComponent(AnimatedMoveComponent(targetPosition.x, targetPosition.y, targetNode))
        end
    end
end

function PlayerControlSystem:getRequiredComponents()
    return {"PlayerNodeComponent"}
end