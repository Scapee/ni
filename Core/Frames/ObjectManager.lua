local createFrame, getFramerate, rawset = createFrame, getFramerate, rawset

ni.frames.objectManager = createFrame("frame")
ni.frames.objectManager_OnUpdate = function(self, elapsed)
	if ni.objects ~= nil and ni.functions.getOM ~= nil then
		local throttle = 1 / getFramerate()
		self.st = elapsed + (self.st or 0)
		if self.st > throttle then
			self.st = 0
			local tmp = ni.objectManager.get()
			for i = 1, #tmp do
				local ob = ni.objectSetup:new(tmp[i].guid, tmp[i].type, tmp[i].name)
				if ob then
					rawset(ni.objects, tmp[i].guid, ob)
				end
			end
			ni.objects:updateObjects()
		end
	end
end
