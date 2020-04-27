ni.aura = {
	Has = function(t, s)
		return (t ~= nil and s ~= nil) and ni.functions.HasAura(t, s) or false
	end
}
