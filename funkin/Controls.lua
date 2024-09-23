--- Controls table containing, guess what, keynames for controls wow!
---
--- @type metatable
local Controls = {
	--						NOTE KEYS						--
	["left"] 				= {		"a","left"		},
	["down"] 				= {		"s","down"		},
	["up"]	 				= {		"w","up"  		},
	["right"]				= {		"d","right"		},
	-- 					UI KEYS							--
	["uiLeft"] 			= {		"a","left"		},
	["uiDown"] 			= {		"s","down"		},
	["uiUp"]	 			= {		"w","up"  		},
	["uiRight"]			= {		"d","right"		},
	--					EDITOR KEYS					--
	["chart"]				= {		"7",nil				}, -- Chart Editor
	["chara"]				= {		"8",nil				}, -- Character Editor
	--					OTHER KEYS					--
	["reset"]				= {		"r",nil				}, -- Game Over Key
	["volumeDown"]	= {		"-","kp+"			},
	["volumeUp"]		= {		"+","kp-"			},
}
function Controls:__tostring() return "Controls" end
return Controls
