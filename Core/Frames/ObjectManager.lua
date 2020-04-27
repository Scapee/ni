local CreateFrame, GetFramerate, rawset = CreateFrame, GetFramerate, rawset

ni.frames.ObjectManager = CreateFrame("frame")
ni.frames.ObjectManager_OnUpdate = function(self, elapsed)
	if ni.objects ~= nil and ni.functions.GetOM ~= nil then
		local throttle = 1 / GetFramerate()
		self.st = elapsed + (self.st or 0)
		if self.st > throttle then
			self.st = 0
			local tmp = ni.objectManager.Get()
			for i = 1, #tmp do
				local ob = ni.objectSetup:New(tmp[i].guid, tmp[i].type, tmp[i].name)
				if ob then
					rawset(ni.objects, tmp[i].guid, ob)
				end
			end
			ni.objects:UpdateObjects()
		end
	end
end
