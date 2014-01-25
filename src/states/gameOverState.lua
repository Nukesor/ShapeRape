GameOverState = class("GameOverState", State)

function GameOverState:load()
    self.engine = Engine()
    self.eventmanager = EventManager()

    self.eventmanager:addListener("KeyPressed", {MenuNavigationSystem, MenuNavigationSystem.fireEvent})

    self.menupoints = {{"Restart", function() stack:popload() end}, 
                        {"Exit Game", function() love.event.quit() end}}
    self.index = 1

    local screenWidth = love.graphics.getWidth()
    for index, item in pairs(self.menupoints) do
        item.x = (screenWidth/3)
        item.y = -100
        item.targetX = item.x
        item.targetY = 200 + (100 * index)
    end
    
    local menuPointDisplaySystem = MenuPointDisplaySystem()
    self.engine:addSystem(menuPointDisplaySystem, "draw", 1)
    self.engine:addSystem(menuPointDisplaySystem, "logic", 1)
end

function GameOverState:update(dt)
    self.engine:update(dt)
end

function GameOverState:draw()
    self.engine:draw()
end

function GameOverState:keypressed(key, isrepeat)
    self.eventmanager:fireEvent(KeyPressed(key, isrepeat))
end