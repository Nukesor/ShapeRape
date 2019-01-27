ColorComponent = class("ColorComponent", Component)

function ColorComponent:__init(r, g, b)
	self.r = r/255
	self.g = g/255
	self.b = b/255
end
