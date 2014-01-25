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
        s = "down"
    }
end

function PlayerControlSystem.fireEvent(self, event)
    AudioCircle = love.audio.newSource("data/audio/pling.wav", "static")
    AudioRectangle = love.audio.newSource("data/audio/pling-lo.wav", "static")
    AudioTriangle = love.audio.newSource("data/audio/pling-hi.wav", "static")
    AudioTriangle:setVolume(0.9) -- 90% of ordinary volume
    AudioCircle:setVolume(0.9) -- 90% of ordinary volume
    AudioRectangle:setVolume(0.9) -- 90% of ordinary volume
    local player = table.firstElement(self.targets)

    if self.keymap[event.key] then
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
        --Sound Yeay
        if targetNode then
            if targetNode:getComponent("CircleComponent") then
                AudioCircle:play()
            end
        end
        if targetNode then
            if targetNode:getComponent("RectangleComponent") then
                AudioRectangle:play()
            end
        end
        if targetNode then
            if targetNode:getComponent("TriangleComponent") then
                AudioTriangle:play()
            end
        end
        if targetNode then
            local targetPosition = targetNode:getComponent("PositionComponent")
            local origin = playerNode.node:getComponent("PositionComponent")
            player:addComponent(AnimatedMoveComponent(targetPosition.x, targetPosition.y, origin.x, origin.y, targetNode))
        end
    end
end

function PlayerControlSystem:getRequiredComponents()
    return {"PlayerNodeComponent"}
end