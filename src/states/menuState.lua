require("systems/menu/menuNavigationSystem")
require("systems/menu/menuPointDisplaySystem")

MenuState = class("MenuState", State)

function MenuState:load()
    self.engine = Engine()
    self.eventmanager = EventManager()

    self.eventmanager:addListener("KeyPressed", {MenuNavigationSystem, MenuNavigationSystem.fireEvent})

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    self.menupoints = {{"Arcade Mode - Small", function() stack:push(GameState(8)) end}, 
                        {"Arcade Mode - Medium", function() stack:push(GameState(12)) end},
                        {"Arcade Mode - Large", function() stack:push(GameState(16)) end},
                        {"Meditation Mode", function() stack:push(GameState(16, true)) end},
                        {"Achievements", function() stack:push(AchievementState()) end},
                        {"Exit", function() love.event.quit() end}}

    for index, item in pairs(self.menupoints) do
        item.x = screenWidth/5
        item.y = -100
        item.targetX = item.x
        item.targetY = (1/5)*screenHeight + (80 * index)
    end

    local targetX = love.graphics.getWidth()*(3/5)
    local targetY = love.graphics.getHeight()/20

    local x = love.graphics.getWidth() + 100
    local y = targetY

    for index, value in pairs(save.highscore) do
        local highScore = Entity()
        local targetY = targetY*index +love.graphics.getHeight()*1/10
        local positionComponent = PositionComponent(x, targetY)
        highScore:addComponent(positionComponent)
        highScore:addComponent(AnimateComponent((0.2*index), positionComponent, {x = targetX, y = targetY}, "inOutQuad"))
        highScore:addComponent(StringComponent(resources.fonts.CoolFont40, {255, 255, 255, 255}, "%i", {{save.highscore, index}}))
        self.engine:addEntity(highScore)
    end
    
    local highDescriptor = Entity()
    positionComponent = PositionComponent(x, y)
    highDescriptor:addComponent(positionComponent)
    highDescriptor:addComponent(AnimateComponent(2, positionComponent, {x = targetX, y = targetY}, "inOutQuad"))
    highDescriptor:addComponent(StringComponent(resources.fonts.CoolFont40, {255,255,255,255}, "Highscores", {}))
    self.engine:addEntity(highDescriptor)

    local title = Entity()
    positionComponent = PositionComponent(-500, 100)
    title:addComponent(positionComponent)
    targetX = 100
    targetY = positionComponent.y
    title:addComponent(AnimateComponent(2, positionComponent, {x = targetX, y = targetY}, "inOutQuad"))
    title:addComponent(StringComponent(resources.fonts.CoolFont100, {255,255,255,255}, "ShapeRape", {}))
    self.engine:addEntity(title)

    self.index = 1

    local menuPointDisplaySystem = MenuPointDisplaySystem()
    self.engine:addSystem(menuPointDisplaySystem, "draw", 1)
    self.engine:addSystem(menuPointDisplaySystem, "logic", 1)
    self.engine:addSystem(AnimateSystem(), "logic", 2)
    self.engine:addSystem(StringDrawSystem(), "draw", 2)

    love.graphics.setBackgroundColor(5,5,18)
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
