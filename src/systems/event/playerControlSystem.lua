PlayerControlSystem = class("PlayerControlSystem", System)

function PlayerControlSystem.fireEvent(self, event)
    AudioCircle = love.audio.newSource("data/audio/pling.wav", "static")
    AudioRectangle = love.audio.newSource("data/audio/pling-lo.wav", "static")
    AudioTriangle = love.audio.newSource("data/audio/pling-hi.wav", "static")
    AudioTriangle:setVolume(0.9) -- 90% of ordinary volume
    AudioCircle:setVolume(0.9) -- 90% of ordinary volume
    AudioRectangle:setVolume(0.9) -- 90% of ordinary volume

    local player = table.firstElement(self.targets)
    local keymap = {
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

    if keymap[event.key] then
        if keymap[event.key] == "pause" then
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
            local targetNode = playerNode.node:getComponent("LinkComponent")[keymap[event.key]]
            --Sound Yeay
            if targetNode then
                if targetNode:getComponent("CircleComponent") then
                    AudioCircle:play()
                end
                if targetNode:getComponent("RectangleComponent") then
                    AudioRectangle:play()
                end
                if targetNode:getComponent("TriangleComponent") then
                    AudioTriangle:play()
                end

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