local GetRuneCooldown, GetRuneType, GetTime = GetRuneCooldown, GetRuneType, GetTime

ni.rune = {
	Cd = function(rune)
		local s, d, i = GetRuneCooldown(rune)

		if i == true then
			return 0
		end

		if s ~= 0 then
			return s + d - GetTime()
		else
			return 0
		end
	end,
	DeathRuneCd = function()
		local DRunesOnCD = 0
		local DRunesOffCD = 0

		for i = 1, 6 do
			if GetRuneType(i) == 4 and select(3, GetRuneCooldown(i)) == false then
				DRunesOnCD = DRunesOnCD + 1
			elseif GetRuneType(i) == 4 and select(3, GetRuneCooldown(i)) == true then
				DRunesOffCD = DRunesOffCD + 1
			end
		end
		return DRunesOnCD, DRunesOffCD
	end,
	FrostRuneCd = function()
		local FRunesOnCD = 0
		local FRunesOffCD = 0

		for i = 1, 6 do
			if GetRuneType(i) == 2 and select(3, GetRuneCooldown(i)) == false then
				FRunesOnCD = FRunesOnCD + 1
			elseif GetRuneType(i) == 2 and select(3, GetRuneCooldown(i)) == true then
				FRunesOffCD = FRunesOffCD + 1
			end
		end
		return FRunesOnCD, FRunesOffCD
	end,
	UnholyRuneCd = function()
		local URunesOnCD = 0
		local URunesOffCD = 0

		for i = 1, 6 do
			if GetRuneType(i) == 3 and select(3, GetRuneCooldown(i)) == false then
				URunesOnCD = URunesOnCD + 1
			elseif GetRuneType(i) == 3 and select(3, GetRuneCooldown(i)) == true then
				URunesOffCD = URunesOffCD + 1
			end
		end
		return URunesOnCD, URunesOffCD
	end,
	BloodRuneCd = function()
		local BRunesOnCD = 0
		local BRunesOffCD = 0
		for i = 1, 6 do
			if GetRuneType(i) == 1 and select(3, GetRuneCooldown(i)) == false then
				BRunesOnCD = BRunesOnCD + 1
			elseif GetRuneType(i) == 1 and select(3, GetRuneCooldown(i)) == true then
				BRunesOffCD = BRunesOffCD + 1
			end
		end
		return BRunesOnCD, BRunesOffCD
	end
}
