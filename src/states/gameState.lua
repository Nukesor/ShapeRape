tween = require("lib/tween/tween")

require("states/pauseState")

-- Components
require("components/positionComponent")
require("components/playerNodeComponent")
require("components/drawableComponent")
require("components/animatedMoveComponent")
require("components/stringComponent")
require("components/playerChangeCountComponent")
require("components/animateComponent")

-- NodeStuffComponents
require("components/node/cornerComponent")
require("components/node/linkComponent")
require("components/node/colorComponent")
require("components/node/shapeComponent")
-- ParticleComponents
require("components/particle/particleComponent")
require("components/particle/particleTimerComponent")

-- Models
require("models/nodeModel")
require("models/playerModel")

--Systems
-- Logic
require("systems/event/playerControlSystem")
require("systems/logic/levelGeneratorSystem")
require("systems/logic/animatedMoveSystem")
require("systems/logic/gameOverSystem")
require("systems/logic/playerChangeSystem")
require("systems/logic/keyDownSystem")
require("systems/logic/animateSystem")

-- Particles
require("systems/particle/particleDrawSystem")
require("systems/particle/particleUpdateSystem")
require("systems/particle/particlePositionSyncSystem")

-- Draw
require("systems/draw/drawSystem")
require("systems/draw/gridDrawSystem")
require("systems/draw/stringDrawSystem")
require("systems/draw/actionBarDisplaySystem")

--Events
require("events/playerMoved")

GameState = class("GameState", State)

function GameState:load()
    self.engine = Engine()
    self.eventmanager = EventManager()

    self.score = 0
    self.actionBar = 100

    local matrix = {}
    local nodesOnScreen = 10

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    local verticalBorder = 30

    self.nodeWidth = (screenHeight - (verticalBorder * 2)) / nodesOnScreen

    local gridXStart = (screenWidth - (self.nodeWidth * nodesOnScreen)) / 2

    for x = 1, nodesOnScreen, 1 do
        matrix[x] = {}
        for y = 1, nodesOnScreen, 1 do
            matrix[x][y] = NodeModel(gridXStart + ((x-1) * self.nodeWidth), verticalBorder + ((y-1) * self.nodeWidth))
            local random = love.math.random(0, 100)

            local entity = matrix[x][y]
            if random <= 10 then
                entity:addComponent(ShapeComponent("circle"))
                entity:addComponent(ColorComponent(56, 69, 255))
                entity:addComponent(DrawableComponent(resources.images.circle, 0, 0.2, 0.2, 0, 0))
            elseif random <= 20 then
                entity:addComponent(ShapeComponent("square"))
                entity:addComponent(ColorComponent(255, 69, 56))
                entity:addComponent(DrawableComponent(resources.images.square, 0, 0.2, 0.2, 0, 0))
            elseif random <= 30 then
                entity:addComponent(ShapeComponent("triangle"))
                entity:addComponent(ColorComponent(69, 255, 56))
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
    matrix[nodesOnScreen/2][nodesOnScreen/2]:removeComponent("ShapeComponent")
    matrix[nodesOnScreen/2][nodesOnScreen/2]:removeComponent("DrawableComponent")
    self.engine:addEntity(PlayerModel(matrix[nodesOnScreen/2][nodesOnScreen/2],self.nodeWidth))

    -- score
    local scoreString = Entity()
    scoreString:addComponent(PositionComponent(love.graphics.getWidth()*8/10, love.graphics.getHeight()*1/20))
    scoreString:addComponent(StringComponent(resources.fonts.CoolFont, {255, 255, 255, 255}, "Score:  %i", {{self, "score"}}))
    self.engine:addEntity(scoreString)

    -- Eventsystems
    local playercontrol = PlayerControlSystem()
    local levelgenerator = LevelGeneratorSystem()
    self.eventmanager:addListener("KeyPressed", {levelgenerator, levelgenerator.fireEvent})
    self.eventmanager:addListener("KeyPressed", {playercontrol, playercontrol.fireEvent})
    self.eventmanager:addListener("KeyPressed", {KeyDownSystem, KeyDownSystem.fireEvent})

    self.engine:addSystem(levelgenerator)
    self.engine:addSystem(playercontrol)

    local playerChangeSystem = PlayerChangeSystem()
    self.eventmanager:addListener("PlayerMoved", {playerChangeSystem, playerChangeSystem.playerMoved})

    -- logic systems
    self.engine:addSystem(ParticleUpdateSystem(), "logic", 1)
    self.engine:addSystem(AnimatedMoveSystem(), "logic", 2)
    self.engine:addSystem(ParticlePositionSyncSystem(), "logic", 3)
    self.engine:addSystem(GameOverSystem(), "logic", 4)
    self.engine:addSystem(KeyDownSystem(), "logic", 5)

    -- draw systems
    self.engine:addSystem(GridDrawSystem(), "draw", 1)
    self.engine:addSystem(ParticleDrawSystem(), "draw", 2)
    self.engine:addSystem(DrawSystem(), "draw", 3)
    self.engine:addSystem(StringDrawSystem(), "draw", 4)
    self.engine:addSystem(ActionBarDisplaySystem(), "draw", 5)
end

function GameState:update(dt)
    self.score = self.score + dt*100
    self.engine:update(dt)
end

function GameState:draw()
    self.engine:draw()
end

function GameState:keypressed(key, isrepeat)
    self.eventmanager:fireEvent(KeyPressed(key, isrepeat))
end