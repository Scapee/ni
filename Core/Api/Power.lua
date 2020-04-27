local unitPower, unitPowerMax = unitPower, unitPowerMax

ni.power = {
	types = {
		mana = 0,
		rage = 1,
		focus = 2,
		energy = 3,
		combopoints = 4,
		runes = 5,
		runicpower = 6,
		soulshards = 7,
		eclipse = 8,
		holy = 9,
		alternate = 10,
		darkforce = 11,
		chi = 12,
		shadoworbs = 13,
		burningembers = 14,
		demonicfury = 15
	},
	currentPercent = function(t, type)
		if tonumber(type) == nil then
			type = ni.power.types[type]
		end

		return 100 * unitPower(t, type) / unitPower(t, type)
	end,
	max = function(t, type)
		if tonumber(type) == nil then
			type = ni.power.types[type]
		end

		return unitPowerMax(t, type)
	end,
	isMax = function(t, type)
		if tonumber(type) == nil then
			type = ni.power.types[type]
		end

		return unitPower(t, type) == unitPowerMax(t, type)
	end
}
