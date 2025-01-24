local j = {
  loc_txt = {
    name = "Archeologist",
    text = {
      "Gain {C:mult}#1#{} Mult for every {C:spades}Spade",
      "cards in your {C:attention}full hand",
      "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
    },
  },
  config = { extra = 1 },
  rarity = 1,
  cost = 4,
  atlas = 15,

  perishable_compat = false,
  blueprint_compat = true,
}

function j:loc_vars(_, card)
  return { vars = { card.ability.extra, card.ability.mult } }
end

function j:calculate(card, ctx)
  if ctx.joker_main and card.ability.mult > 0 then
    return {
      message = localize { type = "variable", key = "a_mult", vars = { card.ability.mult } },
      mult_mod = card.ability.mult,
      colour = G.C.MULT,
    }
  elseif ctx.before and not ctx.blueprint then
    local spades = 0
    for _, c in ipairs(ctx.full_hand) do
      if c:is_suit("Spades") then
        spades = spades + 1
      end
    end
    if spades > 0 then
      card.ability.mult = card.ability.mult + (spades * card.ability.extra)
      return {
        message = localize("k_upgrade_ex"),
        colour = G.C.MULT,
      }
    end
  end
end

return j
