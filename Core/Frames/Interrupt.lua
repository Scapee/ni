local GetFramerate, CreateFrame = GetFramerate, CreateFrame

ni.frames.interrupt = CreateFrame("frame")
ni.frames.interrupt_OnUpdate = function(self, elapsed)
	if ni.vars.profiles.interrupt then
		local throttle = 1 / GetFramerate()
		self.st = elapsed + (self.st or 0)
		if self.st > throttle then
			self.st = 0
			if ni.spell.shouldInterrupt("target") then
				ni.spell.castInterrupt("target")
				return true
			end
			if ni.spell.shouldInterrupt("focus") then
				ni.spell.castInterrupt("focus")
				return true
			end
		end
	end
end
