NodeModel = class("NodeModel", Entity)

function NodeModel:__init(x, y, direction, node)
    self:addComponent(PositionComponent(x, y))
    self:addComponent(LinkComponent())
    if direction and node then
        self:getComponent("LinkComponent")[direction] = node
    end
    self:addComponent(WobbleComponent())
end
