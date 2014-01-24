NodeModel = class("NodeModel", Entity)

function NodeModel:__init(x, y)
    self:addComponent(PositionComponent(x, y))
    self:addComponent(LinkComponent())
end
