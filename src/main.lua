-- Main Library
require("lib/lua-lovetoys/lovetoys/engine")
-- Helper
require("helper/tables")
require("helper/math")
-- All Events
require("events/mousePressed")
require("events/keyPressed")
-- Core Stuff
require("core/stackhelper")
require("core/state")
require("core/resources")
require("core/save")
-- States
require("states/menuState")
require("states/gameState")
require("states/gameOverState")


function love.load()
    resources = Resources()

    resources:addFont("CoolFont", "data/font/Audiowide-Regular.ttf", 20)

    resources:addImage("triangle", "data/img/triangle.png")
    resources:addImage("circle", "data/img/circle.png")
    resources:addImage("square", "data/img/square.png")
    
    resources:addSound("pling", "data/audio/pling.wav", "static")
    resources:addSound("pling-lo", "data/audio/pling-lo.wav", "static")
    resources:addSound("pling-hi", "data/audio/pling-hi.wav", "static")

    resources:load()

    love.graphics.setFont(resources.fonts.CoolFont)

    save = Save()
    stack = StackHelper()
    stack:push(MenuState())
end


function love.update(dt)
    stack:current():update(dt)
end

function love.draw()
    stack:current():draw()
end 

function love.keypressed(key, isrepeat)
    stack:current():keypressed(key, isrepeat)
end

function love.keyreleased(key, isrepeat)
    stack:current():keyreleased(key, isrepeat)
end

function love.mousepressed(x, y, button)
    stack:current():mousepressed(x, y, button)
end
