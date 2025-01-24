local j = {
  loc_txt = {
    name = "Snowman",
    text = {
      "{C:chips}+#1#{} Chips and gain {C:chips}+#2#",
      "Chips for each cards",
      "{C:attention}held in hand{}, resets",
      "at the end of round",
    },
  },
  config = { extra = { chips = 0, scale = 1 } },
  rarity = 1,
  cost = 4,
  atlas = 23,

  blueprint_compat = true,
  perishable_compat = false,
}

function j:loc_vars(_, card)
  return { vars = { card.ability.extra.chips, card.ability.extra.scale } }
end

function j:calculate(card, ctx)
  if not ctx.end_of_round and ctx.individual and ctx.cardarea == G.hand then
    if ctx.other_card.debuff then
      return {
        message = localize("k_debuffed"),
        colour = G.C.RED,
        card = card,
      }
    else
      if not ctx.blueprint then
        card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.scale
      end
      return {
        h_chips = card.ability.extra.chips,
        card = ctx.other_card,
      }
    end
  elseif not ctx.blueprint and ctx.end_of_round and not ctx.individual and not ctx.repetition then
    card.ability.extra.chips = 0
    return {
      message = localize("k_reset"),
      colour = G.C.CHIPS,
    }
  end
end

return j
