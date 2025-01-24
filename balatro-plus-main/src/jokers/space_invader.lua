local j = {
  loc_txt = {
    name = "Space Invader",
    text = {
      "{C:planet}Planet{} card added",
      "to {C:attention}Consumable slot{}",
      "become {C:dark_edition}negative",
    },
  },
  rarity = 3,
  cost = 9,
  atlas = 4,
  soul_pos = 5,

  blueprint_compat = false,
}

function j:loc_vars(infoq)
  infoq[#infoq + 1] = { key = "e_negative_consumable", set = "Edition", config = { extra = 1 } }
end

function j:calculate(_, ctx)
  if
    ctx.card_added
    and ctx.cardarea == G.consumeables
    and ctx.other_card.config.center.set == "Planet"
  then
    if (not ctx.other_card.edition) or not ctx.other_card.edition.negative then
      ctx.other_card:set_edition({ negative = true }, true)
    end
  end
end

return j
