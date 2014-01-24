require("lib/lua-lovetoys/lovetoys/engine")

require("helper/tables")
require("helper/math")

require("events/mousePressed")
require("events/keyPressed")

require("core/stackhelper")
require("core/state")
require("core/resources")

function love.load()
    resources = Resources()

    stack = Stack()
    
end


function love.update(dt)

end

function love.draw()

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
