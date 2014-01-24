-- Components
require("components/linkComponent")
require("components/positionComponent")
require("components/cornerComponent")
require("components/playerNodeComponent")
require("components/drawableComponent")
-- Models
require("models/nodeModel")
--Systems
require("systems/event/playerControlSystem")
require("systems/logic/levelGeneratorSystem")
--Events

GameState = class("GameState2", State)

function GameState:__init()
    self.engine = Engine()
    self.eventmanager = EventManager()

    local matrix = {}
    local width = 10
    local height = 10
    for x = 1, width, 1 do
        matrix[x] = {}
        for y = 1, height, 1 do
            matrix[x][y] = NodeModel(x*10, y*10)
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
    matrix[width][1]:addComponent(CornerComponent("topright"))
    matrix[1][height]:addComponent(CornerComponent("bottomleft"))
    matrix[width][height]:addComponent(CornerComponent("bottomright"))

    local playercontrol = PlayerControlSystem()
    self.eventmanager:addListener("KeyPressed", {playercontrol, playercontrol.fireEvent})
    self.eventmanager:addListener("KeyPressed", {LevelGeneratorSystem, LevelGeneratorSystem.fireEvent})

end

function GameState:update(dt)

end

function GameState:draw()

end

function GameState:keypressed(key, isrepeat)
    self.eventmanager:fireEvent(KeyPressed(key, isrepeat))
end