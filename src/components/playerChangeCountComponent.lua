PlayerChangeCountComponent = class("PlayerChangeCountComponent", Component)

function PlayerChangeCountComponent:__init()
    self.count = 0
    self.max = 10
end