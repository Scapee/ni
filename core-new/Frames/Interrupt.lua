local GetFramerate = GetFramerate

ni.frames.InterruptFrame = CreateFrame("frame")
ni.frames.InterruptFrame_OnUpdate = function(self, elapsed)
	if ni.vars.profiles.interrupt then
		local throttle = 1 / GetFramerate()
		self.st = elapsed + (self.st or 0)
		if self.st > throttle then
			self.st = 0
			if ni.spell.shouldweinterrupt("target") then
				ni.spell.castinterrupt("target")
				return true
			end
			if ni.spell.shouldweinterrupt("focus") then
				ni.spell.castinterrupt("focus")
				return true
			end
		end
	end
end
