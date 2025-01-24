local j = {
  loc_txt = {
    name = "Art Exhibition",
    text = {
      "Gains {C:chips}+#1#{} Chips for",
      "each {C:attention}Framed Cards",
      "in your {C:attention}played hand",
      "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
    },
  },
  config = { extra = { chip_mod = 10, chips = 0 } },
  rarity = 2,
  cost = 6,
  atlas = 33,

  perishable_compat = false,
  blueprint_compat = true,
}

function j:loc_vars(infoq, card)
  infoq[#infoq + 1] = G.P_CENTERS.m_bplus_framed
  return { vars = { card.ability.extra.chip_mod, card.ability.extra.chips } }
end

function j:calculate(card, ctx)
  if ctx.before and not ctx.blueprint then
    local framed_cards = 0
    for _, c in ipairs(ctx.full_hand) do
      if c.ability.name == "m_bplus_framed" then
        framed_cards = framed_cards + 1
      end
    end
    if framed_cards > 0 then
      card.ability.extra.chips = card.ability.extra.chips
        + (framed_cards * card.ability.extra.chip_mod)
      return {
        message = localize("k_upgrade_ex"),
        colour = G.C.CHIPS,
      }
    end
  elseif ctx.joker_main and card.ability.extra.chips > 0 then
    return {
      message = localize { type = "variable", key = "a_chips", vars = { card.ability.extra.chips } },
      chip_mod = card.ability.extra.chips,
      colour = G.C.CHIPS,
    }
  end
end

return j
