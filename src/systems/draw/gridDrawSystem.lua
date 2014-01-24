GridDrawSystem = class("GridDrawSystem", System)

function GridDrawSystem:draw()

    local topleftX = self:getCornerNode("topleft"):getComponent("PositionComponent").x
    local toprightX = self:getCornerNode("topright"):getComponent("PositionComponent").x
    local width = toprightX - topleftX

    local topleftY = self:getCornerNode("topleft"):getComponent("PositionComponent").y
    local bottomleftY = self:getCornerNode("bottomleft"):getComponent("PositionComponent").y
    local height = bottomleftY - topleftY

    love.graphics.setColor(255,255,255)

    --draw Vertical Lines
    local currentNode = self:getCornerNode("topleft"):getComponent("LinkComponent").right

    while currentNode:getComponent("LinkComponent").right do 
        local x = currentNode:getComponent("PositionComponent").x
        local y = currentNode:getComponent("PositionComponent").y
        love.graphics.line(x, y, x, y+height)
        currentNode = currentNode:getComponent("LinkComponent").right
    end
    --draw Horizontal Lines
    local currentNode = self:getCornerNode("topleft"):getComponent("LinkComponent").down

    while currentNode:getComponent("LinkComponent").down do 
        local x = currentNode:getComponent("PositionComponent").x
        local y = currentNode:getComponent("PositionComponent").y
        love.graphics.line(x, y, x+width, y)
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
