local GetRuneCooldown, GetRuneType, GetTime = GetRuneCooldown, GetRuneType, GetTime

ni.rune = {
	Available = function()
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
	Cd = function(rune)
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
	DeathRuneCd = function()
		return ni.rune.Cd(4)
	end,
	FrostRuneCd = function()
		return ni.rune.Cd(2)
	end,
	UnholyRuneCd = function()
		return ni.rune.Cd(3)
	end,
	BloodRuneCd = function()
		return ni.rune.Cd(1)
	end
}
