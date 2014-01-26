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
require("components/ultiComponent")

-- NodeStuffComponents
require("components/node/cornerComponent")
require("components/node/linkComponent")
require("components/node/colorComponent")
require("components/node/shapeComponent")
require("components/node/powerUpComponent")
require("components/wobbleComponent")
-- ParticleComponents
require("components/particle/particleComponent")
require("components/particle/particleTimerComponent")

-- Models
require("models/nodeModel")
require("models/playerModel")

--Systems
-- Logic
require("systems/logic/levelGeneratorSystem")
require("systems/logic/animatedMoveSystem")
require("systems/logic/gameOverSystem")
require("systems/logic/playerChangeSystem")
require("systems/logic/animateSystem")
require("systems/logic/randomRotationSystem")
require("systems/logic/wobbleSystem")
require("systems/logic/playerColorSystem")
require("systems/logic/ultiUpdateSystem")

-- Particles
require("systems/particle/particleDrawSystem")
require("systems/particle/particleUpdateSystem")
require("systems/particle/particlePositionSyncSystem")

-- Draw
require("systems/draw/drawSystem")
require("systems/draw/gridDrawSystem")
require("systems/draw/stringDrawSystem")
require("systems/draw/actionBarDisplaySystem")
require("systems/draw/playerChangeDisplaySystem")

--Event
require("systems/event/playerControlSystem")
require("systems/event/shapeDestroySystem")

--Events
require("events/playerMoved")
require("events/shapeDestroyEvent")

GameState = class("GameState", State)

function GameState:__init(size, noob)
    self.size = size
    self.noob = noob or false
end

function GameState:load()
    self.engine = Engine()
    self.eventmanager = EventManager()

    self.score = 0
    self.actionBar = 100
    self.slowmo = 0
    self.activeSlowmo = false

    -- Shake Variablen
    self.nextShake = 1
    self.shakeX = 0
    self.shakeY = 0
    self.shaketimer = 0

    local matrix = {}
    local nodesOnScreen = self.size

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
            elseif random <= 31 then
                entity:addComponent(ColorComponent(255,255,0))
                entity:addComponent(DrawableComponent(resources.images.clock, 0, 0.5, 0.5, 0, 0))
                entity:addComponent(PowerUpComponent("SlowMotion"))
            elseif random <= 32 then
                local random2 = love.math.random(0, 100)
                entity:addComponent(PowerUpComponent("ShapeChange"))
                local shape
                if random2 <= 33 then
                    shape = "circle"
                elseif random2 <= 66 then
                    shape = "square"
                elseif random2 <= 100 then
                    shape = "triangle"
                end
                    entity:addComponent(ShapeComponent(shape))
                    entity:addComponent(ColorComponent(255, 141, 0))
                    entity:addComponent(DrawableComponent(resources.images[shape], 0, 0.2, 0.2, 0, 0))
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

    if not self.noob then
        -- score
        local scoreString = Entity()
        scoreString:addComponent(PositionComponent(love.graphics.getWidth()*8/10, love.graphics.getHeight()*1/20))
        scoreString:addComponent(StringComponent(resources.fonts.CoolFont, {255, 255, 255, 255}, "Score:  %i", {{self, "score"}}))
        self.engine:addEntity(scoreString)
    end

    -- Eventsystems
    local playercontrol = PlayerControlSystem()
    local levelgenerator = LevelGeneratorSystem()
    local shapedestroy = ShapeDestroySystem()
    self.eventmanager:addListener("PlayerMoved", {levelgenerator, levelgenerator.fireEvent})
    self.eventmanager:addListener("KeyPressed", {playercontrol, playercontrol.fireEvent})
    self.eventmanager:addListener("ShapeDestroyEvent", {shapedestroy, shapedestroy.fireEvent})

    self.engine:addSystem(shapedestroy)
    self.engine:addSystem(levelgenerator)

    local playerChangeSystem = PlayerChangeSystem()
    self.eventmanager:addListener("PlayerMoved", {playerChangeSystem, playerChangeSystem.playerMoved})

    -- logic systems
    self.engine:addSystem(ParticleUpdateSystem(), "logic", 1)
    self.engine:addSystem(AnimatedMoveSystem(), "logic", 2)
    self.engine:addSystem(ParticlePositionSyncSystem(), "logic", 3)
    self.engine:addSystem(AnimateSystem(), "logic", 4)
    self.engine:addSystem(playercontrol,"logic", 5)
    self.engine:addSystem(RandomRotationSystem(), "logic", 6)
    self.engine:addSystem(WobbleSystem(), "logic", 7)
    self.engine:addSystem(PlayerColorSystem(), "logic", 8)
    self.engine:addSystem(UltiUpdateSystem(), "logic", 9)

    if not self.noob then
        self.engine:addSystem(GameOverSystem(), "logic", 60)
    end

    -- draw systems
    self.engine:addSystem(GridDrawSystem(), "draw", 1)
    self.engine:addSystem(StringDrawSystem(), "draw", 2)
    self.engine:addSystem(ActionBarDisplaySystem(), "draw", 3)
    self.engine:addSystem(ParticleDrawSystem(), "draw", 4)
    self.engine:addSystem(DrawSystem(), "draw", 5)
    self.engine:addSystem(PlayerChangeDisplaySystem(), "draw", 6)
end

function GameState:update(dt)
    self.score = self.score + dt*100

    -- Camerashake
    if self.shaketimer > 0 then
        self.nextShake = self.nextShake - (dt*50)
        if self.nextShake < 0 then
            self.nextShake = 1
            self.shakeX = math.random(-10, 10)
            self.shakeY = math.random(-10, 10)
        end
        self.shaketimer = self.shaketimer - dt
    end

    -- Slowmo stuff
    if self.slowmo > 0 then
        self.slowmo = self.slowmo - dt
        self.engine:update(dt/2)
    else
        self.engine:update(dt)
    end
end

function GameState:draw()
    -- Screenshake
    if self.shaketimer > 0 then love.graphics.translate(self.shakeX, self.shakeY) end

    self.engine:draw()
end

function GameState:keypressed(key, isrepeat)
    self.eventmanager:fireEvent(KeyPressed(key, isrepeat))
end