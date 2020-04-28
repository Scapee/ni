ni.bootstrap = {
	rotation = function(priorities, abilities)
		return {
			start = function()
				local _priorities = priorities
				local _abilities = abilities

				for i = 1, #_priorities do
					local priority = _priorities[i]
					if _abilities[priority]() then
						break
					end
				end
			end
		}
	end
}
