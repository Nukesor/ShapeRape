PlayerControlSystem = class("PlayerControlSystem", System)

function PlayerControlSystem:__init()
    self.keymap = {
        left = "left",
        a = "left",
        right = "right",
        d = "right",
        up = "up",
        w = "up",
        down = "down",
        s = "down",
        escape = "pause",
        p = "pause"
    }
end

function PlayerControlSystem.fireEvent(self, event)
    local player = table.firstElement(self.targets)

    if self.keymap[event.key] then
        if self.keymap[event.key] == "pause" then
            local canvas = love.graphics.newScreenshot()
            local screenshot = love.graphics.newImage(canvas)
            stack:push(PauseState(screenshot))
        else
            local moveComp = player:getComponent("AnimatedMoveComponent")
            local playerNode = player:getComponent("PlayerNodeComponent")

        if moveComp then
            tween.stopAll()
            local pos = player:getComponent("PositionComponent")
            pos.x = moveComp.targetX
            pos.y = moveComp.targetY
            playerNode.node = moveComp.targetNode
        end

        local targetNode = playerNode.node:getComponent("LinkComponent")[self.keymap[event.key]]
        local playerWillMove = false
        if targetNode and targetNode:getComponent("ShapeComponent") == nil then playerWillMove = true
        elseif targetNode and targetNode:getComponent("ShapeComponent").shape == player:getComponent("ShapeComponent").shape then
            playerWillMove = true
            local countComp = player:getComponent("PlayerChangeCountComponent")
            countComp.count = countComp.count + 1
            if targetNode:getComponent("ShapeComponent").shape=="circle" then
                resources.sounds.pling:play()
            end
            if targetNode:getComponent("ShapeComponent").shape=="square" then
                resources.sounds.plinglo:play()
            end
            if targetNode:getComponent("ShapeComponent").shape=="triangle" then
                resources.sounds.plinghi:play()
            end
        end
        if playerWillMove then                
                targetNode:removeComponent("ShapeComponent")
                targetNode:removeComponent("DrawableComponent")
                local targetPosition = targetNode:getComponent("PositionComponent")
                local origin = playerNode.node:getComponent("PositionComponent")
                player:addComponent(AnimatedMoveComponent(targetPosition.x, targetPosition.y, origin.x, origin.y, targetNode))

                stack:current().eventmanager:fireEvent(PlayerMoved(playerNode.node, targetNode))
            end
        end
    end
end

function PlayerControlSystem:getRequiredComponents()
    return {"PlayerNodeComponent"}
end