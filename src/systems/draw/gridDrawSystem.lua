GridDrawSystem = class("GridDrawSystem", System)

function GridDrawSystem:__init()
    self.time = 0
    self.flash = love.graphics.newShader [[
        extern float time;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
            return vec4(1.0, 1.0, 1.0, 0.2+0.2*(sin(time)/5.0));
        }
    ]]
end

function GridDrawSystem:draw()
    if true then return nil end
    local topleftX = self:getCornerNode("topleft"):getComponent("PositionComponent").x
    local toprightX = self:getCornerNode("topright"):getComponent("PositionComponent").x

    local nodeWidth = stack:current().nodeWidth
    -- previous
    --local nodeWidth = self:getCornerNode("topleft"):getComponent("LinkComponent").right
        --:getComponent("PositionComponent").x - topleftX

    local gridWidth = toprightX + nodeWidth - topleftX

    local topleftY = self:getCornerNode("topleft"):getComponent("PositionComponent").y
    local bottomleftY = self:getCornerNode("bottomleft"):getComponent("PositionComponent").y
    local gridHeight = bottomleftY + nodeWidth - topleftY

    love.graphics.setColor(255,255,255, 50)
    -- love.graphics.setLineStyle("rough")

    love.graphics.setShader(self.flash)

    --draw Vertical Lines
    local currentNode = self:getCornerNode("topleft"):getComponent("LinkComponent").right

    while currentNode do
        local x = currentNode:getComponent("PositionComponent").x
        local y = currentNode:getComponent("PositionComponent").y
        -- love.graphics.line(x, y, x, y+gridHeight)
        love.graphics.rectangle("fill", x, y, nodeWidth, gridHeight)
        currentNode = currentNode:getComponent("LinkComponent").right
        if currentNode then currentNode = currentNode:getComponent("LinkComponent").right end
    end
    --draw Horizontal Lines
    local currentNode = self:getCornerNode("topleft"):getComponent("LinkComponent").down

    while currentNode do
        local x = currentNode:getComponent("PositionComponent").x
        local y = currentNode:getComponent("PositionComponent").y
        -- love.graphics.line(x, y, x+gridWidth, y)
        love.graphics.rectangle("fill", x, y, gridWidth, nodeWidth)
        currentNode = currentNode:getComponent("LinkComponent").down
        if currentNode then currentNode = currentNode:getComponent("LinkComponent").down end
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
        if node:getComponent("CornerComponent").corner == id then
            return node
        end
    end
end
