PlayerMoved = class("PlayerMoved")

function PlayerMoved:__init(origin, target, direction)
	self.origin = origin
	self.target = target
    self.direction = direction
end