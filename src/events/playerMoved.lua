PlayerMoved = class("PlayerMoved")

function PlayerMoved:__init(origin, target)
	self.origin = origin
	self.target = target
end