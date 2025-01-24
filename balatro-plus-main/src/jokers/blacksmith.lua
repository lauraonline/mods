local j = {
  loc_txt = {
    name = "Blacksmith",
    text = {
      "Gains {C:chips}+#1#{} Chips when",
      "enhancing card",
      "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
    },
  },
  config = { extra = { chips = 0, scale = 10 } },
  rarity = 3,
  cost = 8,
  atlas = 25,

  perishable_compat = false,
  blueprint_compat = true,
}

function j:loc_vars(_, card)
  return { vars = { card.ability.extra.scale, card.ability.extra.chips } }
end

function j:calculate(card, ctx)
  if ctx.joker_main and card.ability.extra.chips > 0 then
    return {
      message = localize { type = "variable", key = "a_chips", vars = { card.ability.extra.chips } },
      colour = G.C.CHIPS,
      chip_mod = card.ability.extra.chips,
    }
  elseif ctx.enhance and not ctx.blueprint and ctx.to ~= G.P_CENTERS.c_base then
    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.scale
  end
end

return j
