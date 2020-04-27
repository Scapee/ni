local unitHealth, getTime, unitIsDeadOrGhost, unitHealthMax = unitHealth, getTime, unitIsDeadOrGhost, unitHealthMax

ni.ttd = {
	calculate = function(o)
		if (o:unit() or o:player()) and o:canAttack() and not unitIsDeadOrGhost(o.guid) and o:combat() then
			if o.timeincombat == nil then
				o.timeincombat = getTime()
			end

			local currenthp = unitHealth(o.guid)
			local maxhp = unitHealthMax(o.guid)
			local diff = maxhp - currenthp
			local duration = getTime() - o.timeincombat
			local _dps = diff / duration
			local death = 0

			if _dps ~= 0 then
				death = math.max(0, currenthp) / _dps
			else
				death = 0
			end
			o.dps = math.floor(_dps)

			if death == math.huge then
				o.ttd = -1
			elseif death < 0 then
				o.ttd = 0
			else
				o.ttd = death
			end
			if maxhp - currenthp == 0 then
				o.ttd = -1
			end
		end
	end
}
