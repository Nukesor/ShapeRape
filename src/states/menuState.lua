require("systems/menu/menuNavigationSystem")
require("systems/menu/menuPointDisplaySystem")

MenuState = class("MenuState", State)

function MenuState:__init()
    self.engine = Engine()
    self.eventmanager = EventManager()

    self.eventmanager:addListener("KeyPressed", {MenuNavigationSystem, MenuNavigationSystem.fireEvent})

    self.menupoints = {"Start Game", "Highscore", "Exit Game"}
    self.index = 1

    self.engine:addSystem(MenuPointDisplaySystem(), "draw", 1)
end

function MenuState:update(dt)
    self.engine:update()
end


function MenuState:draw()
    self.engine:draw()
end


function MenuState:keypressed(key, isrepeat)
    self.eventmanager:fireEvent(KeyPressed(key, isrepeat))
end
