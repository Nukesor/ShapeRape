LevelGeneratorSystem = class("LevelGeneratorSystem", System)

function LevelGeneratorSystem:fireEvent(event)
    if event.key == "left" then
        
    end
end

function LevelGeneratorSystem:getRequiredComponents()
    return {"CornerComponent"}
end