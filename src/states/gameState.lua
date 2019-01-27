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
require("systems/draw/squishyPlayerSystem")

--Events
require("events/playerMoved")
require("events/shapeDestroyEvent")

GameState = class("GameState", State)

function GameState:__init(size, noob)
    self.size = size

    self.bloom = love.graphics.newShader [[
        extern int samples = 6;
        extern float stepSize = 1.9;
        extern vec2 size;

        vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc)
        {
            vec4 source = texture2D(tex, tc);
            vec4 sum = vec4(0);
            int diff = (samples - 1) / 2;

            for (int x = -diff; x <= diff; x++)
            {
                for (int y = -diff; y <= diff; y++)
                {
                    vec2 offset = vec2(x, y) * stepSize / size;
                    sum += texture2D(tex, tc + offset);
                }
            }
            vec4 average = sum / (samples * samples);
            return vec4(average.rgb + source.rgb/2, average.a + source.a);
        }
    ]]
    self.noob = noob or false
end

function GameState:load()
    self.bloom:send("size", {love.graphics.getWidth(), love.graphics.getHeight()})

    self.canvas = love.graphics.newCanvas()

    self.engine = Engine()
    self.eventmanager = EventManager()

    self.score = 0
    self.actionBar = 100
    self.slowmo = 0
    self.activeSlowmo = false

    -- Shake Variablen
    self.nextShake = 1
    self.translate = 10
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
                entity:add(ShapeComponent("circle"))
                entity:add(ColorComponent(56, 69, 255))
                entity:add(DrawableComponent(resources.images.circle, 0, 0.2, 0.2, 0, 0))
            elseif random <= 20 then
                entity:add(ShapeComponent("square"))
                entity:add(ColorComponent(255, 69, 56))
                entity:add(DrawableComponent(resources.images.square, 0, 0.2, 0.2, 0, 0))
            elseif random <= 30 then
                entity:add(ShapeComponent("triangle"))
                entity:add(ColorComponent(69, 255, 56))
                entity:add(DrawableComponent(resources.images.triangle, 0, 0.2, 0.2, 0, 0))
            elseif random <= 31 then
                local random2 = love.math.random(1,2)
                if random2 == 1 then
                    entity:add(ColorComponent(255,255,0))
                    entity:add(DrawableComponent(resources.images.clock, 0, 0.5, 0.5, 0, 0))
                    entity:add(PowerUpComponent("SlowMotion"))
                elseif random2 == 2 then
                    local random3 = love.math.random(1, 3)
                    entity:add(PowerUpComponent("ShapeChange"))
                    local shape
                    if random3 == 1 then
                        shape = "circle"
                        entity:add(DrawableComponent(resources.images.changeCircle, 0, 0.2, 0.2, 0, 0))
                    elseif random3 == 2 then
                        shape = "square"
                        entity:add(DrawableComponent(resources.images.changeSquare, 0, 0.2, 0.2, 0, 0))
                    elseif random3 == 3 then
                        shape = "triangle"
                        entity:add(DrawableComponent(resources.images.changeTriangle, 0, 0.2, 0.2, 0, 0))
                    end
                        entity:add(ShapeComponent(shape))
                        entity:add(ColorComponent(255, 255, 0))
                end
            end
        end
    end
    for x, column in pairs(matrix) do
        for y, node in pairs(matrix[x]) do
            if matrix[x][y-1] then
                node:get("LinkComponent").up = matrix[x][y-1]
            end
            if matrix[x][y+1] then
                node:get("LinkComponent").down = matrix[x][y+1]
            end
            if matrix[x+1] then
                if matrix[x+1][y] then
                    node:get("LinkComponent").right = matrix[x+1][y]
                end
            end
            if matrix[x-1] then
                if matrix[x-1][y] then
                    node:get("LinkComponent").left = matrix[x-1][y]
                end
            end
            self.engine:addEntity(node)
        end
    end
    matrix[1][1]:add(CornerComponent("topleft"))
    matrix[nodesOnScreen][1]:add(CornerComponent("topright"))
    matrix[1][nodesOnScreen]:add(CornerComponent("bottomleft"))
    matrix[nodesOnScreen][nodesOnScreen]:add(CornerComponent("bottomright"))

    -- Player initialization
    matrix[nodesOnScreen/2][nodesOnScreen/2]:remove("ShapeComponent")
    matrix[nodesOnScreen/2][nodesOnScreen/2]:remove("DrawableComponent")
    self.engine:addEntity(PlayerModel(matrix[nodesOnScreen/2][nodesOnScreen/2],self.nodeWidth))

    if not self.noob then
        -- score
        local scoreString = Entity()
        scoreString:add(PositionComponent(love.graphics.getWidth()*8/10, love.graphics.getHeight()*1/20))
        scoreString:add(StringComponent(resources.fonts.CoolFont, {255, 255, 255, 255}, "Score:  %i", {{self, "score"}}))
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

    local squishySystem = SquishyPlayerSystem()
    self.eventmanager:addListener("PlayerMoved", {squishySystem, squishySystem.playerMoved})

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
    local gridDrawSystem = GridDrawSystem()
    self.engine:addSystem(gridDrawSystem, "logic", 10)

    if not self.noob then
        self.engine:addSystem(GameOverSystem(), "logic", 60)
        self.engine:addSystem(ActionBarDisplaySystem(), "draw", 3)
    end

    -- draw systems
    self.engine:addSystem(gridDrawSystem, "draw", 1)
    self.engine:addSystem(StringDrawSystem(), "draw", 2)
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
            self.shakeX = math.random(-self.translate, self.translate)
            self.shakeY = math.random(-self.translate, self.translate)
        end
        self.shaketimer = self.shaketimer - dt
    end

    -- Slowmo stuff
    if self.slowmo > 0 then
        self.slowmo = self.slowmo - dt
        self.engine:update(dt/3)
    else
        self.engine:update(dt)
    end
end

function GameState:draw()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
    -- Screenshake
    if self.shaketimer > 0 then love.graphics.translate(self.shakeX, self.shakeY) end

    self.engine:draw()

    love.graphics.setCanvas()
    love.graphics.clear()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setShader(self.bloom)
    love.graphics.draw(self.canvas)
    love.graphics.setShader()
end

function GameState:keypressed(key, isrepeat)
    self.eventmanager:fireEvent(KeyPressed(key, isrepeat))
end
