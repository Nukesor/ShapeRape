PauseState = class("PauseState", State)

function PauseState:load()
    self.engine = Engine()
    self.eventmanager = EventManager()

    self.eventmanager:addListener("KeyPressed", {MenuNavigationSystem, MenuNavigationSystem.fireEvent})

    self.menupoints = {{"Resume", function() stack:pop() end},
                        {"Restart", function() stack:popload() end}, 
                        {"Exit Game", function() love.event.quit() end}}
    self.index = 1

    self.engine:addSystem(MenuPointDisplaySystem(), "draw", 1)
end

function PauseState:update()
    self.engine:update()
end

function PauseState:draw()
    self.engine:draw()
end

function PauseState:keypressed(key, isrepeat)
    self.eventmanager:fireEvent(KeyPressed(key, isrepeat))
end