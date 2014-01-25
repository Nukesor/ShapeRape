AnimateComponent = class("AnimateComponent", Component)

function AnimateComponent:__init(time, subject, target, easing, callback, ...)
	self.time = time
	self.subject = subject
	self.target = target
	self.easing = easing
	self.callback = callback
	self.callbackArgs = arg
	self.tweenID = nil
end