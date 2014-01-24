-- Components
require("components/positionComponent")
require("components/playerNodeComponent")
require("components/drawableComponent")

-- NodeStuffComponents
require("components/node/cornerComponent")
require("components/node/circleComponent")
require("components/node/triangleComponent")
require("components/node/rectangleComponent")
require("components/node/linkComponent")
-- ParticleComponents
require("components/particle/particleComponent")
require("components/particle/particleTimerComponent")

-- Models
require("models/nodeModel")
--Systems
-- Logic
require("systems/event/playerControlSystem")
require("systems/logic/levelGeneratorSystem")
-- Particles
require("systems/particle/particleDrawSystem")
require("systems/particle/particleUpdateSystem")
require("systems/particle/particlePositionSyncSystem")

-- Draw
require("systems/draw/drawSystem")
require("systems/draw/gridDrawSystem")

--Events

GameState = class("GameState", State)

function GameState:__init()
    self.engine = Engine()
    self.eventmanager = EventManager()

    local matrix = {}
    local nodesOnScreen = 10

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local verticalBorder = 30

    local nodeWidth = (screenHeight - (verticalBorder * 2)) / nodesOnScreen

    local gridXStart = (screenWidth - (nodeWidth * nodesOnScreen)) / 2

    for x = 1, nodesOnScreen, 1 do
        matrix[x] = {}
        for y = 1, nodesOnScreen, 1 do
            matrix[x][y] = NodeModel(gridXStart + ((x-1) * nodeWidth), verticalBorder + ((y-1) * nodeWidth))

            local random = love.math.random(0, 100)
            local entity = matrix[x][y]
            if random <= 10 then
                entity:addComponent(CircleComponent())
                entity:addComponent(DrawableComponent(resources.images.circle, 0, 0.2, 0.2, 0, 0))
            elseif random <= 20 then
                entity:addComponent(RectangleComponent())
                entity:addComponent(DrawableComponent(resources.images.rectangle, 0, 0.2, 0.2, 0, 0))
            elseif random <= 30 then
                entity:addComponent(TriangleComponent())
                entity:addComponent(DrawableComponent(resources.images.triangle, 0, 0.2, 0.2, 0, 0))
            end 
        end
    end
    for x, column in pairs(matrix) do
        for y, node in pairs(matrix[x]) do
            if matrix[x][y-1] then
                node:getComponent("LinkComponent").up = matrix[x][y-1]
            end
            if matrix[x][y+1] then
                node:getComponent("LinkComponent").down = matrix[x][y+1]
            end
            if matrix[x+1] then
                if matrix[x+1][y] then
                    node:getComponent("LinkComponent").right = matrix[x+1][y]
                end
            end
            if matrix[x-1] then
                if matrix[x-1][y] then
                    node:getComponent("LinkComponent").left = matrix[x-1][y]
                end
            end
            self.engine:addEntity(node)
        end
    end
    matrix[1][1]:addComponent(CornerComponent("topleft"))
    matrix[nodesOnScreen][1]:addComponent(CornerComponent("topright"))
    matrix[1][nodesOnScreen]:addComponent(CornerComponent("bottomleft"))
    matrix[nodesOnScreen][nodesOnScreen]:addComponent(CornerComponent("bottomright"))

    -- Player initialization
    local player = Entity()
    player:addComponent(PlayerNodeComponent(matrix[nodesOnScreen/2][nodesOnScreen/2]))
    player:addComponent(CircleComponent())
    player:addComponent(DrawableComponent(resources.images.circle, 0, 0.4, 0.4, 0, 0))
    player:addComponent(ParticleComponent(resources.images.circle, 500))

    local position = player:getComponent("PlayerNodeComponent").node:getComponent("PositionComponent")
    player:addComponent(position)
    local particle = player:getComponent("ParticleComponent").particle
    particle:setEmissionRate(50)
    particle:setSpeed(40, 20)
    particle:setSizes(0.03, 0.04)
    particle:setColors(0, 255, 0, 255, 0, 150, 0, 255)
    particle:setPosition(position.x, position.y)
    particle:setEmitterLifetime(-1) -- Zeit die der Partikelstrahl anhält
    particle:setParticleLifetime(0.2, 1) -- setzt Lebenszeit in min-max
    particle:setOffset(0, 0) -- Punkt um den der Partikel rotiert
    particle:setRotation(0, 360) -- Der Rotationswert des Partikels bei seiner Erstellung
    particle:setDirection(0)
    particle:setSpread(360)
    particle:setRadialAcceleration(20, 30)
    particle:setLinearAcceleration(300, 300)
    particle:setAreaSpread( "normal", 5, 5 )
    particle:start()

    self.engine:addEntity(player)

    local playercontrol = PlayerControlSystem()
    self.eventmanager:addListener("KeyPressed", {playercontrol, playercontrol.fireEvent})
    self.eventmanager:addListener("KeyPressed", {LevelGeneratorSystem, LevelGeneratorSystem.fireEvent})
    self.engine:addSystem(playercontrol, "logic", 1)


    -- logic systems
    self.engine:addSystem(ParticleUpdateSystem(), "logic", 1)
    self.engine:addSystem(ParticlePositionSyncSystem(), "logic", 2)

    -- draw systems
    self.engine:addSystem(GridDrawSystem(), "draw", 1)
    self.engine:addSystem(ParticleDrawSystem(), "draw", 2)
    self.engine:addSystem(DrawSystem(), "draw", 3)
end

function GameState:update(dt)
    self.engine:update(dt)
end

function GameState:draw()
    self.engine:draw()
end

function GameState:keypressed(key, isrepeat)
    self.eventmanager:fireEvent(KeyPressed(key, isrepeat))
end