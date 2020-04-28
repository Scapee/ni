local GetRuneCooldown, GetRuneType, GetTime = GetRuneCooldown, GetRuneType, GetTime

ni.rune = {
	available = function()
		local s, d, i = GetRuneCooldown()

		if i == true then
			return 0
		end

		if s ~= 0 then
			return s + d - GetTime()
		else
			return 0
		end
	end,
	cd = function(rune)
		local runesOnCd = 0
		local runesOffCd = 0

		for i = 1, 6 do
			if GetRuneType(i) == rune and select(3, GetRuneCooldown(i)) == false then
				runesOnCd = runesOnCd + 1
			elseif GetRuneType(i) == rune and select(3, GetRuneCooldown(i)) == true then
				runesOffCd = runesOffCd + 1
			end
		end
		return runesOnCd, runesOffCd
	end,
	deathrunecd = function()
		return ni.rune.cd(4)
	end,
	frostrunecd = function()
		return ni.rune.cd(2)
	end,
	unholyrunecd = function()
		return ni.rune.cd(3)
	end,
	bloodrunecd = function()
		return ni.rune.cd(1)
	end
}
