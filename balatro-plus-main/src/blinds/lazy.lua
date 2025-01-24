local b = {
  loc_txt = {
    name = "The Lazy",
    text = {
      "Retrigger effects",
      "are not allowed",
    },
  },
  boss = { min = 4 },
  boss_colour = HEX("1662f0"),
  atlas = 7,
}

function bplus_bl_lazy_trigger(card)
  if card then
    card_eval_status_text(card, "debuff", nil, nil, nil, {
      message = localize("k_bplus_no_retrigger"),
    })
  end
  G.GAME.blind:wiggle()
end

return b
