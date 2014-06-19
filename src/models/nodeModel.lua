NodeModel = class("NodeModel", Entity)

function NodeModel:__init(x, y, direction, node)
    self:add(PositionComponent(x, y))
    self:add(LinkComponent())
    if direction and node then
        self:get("LinkComponent")[direction] = node
    end
    self:add(WobbleComponent())
end
