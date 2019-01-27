GridDrawSystem = class("GridDrawSystem", System)

function GridDrawSystem:__init()
    self.time = 0
    self.flash = love.graphics.newShader [[
        extern float time;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
            return vec4(1.0, 1.0, 1.0, 0.5+(sin(time)/5.0));
        }   
    ]]
end

function GridDrawSystem:draw()

    local topleftX = self:getCornerNode("topleft"):get("PositionComponent").x
    local toprightX = self:getCornerNode("topright"):get("PositionComponent").x

    local nodeWidth = stack:current().nodeWidth
    -- previous
    --local nodeWidth = self:getCornerNode("topleft"):get("LinkComponent").right
        --:get("PositionComponent").x - topleftX

    local gridWidth = toprightX + nodeWidth - topleftX

    local topleftY = self:getCornerNode("topleft"):get("PositionComponent").y
    local bottomleftY = self:getCornerNode("bottomleft"):get("PositionComponent").y
    local gridHeight = bottomleftY + nodeWidth - topleftY

    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.setLineStyle("rough")

    love.graphics.setShader(self.flash)

    --draw Vertical Lines
    local currentNode = self:getCornerNode("topleft"):get("LinkComponent").right

    while currentNode do 
        local x = currentNode:get("PositionComponent").x
        local y = currentNode:get("PositionComponent").y
        love.graphics.line(x, y, x, y+gridHeight)
        currentNode = currentNode:get("LinkComponent").right
    end
    --draw Horizontal Lines
    local currentNode = self:getCornerNode("topleft"):get("LinkComponent").down

    while currentNode do 
        local x = currentNode:get("PositionComponent").x
        local y = currentNode:get("PositionComponent").y
        love.graphics.line(x, y, x+gridWidth, y)
        currentNode = currentNode:get("LinkComponent").down
    end

    love.graphics.setShader()
end

function GridDrawSystem:update(dt)
    self.time = self.time + (dt*2)
    self.flash:send("time", self.time)
end

function GridDrawSystem:requires()
    return {"CornerComponent", "PositionComponent"}
end

function GridDrawSystem:getCornerNode(id)
    for index, node in pairs(self.targets) do
        if node:get("CornerComponent").corner == id then
            return node
        end
    end
end
