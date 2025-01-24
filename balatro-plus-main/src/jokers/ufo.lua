local j = {
  loc_txt = {
    name = "UFO",
    text = {
      "Gain {C:chips}+#1#{} Chips for each",
      "{C:attention}unique{} {C:planet}Planet{} card on",
      "your {C:attention}consumables{} slot at",
      "the end of the {C:attention}shop",
      "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
    },
  },
  config = {
    extra = {
      chips = 0,
      planet_chips = 12,
    },
  },
  rarity = 1,
  cost = 5,
  atlas = 20,

  perishable_compat = false,
  blueprint_compat = true,
}

function j:loc_vars(_, card)
  return { vars = { card.ability.extra.planet_chips, card.ability.extra.chips } }
end

function j:calculate(card, ctx)
  if ctx.joker_main then
    return {
      message = localize { type = "variable", key = "a_chips", vars = { card.ability.extra.chips } },
      chip_mod = card.ability.extra.chips,
      colour = G.C.CHIPS,
    }
  elseif ctx.ending_shop and not ctx.blueprint then
    local planets = 0
    local already = {}
    for _, c in ipairs(G.consumeables.cards) do
      if c.ability.set == "Planet" and not already[c.config.center.key] then
        already[c.config.center.key] = true
        planets = planets + 1
      end
    end

    if planets > 0 then
      card.ability.extra.chips = card.ability.extra.chips
        + (planets * card.ability.extra.planet_chips)
      card_eval_status_text(card, "extra", nil, nil, nil, {
        message = localize("k_upgrade_ex"),
        colour = G.C.CHIPS,
      })
    end
  end
end

return j
