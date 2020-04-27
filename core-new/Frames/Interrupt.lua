local GetFramerate, CreateFrame = GetFramerate, CreateFrame

ni.frames.Interrupt = CreateFrame("frame")
ni.frames.Interrupt_OnUpdate = function(self, elapsed)
	if ni.vars.profiles.interrupt then
		local throttle = 1 / GetFramerate()
		self.st = elapsed + (self.st or 0)
		if self.st > throttle then
			self.st = 0
			if ni.spell.ShouldInterrupt("target") then
				ni.spell.CastInterrupt("target")
				return true
			end
			if ni.spell.ShouldInterrupt("focus") then
				ni.spell.CastInterrupt("focus")
				return true
			end
		end
	end
end
