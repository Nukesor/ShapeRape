-- Components
require("components/linkComponent")
require("components/positionComponent")
require("components/cornerComponent")
require("components/playerNodeComponent")
require("components/drawableComponent")
require("components/circleComponent")
require("components/triangleComponent")
require("components/rectangleComponent")
-- Models
require("models/nodeModel")
--Systems
require("systems/event/playerControlSystem")
require("systems/logic/levelGeneratorSystem")
require("systems/draw/drawSystem")
require("systems/draw/gridDrawSystem")
--Events

GameState = class("GameState2", State)

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
            local random = math.random(0, 100)
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

    local player = Entity()
    player:addComponent(PlayerNodeComponent(matrix[nodesOnScreen/2][nodesOnScreen/2]))
    self.engine:addEntity(player)

    local playercontrol = PlayerControlSystem()
    self.eventmanager:addListener("KeyPressed", {playercontrol, playercontrol.fireEvent})
    self.eventmanager:addListener("KeyPressed", {LevelGeneratorSystem, LevelGeneratorSystem.fireEvent})
    self.engine:addSystem(playercontrol, "logic", 1)

    self.engine:addSystem(DrawSystem(), "draw", 2)
    self.engine:addSystem(GridDrawSystem(), "draw", 1)
end

function GameState:update(dt)
    self.engine:update()
end

function GameState:draw()
    self.engine:draw()
end

function GameState:keypressed(key, isrepeat)
    self.eventmanager:fireEvent(KeyPressed(key, isrepeat))
end