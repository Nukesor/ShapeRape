require("systems/menu/menuNavigationSystem")
require("systems/menu/menuPointDisplaySystem")

MenuState = class("MenuState", State)

function MenuState:load()
    self.engine = Engine()
    self.eventmanager = EventManager()

    self.eventmanager:addListener("KeyPressed", {MenuNavigationSystem, MenuNavigationSystem.fireEvent})

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    self.menupoints = {{"Play!", function() stack:push(GameState()) end}, 
                        {"Exit", function() love.event.quit() end}}

    for index, item in pairs(self.menupoints) do
        item.x = screenWidth/5
        item.y = -100
        item.targetX = item.x
        item.targetY = (1/2)*screenHeight + (100 * index)
    end

    self.index = 1

    local menuPointDisplaySystem = MenuPointDisplaySystem()
    self.engine:addSystem(menuPointDisplaySystem, "draw", 1)
    self.engine:addSystem(menuPointDisplaySystem, "logic", 1)

end

function MenuState:update(dt)
    self.engine:update(dt)
end


function MenuState:draw()
    self.engine:draw()
end


function MenuState:keypressed(key, isrepeat)
    self.eventmanager:fireEvent(KeyPressed(key, isrepeat))
end
