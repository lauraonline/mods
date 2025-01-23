--- STEAMODDED HEADER
--- MOD_NAME: Talisman
--- MOD_ID: Talisman
--- MOD_AUTHOR: [MathIsFun_, Mathguy24, jenwalter666, cg-223]
--- MOD_DESCRIPTION: A mod that increases Balatro's score limit and skips scoring animations.
--- PREFIX: talisman
--- VERSION: 2.0.2

----------------------------------------------
------------MOD CODE -------------------------

if SMODS.Atlas then
  SMODS.Atlas({
    key = "modicon",
    path = "icon.png",
    px = 32,
    py = 32
  })
end

if SMODS.Sound then
	SMODS.Sound({
		key = "xchip",
		path = "MultiplicativeChips.wav"
	})
	SMODS.Sound({
		key = "echip",
		path = "ExponentialChips.wav"
	})
	SMODS.Sound({
		key = "eechip",
		path = "TetrationalChips.wav"
	})
	SMODS.Sound({
		key = "eeechip",
		path = "PentationalChips.wav"
	})
	SMODS.Sound({
		key = "emult",
		path = "ExponentialMult.wav"
	})
	SMODS.Sound({
		key = "eemult",
		path = "TetrationalMult.wav"
	})
	SMODS.Sound({
		key = "eeemult",
		path = "PentationalMult.wav"
	})
end


if SMODS.current_mod then
  function SMODS.current_mod.load_mod_config() end
  function SMODS.current_mod.save_mod_config() end
  SMODS.current_mod.config_tab = Talisman.config_tab
  SMODS.current_mod.debug_info = {
    ["Break Infinity"] = Talisman.config_file.break_infinity
  }
end
--[[SMODS.Joker{
  key = "test",
  name = "Joker Test",
  rarity = "cry_exotic",
  discovered = true,
  pos = {x = 9, y = 2},
  cost = 4,
  loc_txt = {
      name = "Infinitus",
      text = {
        "{C:mult,E:1}+10#2#1000#3#10{} Mult"
      }
  },
  loc_vars = function(self, info_queue, center)
    return {vars = {"#","{","}"}}
  end,
  calculate = function(self, card, context)
    if context.cardarea == G.jokers and not context.before and not context.after then
          local mult = Big:create(10):arrow(1000,10)
          return {
              mult_mod = mult,
              colour = G.C.RED,
              message = "!"
          }
      end
  end,
}--]]

----------------------------------------------
------------MOD CODE END----------------------
