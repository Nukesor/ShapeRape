tween = require("lib/tween/tween")

require("states/pauseState")

require("systems/draw/achievementDrawSystem")


require("components/achievementComponent")
require("components/drawableComponent")

AchievementState = class("AchievementState", State)

function AchievementState:load()
    --love.graphics.setBackgroundColor(255,255,18)
    self.index = 1
    self.nodeWidth = 1

    self.engine = Engine()
    self.eventmanager = EventManager()

    self.eventmanager:addListener("KeyPressed", {MenuNavigationSystem, MenuNavigationSystem.fireEvent})

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    self.menupoints = {{"Back to Menu", function() stack:push(MenuState()) end}, 
                        {"Reset Achievements", function() end}}

    local targetX = love.graphics.getWidth()*(3/5)
    local targetY = love.graphics.getHeight()/20

    local x = love.graphics.getWidth() + 100
    local y = targetY

    for index, item in pairs(self.menupoints) do
        item.x = screenWidth/5
        item.y = -100
        item.targetX = item.x
        item.targetY = (2/5)*screenHeight + (80 * index)
    end

    for index, value in pairs(achievement.achievements) do
        local achievementEntity = Entity()
        local targetY = targetY*index +love.graphics.getHeight()*1/10
        local positionComponent = PositionComponent(x, targetY)
        --love.graphics.setColor(255, 255, 255)
        achievementEntity:addComponent(positionComponent)
        achievementEntity:addComponent(AnimateComponent((0.2*index), positionComponent, {x = targetX, y = targetY}, "inOutQuad"))
        if value == 0 then
            achievementEntity:addComponent(DrawableComponent(resources.images.circle, 0, 0.2, 0.2, 0, 0))
            achievementEntity:addComponent(ColorComponent(255,0,0))
        
        elseif value == 1 then
            achievementEntity:addComponent(DrawableComponent(resources.images.triangle, 0, 1, 1, 0, 0))
        elseif value == 2 then
            achievementEntity:addComponent(DrawableComponent(resources.images.circle, 0, 1, 1, 0, 0))
        end

        achievementEntity:addComponent(AchievementComponent())
        self.engine:addEntity(achievementEntity)
    end

    local AchievementCaption = Entity()
    positionComponent = PositionComponent(x, y)
    AchievementCaption:addComponent(positionComponent)
    AchievementCaption:addComponent(AnimateComponent(2, positionComponent, {x = targetX, y = targetY}, "inOutQuad"))
    AchievementCaption:addComponent(StringComponent(resources.fonts.CoolFont40, {255,255,255,255}, "You have Unlocked", {}))
    self.engine:addEntity(AchievementCaption)

    local menuPointDisplaySystem = MenuPointDisplaySystem()
    self.engine:addSystem(menuPointDisplaySystem, "draw", 4)
    self.engine:addSystem(menuPointDisplaySystem, "logic", 2)
    self.engine:addSystem(AnimateSystem(), "logic", 3)
    self.engine:addSystem(StringDrawSystem(), "draw", 3)
    self.engine:addSystem(AchievementDrawSystem(), "draw", 5)

end

function AchievementState:update(dt)
    self.engine:update(dt)
end

function AchievementState:draw()
    self.engine:draw()
end

function AchievementState:keypressed(key, isrepeat)
    self.eventmanager:fireEvent(KeyPressed(key, isrepeat))
end