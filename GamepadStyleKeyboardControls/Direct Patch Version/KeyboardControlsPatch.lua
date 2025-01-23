---------------------------------------------
---------- KEYBOARD CONTROLS PATCH ----------
---------------------------------------------

-- Edit the key names on the left of this list to change which keys will act as the gamepad buttons on the right. (Refer to the list of all supported key names below.)
-- You can also add more lines to this if you want to define multiple key assignments for the same button.
local my_keybind_mapping = {
	["left"] = "dpleft", -- D-pad: Move cursor between cards and other UI elements
	["right"] = "dpright",
	["up"] = "dpup",
	["down"] = "dpdown",
	["a"] = "a", -- A button: Confirm, select/deselect/grab a card
	["s"] = "b", -- B button: Back, deselect all cards
	["q"] = "x", -- X button: Play hand (or discard, if inverted in game options), shortcut for shop reroll, shortcut to start/resume run in "play" menu
	["w"] = "y", -- Y button: Discard (or play hand, if inverted in game options), shortcut to go to next round in shop, shortcut to skip card pack
	["1"] = "leftshoulder", -- Left Bumper: Sell card, buy + use card from shop
	["2"] = "rightshoulder", -- Right Bumper: Use consumable, buy card/pack from shop
	["3"] = "triggerleft", -- Left Trigger: Peek at deek while held
	["4"] = "triggerright", -- Right Trigger: View full deck
	["d"] = "back", -- Back/Select: Open Run Info screen
	["return"] = "start", -- Start: Open pause menu
	["escape"] = "start", -- Extra Start assignment, can remove if not needed
	--["r"] = "", -- Blank assignments will prevent that key from switching off gamepad mode even without gamepadModeForAnyKeysPressed enabled
}

--[[
List of all supported key names:
["a"]
["b"]
["c"]
["d"]
["e"]
["f"]
["g"]
["h"]
["i"]
["j"]
["k"]
["l"]
["m"]
["n"]
["o"]
["p"]
["q"]
["r"]
["s"]
["t"]
["u"]
["v"]
["w"]
["x"]
["y"]
["z"]

["up"] (Up Arrow)
["right"] (Right Arrow)
["down"] (Down Arrow)
["left"] (Left Arrow)

["1"]
["2"]
["3"]
["4"]
["5"]
["6"]
["7"]
["8"]
["9"]
["0"]

["return"] (Enter)
["escape"]
["space"]
["backspace"]
["tab"]

["lshift"] (Left Shift)
["rshift"] (Right Shift)
["lctrl"] (Left Control)
["rctrl"] (Right Control)
["lalt"] (Left Alt)
["ralt"] (Right Alt)
["lgui"] (Left GUI key, i.e. Windows key)
["rgui"] (Right GUI key, i.e. Windows key)

["pageup"]
["pagedown"]
["delete"]
["insert"]
["home"]
["end"]

["`"] (Grave mark, same key as ~ tilde)
["-"] (Hyphen/minus sign)
["="]
["["]
["]"]
["\\"] (Backslash; just a single backslash will cause a syntax error)
[";"]
["'"] (Apostrophe)
[","]
["."]
["/"]

["f1"]
["f2"]
["f3"]
["f4"]
["f5"]
["f6"]
["f7"]
["f8"]
["f9"]
["f10"]
["f11"]
["f12"]

["kp1"] (Numeral 1 on the numpad)
["kp2"]
["kp3"]
["kp4"]
["kp5"]
["kp6"]
["kp7"]
["kp8"]
["kp9"]
["kp0"]
["kp+"] (Plus sign on the numpad)
["kp-"] (Minus sign on the numpad)
["kp*"] (Asterisk on the numpad)
["kp/"] (Slash on the numpad)
["kp."] (Period on the numpad)
["kpenter"] (Enter/Return on the numpad)

["printscreen"]
["pause"]
["capslock"]
["numlock"]
["scrolllock"]
]]

-- Other user settings. However, it's generally recommended to leave most of these alone.
local changeButtonIconsToKeys = true -- Replaces button icons with key icons from the included keyboard_icons.png
local gamepadModeForAnyKeysPressed = true -- Activates (or preserves) gamepad mode whenever any key is pressed, not just assigned ones - helps avoid Alt-Tab cancelling it, for instance
local keepModeIfMouseMoves = true -- Prevents input mode from changing to mouse mode just from moving mouse
local reshowMouseOnMove = true -- Re-shows mouse cursor when it's moved (without necessarily changing to mouse input mode)
local dontHideMouse = false -- Keeps mouse from being hidden if a button is pressed


-- On key press or release, call gamepad press/release instead if it matches a key assignment.
local keypressed_original = love.keypressed
function love.keypressed(key)
	if my_keybind_mapping[key] and my_keybind_mapping[key] ~= "" then
		love.gamepadpressed(G.CONTROLLER.keyboard_controller, my_keybind_mapping[key])
		if not dontHideMouse then love.mouse.setVisible(false) end
	else
		keypressed_original(key)
	end
	
	if gamepadModeForAnyKeysPressed then
		G.CONTROLLER:set_gamepad(G.CONTROLLER.keyboard_controller)
		G.CONTROLLER:set_HID_flags("button")
		if not dontHideMouse then love.mouse.setVisible(false) end
	end
end

local keyreleased_original = love.keyreleased
function love.keyreleased(key)
	if my_keybind_mapping[key] and my_keybind_mapping[key] ~= "" then
		love.gamepadreleased(G.CONTROLLER.keyboard_controller, my_keybind_mapping[key])
	else
		keyreleased_original(key)
	end
	
	if gamepadModeForAnyKeysPressed then
		G.CONTROLLER:set_gamepad(G.CONTROLLER.keyboard_controller)
		G.CONTROLLER:set_HID_flags("button")
	end
end

-- If "keep mode" option is enabled, don't call the original mouse-moved function. But per other option, do make mouse visible if it was hidden by gamepad mode.
local mousemoved_original = love.mousemoved
function love.mousemoved(x, y, dx, dy, istouch)
	if reshowMouseOnMove then love.mouse.setVisible(true) end
	if not keepModeIfMouseMoves then mousemoved_original(x, y, dx, dy, istouch) end
end

-- If option is enabled, replace button icons with the matching key.
if changeButtonIconsToKeys then
	local set_render_settings_original = Game.set_render_settings
	function Game:set_render_settings()
		set_render_settings_original(self)
		
		local image_key = "keyboard_icons"
		local full_path = "resources/textures/" .. self.SETTINGS.GRAPHICS.texture_scaling .. "x/keyboard_icons.png"
		local image = love.graphics.newImage(full_path, {mipmaps = true, dpiscale = self.SETTINGS.GRAPHICS.texture_scaling})
		table.insert(self.asset_atli, { name = image_key, path = full_path, px = 32, py = 32 })
		self.ASSET_ATLAS[image_key] = { name = image_key, image = image, type = nil, px = 32, py = 32 }
	end
	
	local key_sprite_map = {
		["a"] = 0,
		["b"] = 1,
		["c"] = 2,
		["d"] = 3,
		["e"] = 4,
		["f"] = 5,
		["g"] = 6,
		["h"] = 7,
		["i"] = 8,
		["j"] = 9,
		["k"] = 10,
		["l"] = 11,
		["m"] = 12,
		["n"] = 13,
		["o"] = 14,
		["p"] = 15,
		["q"] = 16,
		["r"] = 17,
		["s"] = 18,
		["t"] = 19,
		["u"] = 20,
		["v"] = 21,
		["w"] = 22,
		["x"] = 23,
		["y"] = 24,
		["z"] = 25,
		
		["up"] = 26,
		["right"] = 27,
		["down"] = 28,
		["left"] = 29,
		
		["1"] = 30,
		["2"] = 31,
		["3"] = 32,
		["4"] = 33,
		["5"] = 34,
		["6"] = 35,
		["7"] = 36,
		["8"] = 37,
		["9"] = 38,
		["0"] = 39,
		
		["return"] = 40,
		["escape"] = 41,
		["space"] = 42,
		["backspace"] = 43,
		["tab"] = 44,
		
		["shift"] = 45,
		["lshift"] = 46,
		["rshift"] = 47,
		["ctrl"] = 48,
		["lctrl"] = 49,
		["rctrl"] = 50,
		["alt"] = 51,
		["lalt"] = 52,
		["ralt"] = 53,
		["gui"] = 54,
		["lgui"] = 55,
		["rgui"] = 56,
		
		["pageup"] = 57,
		["pagedown"] = 58,
		["delete"] = 59,
		["insert"] = 60,
		["home"] = 61,
		["end"] = 62,
		
		["`"] = 63,
		["-"] = 64,
		["="] = 65,
		["["] = 66,
		["]"] = 67,
		["\\"] = 68,
		[";"] = 69,
		["'"] = 70,
		[","] = 71,
		["."] = 72,
		["/"] = 73,
		
		["f1"] = 74,
		["f2"] = 75,
		["f3"] = 76,
		["f4"] = 77,
		["f5"] = 78,
		["f6"] = 79,
		["f7"] = 80,
		["f8"] = 81,
		["f9"] = 82,
		["f10"] = 83,
		["f11"] = 84,
		["f12"] = 85,
		
		["kp1"] = 86,
		["kp2"] = 87,
		["kp3"] = 88,
		["kp4"] = 89,
		["kp5"] = 90,
		["kp6"] = 91,
		["kp7"] = 92,
		["kp8"] = 93,
		["kp9"] = 94,
		["kp0"] = 95,
		["kp+"] = 96,
		["kp-"] = 97,
		["kp*"] = 98,
		["kp/"] = 99,
		["kp."] = 100,
		["kpenter"] = 101,
		
		["printscreen"] = 102,
		["pause"] = 103,
		["capslock"] = 104,
		["numlock"] = 105,
		["scrolllock"] = 106,
	}
	
	function table_has_value(table, val)
		for index, value in pairs(table) do
			if value == val then
				return true
			end
		end
	end
	
	-- Go through key mapping and create the reverse, mapping buttons to keys.
	local button_to_key_map = {}
	local using_both_left_and_right = {}
	for key, button in pairs(my_keybind_mapping) do
		if not button_to_key_map[button] then -- Button not matched to a key yet, so use first (encountered) key assigned to it
			button_to_key_map[button] = key
			
			-- For keys with left/right variations, check if the other has been added prior, and add to the left-and-right list if so
			if (key == "lshift" and table_has_value(button_to_key_map, "rshift")) or (key == "rshift" and table_has_value(button_to_key_map, "lshift")) then table.insert(using_both_left_and_right, "shift") end
			if (key == "lctrl" and table_has_value(button_to_key_map, "rctrl")) or (key == "rctrl" and table_has_value(button_to_key_map, "lctrl")) then table.insert(using_both_left_and_right, "ctrl") end
			if (key == "lalt" and table_has_value(button_to_key_map, "ralt")) or (key == "ralt" and table_has_value(button_to_key_map, "lalt")) then table.insert(using_both_left_and_right, "alt") end
			if (key == "lgui" and table_has_value(button_to_key_map, "rgui")) or (key == "rgui" and table_has_value(button_to_key_map, "lgui")) then table.insert(using_both_left_and_right, "gui") end
		end
	end
	
	-- If gamepad ID switches to or from keyboard_controller, set mode off gamepad and call update so that prompt icons get refreshed.
	gamepadpressed_original = love.gamepadpressed
	function love.gamepadpressed(joystick, button)
		if G.CONTROLLER.GAMEPAD.object ~=  joystick
		and (G.CONTROLLER.GAMEPAD.object == G.CONTROLLER.keyboard_controller or joystick == G.CONTROLLER.keyboard_controller) then
			G.CONTROLLER:set_HID_flags("mouse")
			G:update(0.001)
			G:draw()
		end
		gamepadpressed_original(joystick, button)
	end

	gamepadreleased_original = love.gamepadreleased
	function love.gamepadreleased(joystick, button)
		if G.CONTROLLER.GAMEPAD.object ~=  joystick
		and (G.CONTROLLER.GAMEPAD.object == G.CONTROLLER.keyboard_controller or joystick == G.CONTROLLER.keyboard_controller) then
			G.CONTROLLER:set_HID_flags("mouse")
			G:update(0.001)
			G:draw()
		end
		gamepadreleased_original(joystick, button)
	end
	
	-- Replace button icons with keys when suitable.
	create_button_binding_pip_original = create_button_binding_pip
	function create_button_binding_pip(args)
		-- Switch out for key icon if current "gamepad" is keyboard, and button has a defined key for it.
		if G.CONTROLLER.GAMEPAD.object == G.CONTROLLER.keyboard_controller and button_to_key_map[args.button] then 
			local key_name = button_to_key_map[args.button]
			
			-- Unless both left and right keys are assigned to something, change keys with left/right versions to basic version
			if (key_name == "lshift" or key_name == "rshift") and not table_has_value(using_both_left_and_right, "shift") then key_name = "shift" end
			if (key_name == "lctrl" or key_name == "rctrl") and not table_has_value(using_both_left_and_right, "ctrl") then key_name = "ctrl" end
			if (key_name == "lalt" or key_name == "ralt") and not table_has_value(using_both_left_and_right, "alt") then key_name = "alt" end
			if (key_name == "lgui" or key_name == "rgui") and not table_has_value(using_both_left_and_right, "gui") then key_name = "gui" end
			
			local key_sprite_index = key_sprite_map[key_name]
			-- Debug code to help preview all key icons in-game; instead of showing actual assignments, it cycles to the next icon every time one is requested.
			--[[
			if not debug_key_index then debug_key_index = 0 end
			key_sprite_index = debug_key_index
			debug_key_index = debug_key_index + 1
			if debug_key_index > 106 then debug_key_index = 0 end
			]]
			
			local KEY_SPRITE = Sprite(0, 0, args.scale or 0.45, args.scale or 0.45, G.ASSET_ATLAS["keyboard_icons"], { x = key_sprite_index, y = 0 })
			
			return {n=G.UIT.ROOT, config = {align = "cm", colour = G.C.CLEAR}, nodes= {
				{n=G.UIT.O, config={object = KEY_SPRITE}},
			}}
		else
			return create_button_binding_pip_original(args)
		end
	end
end

---------------------------------------------
----------- KEYBOARD CONTROLS END -----------
---------------------------------------------
