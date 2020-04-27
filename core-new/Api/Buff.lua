ni.buff = {
	HasType = function(t, str)
		if not ni.unit.Exists(t) then
			return false
		end

		local st = ni.utils.SplitStringToLower(str)
		local has = false
		local i = 1
		local buff = UnitBuff(t, i)

		while buff do
			local buffType = select(5, UnitBuff(t, i))
			if buffType ~= nil then
				local bTlwr = string.lower(buffType)
				if tContains(st, bTlwr) then
					has = true
					break
				end
			end
			i = i + 1
			buff = UnitBuff(t, i)
		end

		return has
	end,
	Has = function(t, id, caster, exact)
		exact = exact and true or false

		local spellName = ""

		if tonumber(id) ~= nil then
			spellName = GetSpellInfo(id)
		else
			spellName = id
			id = nil
		end
		if spellName == "" or spellName == nil then
			return
		end
		if
			caster ~= nil and
				((id and exact and select(11, UnitBuff(t, spellName, nil, caster)) == id) or
					((not id or exact == false) and UnitBuff(t, spellName, nil, caster)))
		 then
			return UnitBuff(t, spellName, nil, caster)
		elseif
			caster == nil and
				((id and exact and select(11, UnitBuff(t, spellName)) == id) or
					((not id or exact == false) and UnitBuff(t, spellName)))
		 then
			return UnitBuff(t, spellName)
		end
	end,
	HasMany = function(t, ids, caster, exact)
		local ands = ni.utils.FindAnd(ids)
		local results = false
		if ands ~= nil or (ands == nil and string.len(ids) > 0) then
			local tmp
			if ands then
				tmp = ni.utils.SplitStringByDelimiter(ids, "&&")
				for i = 0, #tmp do
					if tmp[i] ~= nil then
						local id = tonumber(tmp[i])

						if id ~= nil then
							if not ni.buff.Has(t, id, caster, exact) then
								results = false
								break
							else
								results = true
							end
						else
							if not ni.buff.Has(t, tmp[i], caster, exact) then
								results = false
								break
							else
								results = true
							end
						end
					end
				end
			else
				tmp = ni.utils.SplitStringByDelimiter(ids, "||")
				for i = 0, #tmp do
					if tmp[i] ~= nil then
						local id = tonumber(tmp[i])

						if id ~= nil then
							if ni.buff.Has(t, id, caster, exact) then
								results = true
								break
							end
						else
							if ni.buff.Has(t, tmp[i], caster, exact) then
								results = true
								break
							end
						end
					end
				end
			end
		end
		return results
	end
}
