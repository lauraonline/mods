local j = {
  loc_txt = {
    name = "Pickpocket",
    text = {
      "Choose one more card when",
      "opening any {C:attention}Booster pack{}",
    },
  },
  config = { extra = 1 },
  rarity = 1,
  cost = 5,
  atlas = 9,

  blueprint_compat = true,
}

function j:calculate(card, ctx)
  if ctx.open_booster then
    G.GAME.pack_choices = G.GAME.pack_choices + card.ability.extra
    card_eval_status_text(ctx.blueprint or card, "jokers", nil, nil, nil, {
      message = localize {
        type = "variable",
        key = "k_bplus_plus_choose_ex",
        vars = { card.ability.extra },
      },
      colour = G.C.ORANGE,
    })
  end
end

return j
