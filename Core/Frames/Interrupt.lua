local GetFramerate, CreateFrame = GetFramerate, CreateFrame

ni.frames.interrupt = CreateFrame("frame")
ni.frames.interrupt_OnUpdate = function(self, elapsed)
	if ni.vars.profiles.interrupt then
		local throttle = 1 / GetFramerate()
		self.st = elapsed + (self.st or 0)
		if self.st > throttle then
			self.st = 0
			if ni.spell.shouldinterrupt("target") then
				ni.spell.castinterrupt("target")
				return true
			end
			if ni.spell.shouldinterrupt("focus") then
				ni.spell.castinterrupt("focus")
				return true
			end
		end
	end
end
