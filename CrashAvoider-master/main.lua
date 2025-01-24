local game_splash_screen_ref = Game.splash_screen

local mod = SMODS.current_mod
mod.debug_info = { Note = "This mod screws with the game crashing. It is recommended to replicate crashes with it off to ensure this crash isn't some side effect of something else crashing", ["Crashes Avoided"] = 0 }
local function makeSafe(origFunc, name)
	name = name or "Some dipshit forgot to name this"
	return function(...)
		local succ, res = pcall(origFunc, ...) -- TODO: multiple returns?
		if not succ then
			mod.debug_info["Crashes Avoided"] = mod.debug_info["Crashes Avoided"] + 1
			sendErrorMessage("Function " .. name .. " errored: " .. tostring(res or "No details"), "CrashAvoider")
			return
		end
		return res
	end
end
-- Setup here so we are loaded after other mods
function Game:splash_screen()
	Card.update = makeSafe(Card.update, "Card:update")
	generate_card_ui = makeSafe(generate_card_ui, "generate_card_ui")
	Card.calculate_joker = makeSafe(Card.calculate_joker, "Card:calculate_joker")
	return game_splash_screen_ref(self)
end
