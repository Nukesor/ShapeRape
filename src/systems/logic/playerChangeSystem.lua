PlayerChangeSystem = class("PlayerChangeSystem", System)

function PlayerChangeSystem:playerMoved(event)
    
    local player = table.firstElement(stack:current().engine:getEntityList("PlayerNodeComponent"))
    currentShape = player:getComponent("ShapeComponent").shape
    
    if player:getComponent("PlayerChangeCountComponent").count > stack:current().size-1 then
        stack:current().shaketimer = 0.2

        player:getComponent("PlayerChangeCountComponent").count = 0
        
        if  currentShape == "circle" then
            nextShape = "square"
        elseif currentShape == "square" then
            nextShape = "triangle"
        else
            nextShape = "circle"
        end
        player:getComponent("ShapeComponent").shape = nextShape
        player:getComponent("ParticleComponent").particle:setImage(resources.images[nextShape])
        player:getComponent("DrawableComponent").image = resources.images[nextShape]
    end  
end