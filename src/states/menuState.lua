require("systems/menu/menuNavigationSystem")
require("systems/menu/menuPointDisplaySystem")

MenuState = class("MenuState", State)

function MenuState:load()
    self.engine = Engine()
    self.eventmanager = EventManager()

    self.eventmanager:addListener("KeyPressed", {MenuNavigationSystem, MenuNavigationSystem.fireEvent})

    self.menupoints = {{"Start Game", function() stack:push(GameState()) end}, 
                        {"Highscore", function() end},
                        {"Exit Game", function() love.event.quit() end}}
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
