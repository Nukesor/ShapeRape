LevelGeneratorSystem = class("LevelGeneratorSystem", System)

function LevelGeneratorSystem:__init()
    self.stepDistances = {
        left = {-stack:current().nodeWidth, 0},
        right = {stack:current().nodeWidth, 0},
        up = {0,  -stack:current().nodeWidth},
        down = {0, stack:current().nodeWidth}
    }
end

function LevelGeneratorSystem:fireEvent(event)
    local direction = event.direction
    local count = 0
    local goingnode = table.firstElement(stack:current().engine:getEntityList("PlayerNodeComponent")):getComponent("PlayerNodeComponent").node
    while goingnode:getComponent("LinkComponent")[direction] do
        count = count + 1
        goingnode = goingnode:getComponent("LinkComponent")[direction]
    end
    if count < 4 then
        local corner
        local othercorner
        if direction == "left" then
            corner = self:getCorner("topleft")
        elseif direction == "right" then
            corner = self:getCorner("topright")
        elseif direction == "up" then
            corner = self:getCorner("topleft")
        elseif direction == "down" then
            corner = self:getCorner("bottomleft")
        end
        self:addRow(corner, direction)
        self:changeCorners(direction)
        self:shiftNodes(direction)
        if direction == "left" then
            othercorner = self:getCorner("topright")
        elseif direction == "right" then
            othercorner = self:getCorner("topleft")
        elseif direction == "up" then
            othercorner = self:getCorner("bottomleft")
        elseif direction == "down" then
            othercorner = self:getCorner("topleft")
        end
        self:removeRow(othercorner, direction)
    end
end

function LevelGeneratorSystem:getCorner(string)
    for index, entity in pairs(self.targets) do
        if entity:getComponent("CornerComponent").corner == string then
            return entity
        end
    end
end

function LevelGeneratorSystem:addRow(corner, direction)
    local counterdirection, frontlink, backlink
    if direction == "right" then
        counterdirection = "left"
        frontlink = "down"
        backlink = "up"
    elseif direction == "left" then
        counterdirection = "right"
        frontlink = "down"
        backlink = "up"
    elseif direction == "up" then
        counterdirection = "down"
        frontlink = "right"
        backlink = "left"
    elseif direction == "down" then
        counterdirection = "up"
        frontlink = "right"
        backlink = "left"
    end
    local position = {corner:getComponent("PositionComponent").x, corner:getComponent("PositionComponent").y}
    local newposition = table.add(position, self.stepDistances[direction])
    local added = NodeModel(newposition[1], newposition[2], counterdirection, corner)
    corner:getComponent("LinkComponent")[direction] = added
    stack:current().engine:addEntity(added)
    while added do
        position = {added:getComponent("PositionComponent").x, added:getComponent("PositionComponent").y}
        if corner:getComponent("LinkComponent")[frontlink] then
            newposition = table.add(position, self.stepDistances[frontlink])
            added:getComponent("LinkComponent")[frontlink] = NodeModel(newposition[1], newposition[2], backlink, added)
            stack:current().engine:addEntity(added:getComponent("LinkComponent")[frontlink])

            local random = love.math.random(0, 120)
            local entity = added:getComponent("LinkComponent")[frontlink]
            if random <= 20 then
                entity:addComponent(ShapeComponent("circle"))
                entity:addComponent(ColorComponent(56, 69, 255))
                entity:addComponent(DrawableComponent(resources.images.circle, 0, 0.2, 0.2, 0, 0))
            elseif random <= 40 then
                entity:addComponent(ShapeComponent("square"))
                entity:addComponent(ColorComponent(255, 69, 56))
                entity:addComponent(DrawableComponent(resources.images.square, 0, 0.2, 0.2, 0, 0))
            elseif random <= 60 then
                entity:addComponent(ShapeComponent("triangle"))
                entity:addComponent(ColorComponent(69, 255, 56))
                entity:addComponent(DrawableComponent(resources.images.triangle, 0, 0.2, 0.2, 0, 0))
            elseif random <= 61 then
                entity:addComponent(ColorComponent(255,255,0))
                entity:addComponent(DrawableComponent(resources.images.clock, 0, 0.5, 0.5, 0, 0))
                entity:addComponent(PowerUpComponent("SlowMotion"))
            elseif random <= 62 then
                local random2 = love.math.random(0, 100)
                entity:addComponent(PowerUpComponent("ShapeChange"))
                local shape
                if random2 <= 33 then
                    shape = "circle"
                elseif random2 <= 66 then
                    shape = "square"
                elseif random2 <= 100 then
                    shape = "triangle"
                end
                    entity:addComponent(ShapeComponent(shape))
                    entity:addComponent(ColorComponent(255, 141, 0))
                    entity:addComponent(DrawableComponent(resources.images[shape], 0, 0.2, 0.2, 0, 0))
            end 
        end
        added:getComponent("LinkComponent")[counterdirection] = corner
        corner:getComponent("LinkComponent")[direction] = added
        if corner:getComponent("LinkComponent")[frontlink] then
            added = added:getComponent("LinkComponent")[frontlink]
            corner = corner:getComponent("LinkComponent")[frontlink]
        else
            added = false
        end
    end
end

function LevelGeneratorSystem:changeCorners(direction)
    local corners = {}
    for i, v in pairs(self.targets) do
        table.insert(corners, v)
    end
    for index, entity in pairs(corners) do
        local corner = entity:getComponent("CornerComponent")
        entity:getComponent("LinkComponent")[direction]:addComponent(corner)
        entity:removeComponent("CornerComponent")
    end
end

function LevelGeneratorSystem:shiftNodes(direction)
    for index, entity in pairs(stack:current().engine:getEntityList("LinkComponent")) do
        if direction == "right" then
            entity:getComponent("PositionComponent").x = entity:getComponent("PositionComponent").x - stack:current().nodeWidth
        elseif direction == "left" then
            entity:getComponent("PositionComponent").x = entity:getComponent("PositionComponent").x + stack:current().nodeWidth
        elseif direction == "up" then
            entity:getComponent("PositionComponent").y = entity:getComponent("PositionComponent").y + stack:current().nodeWidth
        elseif direction == "down" then
            entity:getComponent("PositionComponent").y = entity:getComponent("PositionComponent").y - stack:current().nodeWidth
        end
    end
    local moveComponent = table.firstElement(stack:current().engine:getEntityList("AnimatedMoveComponent"))
        :getComponent("AnimatedMoveComponent")
    moveComponent.targetX = moveComponent.targetNode:getComponent("PositionComponent").x
    moveComponent.targetY = moveComponent.targetNode:getComponent("PositionComponent").y
end

function LevelGeneratorSystem:removeRow(corner, direction)
    local counterdirection, frontlink, backlink
    if direction == "right" then
        counterdirection = "left"
        frontlink = "down"
        backlink = "up"
    elseif direction == "left" then
        counterdirection = "right"
        frontlink = "down"
        backlink = "up"
    elseif direction == "up" then
        counterdirection = "down"
        frontlink = "right"
        backlink = "left"
    elseif direction == "down" then
        counterdirection = "up"
        frontlink = "right"
        backlink = "left"
    end

    local oldcorner = corner:getComponent("LinkComponent")[counterdirection]
    while oldcorner do
        stack:current().engine:removeEntity(oldcorner)
        oldcorner:getComponent("LinkComponent")[direction]:getComponent("LinkComponent")[counterdirection] = nil
        oldcorner = oldcorner:getComponent("LinkComponent")[frontlink]
    end
end
function LevelGeneratorSystem:getRequiredComponents()
    return {"CornerComponent"}
end

