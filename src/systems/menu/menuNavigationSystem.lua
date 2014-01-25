MenuNavigationSystem = class("MenuNavigationSystem", System)

function MenuNavigationSystem.fireEvent(self, event)
    local menu = stack:current()
    if event.key == "down" or event.key == "s" then 
        menu.index = menu.index + 1
        if menu.index > #menu.menupoints then
            menu.index = 1
        end
    elseif event.key == "up" or event.key == "w" then
        menu.index = menu.index - 1
        if menu.index < 1 then
            menu.index = #menu.menupoints
        end
    end

    if event.key == "return" then
        menu.menupoints[menu.index][2]()
    end
end