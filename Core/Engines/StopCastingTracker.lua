ni.stopcastingtracker = {
	shouldstop = function(spell, t)
		t = true and t or "target"

		-- if ni.unit.isboss(t) then
		local playercasttime = ni.spell.casttime(spell)
		-- local targetcasttime = ni.spell.casttime()
		-- end
	end
}
