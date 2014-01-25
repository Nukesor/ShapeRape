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
    self.holdcounter = 0
    self.current = nil
    self.previous = nil
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
    if self.keymap[event.key] then
        self.previous = self.current
        self.current = event.key
    end
end

function PlayerControlSystem:getRequiredComponents()
    return {"PlayerNodeComponent"}
end

function PlayerControlSystem:update(dt)

    if stack:current().activeSlowmo then
        dt = dt*2
    end
    self. current = nil
    for index, key in pairs(self.keymap) do
        --print(love.keyboard.isDown(self.keymap[index]))

        if not self.current then
            if love.keyboard.isDown(self.keymap[index]) then
                self.current = key
            end
        else
            if love.keyboard.isDown(self.keymap[index]) and (self.keymap[index] ~= self.previous) then
                self.previous = self.current
                self.current = key
            end
        end
    end
    --print(self.current)
    --print(self.previous)
    --print("---")

    if self.current then
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
            local direction
            if love.keyboard.isDown(self.current) then
                direction = self.keymap[self.current]
            else
                self.current = nil
                print("WHAT THE FUCK!")
            end
            --print(current)
        
            local targetNode = playerNode.node:getComponent("LinkComponent")[direction]
    
            local playerWillMove = false
    
            if targetNode:getComponent("ShapeComponent") == nil then 
                playerWillMove = true
            elseif targetNode:getComponent("ShapeComponent").shape == player:getComponent("ShapeComponent").shape and not targetNode:getComponent("PowerUpComponent") then
                playerWillMove = true
                local countComp = player:getComponent("PlayerChangeCountComponent")
                countComp.count = countComp.count + 1
                stack:current().actionBar = stack:current().actionBar + 5
                if stack:current().actionBar > 100 then stack:current().actionBar = 100 end
    
                if targetNode:getComponent("ShapeComponent").shape=="circle" then
                    resources.sounds.pling:rewind()
                    resources.sounds.pling:play()
                elseif targetNode:getComponent("ShapeComponent").shape=="square" then
                    resources.sounds.plinglo:rewind()
                    resources.sounds.plinglo:play()
                elseif targetNode:getComponent("ShapeComponent").shape=="triangle" then
                    resources.sounds.plinghi:rewind()
                    resources.sounds.plinghi:play()
                end
            end
            if targetNode:getComponent("PowerUpComponent") then
                if targetNode:getComponent("PowerUpComponent").type == "SlowMotion" then
                    stack:current().slowmo = stack:current().slowmo + 2
                    targetNode:removeComponent("PowerUpComponent")
                elseif targetNode:getComponent("PowerUpComponent").type == "ShapeChange" then
                    player:getComponent("ShapeComponent").shape = targetNode:getComponent("ShapeComponent").shape
                    player:getComponent("DrawableComponent").image = resources.images[targetNode:getComponent("ShapeComponent").shape]
                    targetNode:removeComponent("PowerUpComponent")
                    targetNode:removeComponent("ShapeComponent")
                    targetNode:removeComponent("DrawableComponent")
                end
                playerWillMove = true
            end
            if playerWillMove then                
                targetNode:removeComponent("ShapeComponent")
                targetNode:removeComponent("DrawableComponent")
                local targetPosition = targetNode:getComponent("PositionComponent")
                local origin = playerNode.node:getComponent("PositionComponent")
                player:addComponent(AnimatedMoveComponent(targetPosition.x, targetPosition.y, origin.x, origin.y, targetNode))            
                stack:current().eventmanager:fireEvent(PlayerMoved(playerNode.node, targetNode, direction))        
            end
            self.holdcounter = 0
        end
    end  
end 