PlayerChangeSystem = class("PlayerChangeSystem", System)

function PlayerChangeSystem:playerMoved(event)

    local player = table.firstElement(stack:current().engine:getEntityList("PlayerNodeComponent"))
    currentShape = player:get("ShapeComponent").shape

    if player:get("PlayerChangeCountComponent").count > stack:current().size-1 then
        stack:current().shaketimer = 0.4
        stack:current().translate = 10


        stack:current().actionBar = stack:current().actionBar + 10
        if stack:current().actionBar > 100 then
            stack:current().actionBar = 100
        end

        player:get("PlayerChangeCountComponent").count = 0
        player:get("PlayerChangeCountComponent").ulti = player:get("PlayerChangeCountComponent").ulti + 1
        if player:get("PlayerChangeCountComponent").ulti > 3 then
            player:add(UltiComponent())
            player:get("PlayerChangeCountComponent").ulti = 0
        end

        if  currentShape == "circle" then
            nextShape = "square"
        elseif currentShape == "square" then
            nextShape = "triangle"
        else
            nextShape = "circle"
        end
        resources.sounds.plinglo:seek(0)
        resources.sounds.plinglo:play()
        resources.sounds.plinglo:seek(0)
        resources.sounds.plinglo:play()
        resources.sounds.plinglo:seek(0)
        resources.sounds.plinglo:play()

        player:get("ShapeComponent").shape = nextShape
        player:get("ParticleComponent").particle:setTexture(resources.images[nextShape])
        player:get("DrawableComponent").image = resources.images[nextShape]

        local position = player:get("PositionComponent")

        local nodeWidth = stack:current().nodeWidth/2

        entity = Entity()

        entity:add(ParticleTimerComponent(0.6, 0.6))
        entity:add(ParticleComponent(resources.images[nextShape], 400))
        entity:add(position)

        local particle = entity:get("ParticleComponent").particle
        particle:setEmissionRate(400)
        particle:setSpeed(100, 200)
        particle:setSizes(0.05, 0.05)
        particle:setColors(255, 255, 255, 255,
                            255, 255, 0, 255,
                            100, 150, 0, 255,
                            0, 200, 150, 155)
        particle:setPosition(position.x+nodeWidth, position.y+nodeWidth)
        particle:setEmitterLifetime(0.6) -- Zeit die der Partikelstrahl anhält
        particle:setParticleLifetime(0.5, 0.6) -- setzt Lebenszeit in min-max
        -- particle:setOffset(x, y) -- Punkt um den der Partikel rotiert
        particle:setRotation(0, 360) -- Der Rotationswert des Partikels bei seiner Erstellung
        particle:setDirection(0)
        particle:setSpread(360)
        particle:setRadialAcceleration(-50, -50)
        particle:start()

        stack:current().engine:addEntity(entity)
    end
end
