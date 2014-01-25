GameOverState = class("GameOverState", State)

function GameOverState:__init()
    self.engine = Engine()
    self.eventmanager = EventManager()

    self.eventmanager:addListener("KeyPressed", {MenuNavigationSystem, MenuNavigationSystem.fireEvent})

    self.menupoints = {"Start Game", "Highscore", "Exit Game"}
    self.index = 1

    self.engine:addSystem(MenuPointDisplaySystem(), "draw", 1)
end

function GameOverState:update()
    self.engine:update()
end

function GameOverState:draw()
    self.engine:draw()
end

function GameOverState:keypressed(key, isrepeat)
    self.eventmanager:fireEvent(KeyPressed(key, isrepeat))
end