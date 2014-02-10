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

function PlayerControlSystem:requires()
    return {"PlayerNodeComponent"}
end

function PlayerControlSystem:update(dt)
    -- Reset Slowmo because we don't want soggy controls
    if stack:current().slowmo > 0 then
        dt = dt*3
    end
    --self. current = nil
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
        if self.holdcounter > 0.12 then
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
            local direction = nil
            if love.keyboard.isDown(self.current) then
                direction = self.keymap[self.current]
            else
                self.current = nil
            end
            --print(current)
        
            local targetNode = playerNode.node:getComponent("LinkComponent")[direction]
    
            local playerWillMove = false
            
            if targetNode then
                if targetNode:getComponent("ShapeComponent") == nil then 
                    playerWillMove = true
                elseif targetNode and targetNode:getComponent("ShapeComponent").shape == player:getComponent("ShapeComponent").shape and not targetNode:getComponent("PowerUpComponent") then
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
                    local nodeWidth = stack:current().nodeWidth/2
                    local position = targetNode:getComponent("PositionComponent")
                    explosion = Entity()

                    explosion:addComponent(ParticleTimerComponent(0.6, 0.6))
                    explosion:addComponent(ParticleComponent(resources.images[targetNode:getComponent("ShapeComponent").shape], 400))
                    explosion:addComponent(position)

                    local radius = 100/nodeWidth
                    local particle = explosion:getComponent("ParticleComponent").particle
                    particle:setEmissionRate(200)
                    particle:setSpeed((radius*80), (radius*80))
                    particle:setSizes(0.05, 0.05)
                    particle:setColors(255, 255, 255, 255, 255,255,255,0)
                    particle:setPosition(position.x+nodeWidth, position.y+nodeWidth)
                    particle:setEmitterLifetime(0.1) -- Zeit die der Partikelstrahl anhält
                    particle:setParticleLifetime(0.2, 0.3) -- setzt Lebenszeit in min-max
                    -- particle:setOffset(x, y) -- Punkt um den der Partikel rotiert
                    particle:setRotation(0, 360) -- Der Rotationswert des Partikels bei seiner Erstellung
                    particle:setDirection(0)
                    particle:setSpread(360)
                    particle:setRadialAcceleration((radius*-7.5), (radius*-7.5))
                    particle:start()
                    stack:current().engine:addEntity(explosion)
                end
                local powerup = targetNode:getComponent("PowerUpComponent")
                if powerup then
                    if powerup.type == "SlowMotion" then
                        stack:current().slowmo = stack:current().slowmo + 3
                    elseif powerup.type == "ShapeChange" then
                        player:getComponent("ShapeComponent").shape = targetNode:getComponent("ShapeComponent").shape
                        player:getComponent("DrawableComponent").image = resources.images[targetNode:getComponent("ShapeComponent").shape]
                        player:getComponent("PlayerChangeCountComponent").count = 0
                    elseif powerup.type == "DestroyShapes" then
                        stack:current().eventmanager:fireEvent(ShapeDestroyEvent(targetNode:getComponent("ShapeComponent").shape))
                    end
                    targetNode:removeComponent("PowerUpComponent")
                    playerWillMove = true
                end
                if player:getComponent("UltiComponent") then
                    playerWillMove = true
                end
                if playerWillMove then                
                    if targetNode:getComponent("ShapeComponent") then
                        targetNode:removeComponent("ShapeComponent")
                    end
                    if targetNode:getComponent("DrawableComponent") then
                        targetNode:removeComponent("DrawableComponent")
                    end
                    local targetPosition = targetNode:getComponent("PositionComponent")
                    local origin = playerNode.node:getComponent("PositionComponent")
                    player:addComponent(AnimatedMoveComponent(targetPosition.x, targetPosition.y, origin.x, origin.y, targetNode))            
                    stack:current().eventmanager:fireEvent(PlayerMoved(playerNode.node, targetNode, direction))        
                end
            end
            self.holdcounter = 0
        end
    end  
end 