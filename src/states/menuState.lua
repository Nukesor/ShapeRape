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

    self.highScore = 0

    local highScore = Entity()
    local targetX = love.graphics.getWidth()*(3/5)
    local targetY = love.graphics.getHeight()/6

    local x = love.graphics.getWidth() + 100
    local y = targetY

    local positionComponent = PositionComponent(x, y)
    highScore:addComponent(positionComponent)
    highScore:addComponent(AnimateComponent(1, positionComponent, {x = targetX, y = targetY}, "outQuad"))
    highScore:addComponent(StringComponent(resources.fonts.CoolFont100, {255, 255, 255, 255}, "%i", {{self, "highScore"}}))
    self.engine:addEntity(highScore)

    local highDescriptor = Entity()
    positionComponent = PositionComponent(x, y+100)
    highDescriptor:addComponent(positionComponent)
    highDescriptor:addComponent(AnimateComponent(2, positionComponent, {x = targetX+20, y = targetY + 100}, "inOutQuad"))
    highDescriptor:addComponent(StringComponent(resources.fonts.CoolFont40, {255,255,255,255}, "high", {}))
    self.engine:addEntity(highDescriptor)

    self.index = 1

    local menuPointDisplaySystem = MenuPointDisplaySystem()
    self.engine:addSystem(menuPointDisplaySystem, "draw", 1)
    self.engine:addSystem(menuPointDisplaySystem, "logic", 1)
    self.engine:addSystem(AnimateSystem(), "logic", 2)
    self.engine:addSystem(StringDrawSystem(), "draw", 2)

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
