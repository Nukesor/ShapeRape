PlayerControlSystem = class("PlayerControlSystem", System)

function PlayerControlSystem.fireEvent(self, event)
    local player = table.firstElement(self.targets)
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

    if keymap[event.key] then
        local moveComp = player:getComponent("AnimatedMoveComponent")
        local playerNode = player:getComponent("PlayerNodeComponent")

        if moveComp then
            local pos = player:getComponent("PositionComponent")
            pos.x = moveComp.targetX
            pos.y = moveComp.targetY
            playerNode.node = moveComp.targetNode
        end
        local targetNode = playerNode.node:getComponent("LinkComponent")[keymap[event.key]]
        if targetNode then
            local targetPosition = targetNode:getComponent("PositionComponent")
            player:addComponent(AnimatedMoveComponent(targetPosition.x, targetPosition.y, targetNode))
        end
    end
end

function PlayerControlSystem:getRequiredComponents()
    return {"PlayerNodeComponent"}
end