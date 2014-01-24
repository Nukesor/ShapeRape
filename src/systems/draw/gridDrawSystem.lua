GridDrawSystem = class("GridDrawSystem", System)

function GridDrawSystem:draw()
    local nodeWidth = stack:current().nodeWidth

    local topleftX = self:getCornerNode("topleft"):getComponent("PositionComponent").x
    local toprightX = self:getCornerNode("topright"):getComponent("PositionComponent").x
    --local nodeWidth = self:getCornerNode("topleft"):getComponent("LinkComponent").right
        --:getComponent("PositionComponent").x - topleftX

    local gridWidth = toprightX + nodeWidth - topleftX

    local topleftY = self:getCornerNode("topleft"):getComponent("PositionComponent").y
    local bottomleftY = self:getCornerNode("bottomleft"):getComponent("PositionComponent").y
    local gridHeight = bottomleftY + nodeWidth - topleftY

    love.graphics.setColor(255,255,255)

    --draw Vertical Lines
    local currentNode = self:getCornerNode("topleft"):getComponent("LinkComponent").right

    while currentNode do 
        local x = currentNode:getComponent("PositionComponent").x
        local y = currentNode:getComponent("PositionComponent").y
        love.graphics.line(x, y, x, y+gridHeight)
        currentNode = currentNode:getComponent("LinkComponent").right
    end
    --draw Horizontal Lines
    local currentNode = self:getCornerNode("topleft"):getComponent("LinkComponent").down

    while currentNode do 
        local x = currentNode:getComponent("PositionComponent").x
        local y = currentNode:getComponent("PositionComponent").y
        love.graphics.line(x, y, x+gridWidth, y)
        currentNode = currentNode:getComponent("LinkComponent").down
    end

end

function GridDrawSystem:getRequiredComponents()
    return {"CornerComponent", "PositionComponent"}
end

function GridDrawSystem:getCornerNode(id)
    for index, node in pairs(self.targets) do
        if node:getComponent("CornerComponent").corner == id then
            return node
        end
    end
end
