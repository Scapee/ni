--9 - Core.lua
local version = "1.0.0";
local GetFramerate = GetFramerate;
local _, _class = UnitClass("player");
ni.ie = CreateFrame('frame');
ni.ie:SetScript('OnUpdate', function(self, elapsed)
	if ni.vars.profiles.interrupt then
		local throttle = 1/GetFramerate();
		self.st = elapsed + (self.st or 0);
		if self.st > throttle then
			self.st = 0;
			if ni.spell.shouldweinterrupt('target') then ni.spell.castinterrupt('target'); return true; end;
			if ni.spell.shouldweinterrupt('focus') then ni.spell.castinterrupt('focus'); return true; end;
		end
	end
end);
local lastclick = 0;
ni.onupdate = CreateFrame('Frame');
ni.onupdate:SetScript('OnUpdate', function(self, elapsed)
	if UnitExists == nil or ni.functions.cast == nil or not GetZoneText() then
		return true
	end
	if select(11,ni.unit.debuff('player', 9454)) == 9454 then return true end
	if ni.vars.profiles.enabled then
		ni.rotation.AoEtoggle()
		ni.rotation.CDtoggle()
	end
	local throttle = ni.vars.latency/1000
	self.st = elapsed + (self.st or 0)
	if self.st > throttle then
		self.st = 0
		if ni.vars.units.followEnabled then
			if ni.om.contains(ni.vars.units.follow) or UnitExists(ni.vars.units.follow) then
				local unit = ni.vars.units.follow;
				local uGUID = ni.om.oGUID(unit) or UnitGUID(unit);
				local followTar = nil;
				local distance = nil;
				if UnitAffectingCombat(uGUID) then
					local oTar = select(6, ni.unit.info(uGUID));
					if oTar ~= nil then
						followTar = oTar;
					end
				end
				distance = ni.player.distance(uGUID);
				if not IsMounted() then
					if followTar ~= nil and ni.vars.IsMelee == true then
						distance = ni.player.distance(followTar)
						uGUID = followTar
					end
				end
				if followTar ~= nil then
					if not UnitIsUnit('target', followTar) then
						ni.player.target(followTar)
					end
				end
				if not ni.player.isfacing(uGUID) then
					ni.player.lookat(uGUID);
				end
				if not UnitCastingInfo('player') and not UnitChannelInfo('player') and distance ~= nil and distance > 1 and distance < 50 and GetTime() - lastclick > 1.5 then
					ni.player.moveto(uGUID);
					lastclick = GetTime();
				end
				if distance ~= nil and distance <= 1 and ni.player.ismoving() then
					ni.player.stopmoving()
				end
			end
		end
		if ni.vars.profiles.enabled then
			if not ni.vars.RotationStarted then
				ni.vars.RotationStarted = true;
			end
			if ni.vars.profiles.useEngine then
			   ni.members:Update()
			end
			if ni.player.stopmod() then
				return true
			end
			local count = #ni.spell.spellqueue;
			local i = 1;
			while i <= count do
				local qRec = tremove(ni.spell.spellqueue,i);
				local func = tremove(qRec, 1);
				local args = tremove(qRec, 1);
				local id, tar = unpack(args);
				ni.Info.update(id, true);
				if ni.spell.available(id, true) then
					count = count - 1;
					func(id, tar);
				else
					tinsert(ni.spell.spellqueue, i, {func, args});
					i = i + 1;
				end
			end
			if #ni.spell.spellqueue == 0 then
				ni.Info.update();
			end
			if ni.vars.profiles.active ~= 'none' and ni.vars.profiles.active ~= 'None' then
				if ni[_class].rotation ~= nil then
					ni[_class].rotation();
				end
			end
		else
			if ni.vars.RotationStarted then
				ni.vars.RotationStarted = false;
			end
		end
	end
end);
ni.FloatingText:Message("Loaded");