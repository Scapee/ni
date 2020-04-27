local getRuneCooldown, getRuneType, getTime = getRuneCooldown, getRuneType, getTime

ni.rune = {
	available = function()
		local s, d, i = getRuneCooldown()

		if i == true then
			return 0
		end

		if s ~= 0 then
			return s + d - getTime()
		else
			return 0
		end
	end,
	cd = function(rune)
		local runesOnCd = 0
		local runesOffCd = 0

		for i = 1, 6 do
			if getRuneType(i) == rune and select(3, getRuneCooldown(i)) == false then
				runesOnCd = runesOnCd + 1
			elseif getRuneType(i) == rune and select(3, getRuneCooldown(i)) == true then
				runesOffCd = runesOffCd + 1
			end
		end
		return runesOnCd, runesOffCd
	end,
	deathRuneCd = function()
		return ni.rune.cd(4)
	end,
	frostRuneCd = function()
		return ni.rune.cd(2)
	end,
	unholyRuneCd = function()
		return ni.rune.cd(3)
	end,
	bloodRuneCd = function()
		return ni.rune.cd(1)
	end
}
