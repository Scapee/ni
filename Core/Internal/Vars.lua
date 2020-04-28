local build = select(4, GetBuildInfo())

ni.vars = {
	latency = 220,
	interrupt = "all",
	build = build,
	debug = false,
	hotkeys = {
		aoe = "{aoeToggle}",
		cd = "{cdtoggle}",
		pause = "{pauseToggle}",
		custom = "{customToggle}"
	},
	profiles = {
		primary = "None",
		secondary = "None",
		active = "None",
		interrupt = false,
		enabled = false,
		useEngine = true
	},
	units = {
		follow = "{followUnit}",
		followEnabled = false,
		mainTank = "{mainTank}",
		mainTankEnabled = false,
		offTank = "{offTank}",
		offTankEnabled = false
	},
	combat = {
		started = false,
		time = 0,
		isMelee = false,
		cd = false,
		aoe = false,
		casting = false
	},
	interrupts = {
		whiteListed = {},
		blackListed = {}
	}
}
