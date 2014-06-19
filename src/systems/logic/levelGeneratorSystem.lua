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
    local goingnode = table.firstElement(stack:current().engine:getEntityList("PlayerNodeComponent")):get("PlayerNodeComponent").node
    while goingnode:get("LinkComponent")[direction] do
        count = count + 1
        goingnode = goingnode:get("LinkComponent")[direction]
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
        if entity:get("CornerComponent").corner == string then
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
    local position = {corner:get("PositionComponent").x, corner:get("PositionComponent").y}
    local newposition = table.add(position, self.stepDistances[direction])
    local added = NodeModel(newposition[1], newposition[2], counterdirection, corner)
    corner:get("LinkComponent")[direction] = added
    stack:current().engine:addEntity(added)
    while added do
        position = {added:get("PositionComponent").x, added:get("PositionComponent").y}
        if corner:get("LinkComponent")[frontlink] then
            newposition = table.add(position, self.stepDistances[frontlink])
            added:get("LinkComponent")[frontlink] = NodeModel(newposition[1], newposition[2], backlink, added)
            stack:current().engine:addEntity(added:get("LinkComponent")[frontlink])

            local random = love.math.random(0, 120)
            local entity = added:get("LinkComponent")[frontlink]
            if random <= 20 then
                entity:add(ShapeComponent("circle"))
                entity:add(ColorComponent(56, 69, 255))
                entity:add(DrawableComponent(resources.images.circle, 0, 0.2, 0.2, 0, 0))
            elseif random <= 40 then
                entity:add(ShapeComponent("square"))
                entity:add(ColorComponent(255, 69, 56))
                entity:add(DrawableComponent(resources.images.square, 0, 0.2, 0.2, 0, 0))
            elseif random <= 60 then
                entity:add(ShapeComponent("triangle"))
                entity:add(ColorComponent(69, 255, 56))
                entity:add(DrawableComponent(resources.images.triangle, 0, 0.2, 0.2, 0, 0))
            elseif random <= 63 then
                local random2 = love.math.random(1,3)
                if random2 == 1 then
                    entity:add(ColorComponent(255,255,0))
                    entity:add(DrawableComponent(resources.images.clock, 0, 0.5, 0.5, 0, 0))
                    entity:add(PowerUpComponent("SlowMotion"))
                elseif random2 == 2 then
                    local random3 = love.math.random(1, 3)
                    entity:add(PowerUpComponent("ShapeChange"))
                    local shape
                    if random3 == 1 then
                        shape = "circle"
                        entity:add(DrawableComponent(resources.images.changeCircle, 0, 0.2, 0.2, 0, 0))
                    elseif random3 == 2 then
                        shape = "square"
                        entity:add(DrawableComponent(resources.images.changeSquare, 0, 0.2, 0.2, 0, 0))
                    elseif random3 == 3 then
                        shape = "triangle"
                        entity:add(DrawableComponent(resources.images.changeTriangle, 0, 0.2, 0.2, 0, 0))
                    end
                        entity:add(ShapeComponent(shape))
                        entity:add(ColorComponent(255, 255, 0))
                elseif random2 ==3 then
                    local random3 = love.math.random(1, 3)
                    if random3 == 1 then
                        shape = "circle"
                        entity:add(DrawableComponent(resources.images.bombCircle, 0, 0.2, 0.2, 0, 0))
                    elseif random3 == 2 then
                        shape = "square"
                        entity:add(DrawableComponent(resources.images.bombSquare, 0, 0.2, 0.2, 0, 0))
                    elseif random3 == 3 then
                        shape = "triangle"
                        entity:add(DrawableComponent(resources.images.bombTriangle, 0, 0.2, 0.2, 0, 0))
                    end
                    entity:add(PowerUpComponent("DestroyShapes"))
                    entity:add(ShapeComponent(shape))
                    entity:add(ColorComponent(255, 255, 0))
                end
            end 
        end
        added:get("LinkComponent")[counterdirection] = corner
        corner:get("LinkComponent")[direction] = added
        if corner:get("LinkComponent")[frontlink] then
            added = added:get("LinkComponent")[frontlink]
            corner = corner:get("LinkComponent")[frontlink]
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
        local corner = entity:get("CornerComponent")
        entity:get("LinkComponent")[direction]:add(corner)
        entity:remove("CornerComponent")
    end
end

function LevelGeneratorSystem:shiftNodes(direction)
    for index, entity in pairs(stack:current().engine:getEntityList("LinkComponent")) do
        if direction == "right" then
            entity:get("PositionComponent").x = entity:get("PositionComponent").x - stack:current().nodeWidth
        elseif direction == "left" then
            entity:get("PositionComponent").x = entity:get("PositionComponent").x + stack:current().nodeWidth
        elseif direction == "up" then
            entity:get("PositionComponent").y = entity:get("PositionComponent").y + stack:current().nodeWidth
        elseif direction == "down" then
            entity:get("PositionComponent").y = entity:get("PositionComponent").y - stack:current().nodeWidth
        end
    end
    local moveComponent = table.firstElement(stack:current().engine:getEntityList("AnimatedMoveComponent"))
        :get("AnimatedMoveComponent")
    moveComponent.targetX = moveComponent.targetNode:get("PositionComponent").x
    moveComponent.targetY = moveComponent.targetNode:get("PositionComponent").y
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

    local oldcorner = corner:get("LinkComponent")[counterdirection]
    while oldcorner do
        stack:current().engine:removeEntity(oldcorner)
        oldcorner:get("LinkComponent")[direction]:get("LinkComponent")[counterdirection] = nil
        oldcorner = oldcorner:get("LinkComponent")[frontlink]
    end
end
function LevelGeneratorSystem:requires()
    return {"CornerComponent"}
end

