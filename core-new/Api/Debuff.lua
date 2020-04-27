ni.debuff = {
	HasType = function(t, str)
		if not ni.unit.Exists(t) then
			return false
		end

		local st = ni.utils.SplitStringToLower(str)
		local has = false
		local i = 1
		local debuff = UnitDebuff(t, i)

		while debuff do
			local debuffType = select(5, UnitDebuff(t, i))

			if debuffType ~= nil then
				local dTlwr = string.lower(debuffType)
				if tContains(st, dTlwr) then
					has = true
					break
				end
			end

			i = i + 1
			debuff = UnitDebuff(t, i)
		end

		return has
	end,
	Has = function(t, spellID, caster, exact)
		exact = exact and true or false
		local spellName = ""

		if tonumber(spellID) ~= nil then
			spellName = GetSpellInfo(spellID)
		else
			spellName = spellID
			spellID = nil
		end

		if spellName == "" or spellName == nil then
			return
		end
		if
			caster == nil and
				((spellID and exact and select(11, UnitDebuff(t, spellName)) == spellID) or
					((not spellID or exact == false) and UnitDebuff(t, spellName)))
		 then
			return UnitDebuff(t, spellName)
		elseif
			caster ~= nil and
				((spellID and exact and select(11, UnitDebuff(t, spellName, nil, caster)) == spellID) or
					((not spellID or exact == false) and UnitDebuff(t, spellName, nil, caster)))
		 then
			return UnitDebuff(t, spellName, nil, caster)
		end
	end,
	HasMany = function(t, spellIDs, caster, exact)
		local ands = ni.utils.FindAnd(spellIDs)
		local results = false

		if ands ~= nil or (ands == nil and string.len(spellIDs) > 0) then
			local tmp

			if ands then
				tmp = ni.utils.SplitStringByDelimiter(spellIDs, "&&")

				for i = 0, #tmp do
					if tmp[i] ~= nil then
						local id = tonumber(tmp[i])
						if id ~= nil then
							if not ni.debuff.Has(t, id, caster, exact) then
								results = false
								break
							else
								results = true
							end
						else
							if not ni.debuff.Has(t, tmp[i], caster, exact) then
								results = false
								break
							else
								results = true
							end
						end
					end
				end
			else
				tmp = ni.utils.SplitStringByDelimiter(spellIDs, "||")
				for i = 0, #tmp do
					local id = tonumber(tmp[i])
					if id ~= nil then
						if ni.debuff.Has(t, id, caster, exact) then
							results = true
							break
						end
					else
						if ni.debuff.Has(t, tmp[i], caster, exact) then
							results = true
							break
						end
					end
				end
			end
		end

		return results
	end
}
