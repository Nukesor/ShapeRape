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
    self.moveKeymap = {
        left = "left",
        a = "left",
        right = "right",
        d = "right",
        up = "up",
        w = "up",
        down = "down",
        s = "down",
        }   
    self.holdcounter = 0
    self.pressed = nil
end

function PlayerControlSystem.fireEvent(self, event)

    if self.keymap[event.key] then
        self.holdcounter = 1
    end

    local player = table.firstElement(self.targets)

    if self.keymap[event.key] then
        if self.keymap[event.key] == "pause" then
            local canvas = love.graphics.newScreenshot()
            local screenshot = love.graphics.newImage(canvas)
            stack:push(PauseState(screenshot))
        else
            local moveComp = player:getComponent("AnimatedMoveComponent")
            local playerNode = player:getComponent("PlayerNodeComponent")
        end

        if moveComp then
            tween.stopAll()
            local pos = player:getComponent("PositionComponent")
            pos.x = moveComp.targetX
            pos.y = moveComp.targetY
            playerNode.node = moveComp.targetNode
        end
    end
    if self.moveKeymap[event.key] then
        self.pressed = event.key
    end
end

function PlayerControlSystem:getRequiredComponents()
    return {"PlayerNodeComponent"}
end

function PlayerControlSystem:update(dt)
    if self.pressed then
        self.holdcounter = self.holdcounter + dt
        if self.holdcounter > 0.1337 then
            local player = table.firstElement(self.targets)
            local moveComp = player:getComponent("AnimatedMoveComponent")
            local playerNode = player:getComponent("PlayerNodeComponent")
        
            if moveComp then
                tween.stopAll()
                local pos = player:getComponent("PositionComponent")
                pos.x = moveComp.targetX
                pos.y = moveComp.targetY
                playerNode.node = moveComp.targetNode
            end
            local keydown
            if love.keyboard.isDown(self.pressed) then
                keydown = self.moveKeymap[self.pressed]
            else
                self.pressed = nil
            end
        
            local targetNode = playerNode.node:getComponent("LinkComponent")[keydown]
    
            local playerWillMove = false
    
            if targetNode and targetNode:getComponent("ShapeComponent") == nil then 
                playerWillMove = true
            elseif targetNode and targetNode:getComponent("ShapeComponent").shape == player:getComponent("ShapeComponent").shape then
                playerWillMove = true
                local countComp = player:getComponent("PlayerChangeCountComponent")
                countComp.count = countComp.count + 1
                stack:current().actionBar = stack:current().actionBar + 5
                if stack:current().actionBar > 100 then stack:current().actionBar = 100 end
    
                if targetNode:getComponent("ShapeComponent").shape=="circle" then
                    resources.sounds.pling:rewind()
                    resources.sounds.pling:play()
                end
                if targetNode:getComponent("ShapeComponent").shape=="square" then
                    resources.sounds.plinglo:rewind()
                    resources.sounds.plinglo:play()
                end
                if targetNode:getComponent("ShapeComponent").shape=="triangle" then
                    resources.sounds.plinghi:rewind()
                    resources.sounds.plinghi:play()
                end
            end
            if playerWillMove then                
                targetNode:removeComponent("ShapeComponent")
                targetNode:removeComponent("DrawableComponent")
                local targetPosition = targetNode:getComponent("PositionComponent")
                local origin = playerNode.node:getComponent("PositionComponent")
                player:addComponent(AnimatedMoveComponent(targetPosition.x, targetPosition.y, origin.x, origin.y, targetNode))            
                stack:current().eventmanager:fireEvent(PlayerMoved(playerNode.node, targetNode, self.keymap[keydown]))        
            end
            self.holdcounter = 0
        end
    end  
end 