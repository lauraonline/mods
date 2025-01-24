local b = {
  loc_txt = {
    name = "The Thunder",
    text = {
      "Score more for each",
      "Jokers you have",
    },
  },
  mult = 1,
  boss = { min = 3 },
  boss_colour = HEX("ebad13"),
  atlas = 5,
}

function b:set_blind()
  local blind = G.GAME.blind
  blind.chips = blind.chips + (blind.chips * #G.jokers.cards)
  blind.chip_text = number_format(blind.chips)
end

function b:disable()
  local blind = G.GAME.blind
  blind.chips = get_blind_amount(G.GAME.round_resets.ante)
    * blind.mult
    * G.GAME.starting_params.ante_scaling
  blind.chip_text = number_format(blind.chips)
end

return b
