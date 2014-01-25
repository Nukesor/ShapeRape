PauseState = class("PauseState", State)

function PauseState:__init(screenshot)
    self.screenshot = screenshot
    self.menupoints = {{"Resume", function() stack:pop() end},
                    {"Restart", function() stack:popload() end}, 
                    {"Exit Game", function() love.event.quit() end}}
end

function PauseState:load()
    self.engine = Engine()
    self.eventmanager = EventManager()

    local screenWidth = love.graphics.getWidth()

    for index, item in pairs(self.menupoints) do
        item.x = (screenWidth/3)
        item.y = -100
        item.targetX = item.x
        item.targetY = 200 + (100 * index)
    end

    self.eventmanager:addListener("KeyPressed", {MenuNavigationSystem, MenuNavigationSystem.fireEvent})

    self.index = 1

    local menuPointDisplaySystem = MenuPointDisplaySystem()
    self.engine:addSystem(menuPointDisplaySystem, "draw", 1)
    self.engine:addSystem(menuPointDisplaySystem, "logic", 1)
end

function PauseState:update(dt)
    self.engine:update(dt)
end

function PauseState:draw()
    love.graphics.setColor(255, 255, 255, 100)
    love.graphics.draw(self.screenshot, 0, 0)
    self.engine:draw()
end

function PauseState:keypressed(key, isrepeat)
    self.eventmanager:fireEvent(KeyPressed(key, isrepeat))
end