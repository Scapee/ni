local UnitClass,
	CreateFrame,
	GetZoneText,
	UnitExists,
	UnitGUID,
	UnitAffectingCombat,
	IsMounted,
	UnitIsUnit,
	UnitCastingInfo,
	UnitChannelInfo,
	GetTime,
	tremove,
	tinsert,
	unpack =
	UnitClass,
	CreateFrame,
	GetZoneText,
	UnitExists,
	UnitGUID,
	UnitAffectingCombat,
	IsMounted,
	UnitIsUnit,
	UnitCastingInfo,
	UnitChannelInfo,
	GetTime,
	tremove,
	tinsert,
	unpack

local _, _class = UnitClass("player")

local lastclick = 0
ni.frames.global = CreateFrame("Frame")
ni.frames.global_OnUpdate = function(self, elapsed)
	if UnitExists == nil or ni.functions.cast == nil or not GetZoneText() then
		return true
	end
	if select(11, ni.player.debuff(9454)) == 9454 then
		return true
	end
	if ni.vars.profiles.enabled then
		ni.rotation.aoEToggle()
		ni.rotation.cdtoggle()
	end
	local throttle = ni.vars.latency / 1000
	self.st = elapsed + (self.st or 0)
	if self.st > throttle then
		self.st = 0
		if ni.vars.units.followEnabled then
			if ni.objectManager.contains(ni.vars.units.follow) or UnitExists(ni.vars.units.follow) then
				local unit = ni.vars.units.follow
				local uGUID = ni.objectManager.objectGUID(unit) or UnitGUID(unit)
				local followTar = nil
				local distance = nil
				if UnitAffectingCombat(uGUID) then
					local oTar = select(6, ni.unit.info(uGUID))
					if oTar ~= nil then
						followTar = oTar
					end
				end
				distance = ni.player.distance(uGUID)
				if not IsMounted() then
					if followTar ~= nil and ni.vars.combat.isMelee == true then
						distance = ni.player.distance(followTar)
						uGUID = followTar
					end
				end
				if followTar ~= nil then
					if not UnitIsUnit("target", followTar) then
						ni.player.target(followTar)
					end
				end
				if not ni.player.isFacing(uGUID) then
					ni.player.lookAt(uGUID)
				end
				if
					not UnitCastingInfo("player") and not UnitChannelInfo("player") and distance ~= nil and distance > 1 and
						distance < 50 and
						GetTime() - lastclick > 1.5
				 then
					ni.player.moveTo(uGUID)
					lastclick = GetTime()
				end
				if distance ~= nil and distance <= 1 and ni.player.isMoving() then
					ni.player.stopMoving()
				end
			end
		end
		if ni.vars.profiles.enabled then
			if not ni.rotation.started then
				ni.rotation.started = true
			end
			if ni.vars.profiles.useEngine then
				ni.members:update()
			end
			if ni.rotation.stopMod() then
				return true
			end
			local count = #ni.spell.queue
			local i = 1
			while i <= count do
				local qRec = tremove(ni.spell.queue, i)
				local func = tremove(qRec, 1)
				local args = tremove(qRec, 1)
				local id, tar = unpack(args)
				ni.info.update(id, true)
				if ni.spell.available(id, true) then
					count = count - 1
					func(id, tar)
				else
					tinsert(ni.spell.queue, i, {func, args})
					i = i + 1
				end
			end
			if #ni.spell.queue == 0 then
				ni.info.update()
			end
			if ni.vars.profiles.active ~= "none" and ni.vars.profiles.active ~= "None" then
				if ni[_class].rotation ~= nil then
					ni[_class].startRotation()
				end
			end
		else
			if ni.rotation.started then
				ni.rotation.started = false
			end
		end
	end
end
