local j = {
  loc_txt = {
    name = "Blackjack",
    text = {
      "Gains {C:chips}#1#{} Chips if played",
      "hand is {C:attention}Blackjack{}",
      "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
    },
  },
  rarity = 1,
  cost = 5,
  config = { extra = { chips = 0, chip_mod = 21 } },
  atlas = 2,

  perishable_compat = false,
  blueprint_compat = true,
}

function j:loc_vars(_, card)
  return { vars = { card.ability.extra.chip_mod, card.ability.extra.chips } }
end

function j:calculate(card, ctx)
  if ctx.joker_main then
    if card.ability.extra.chips > 0 then
      return {
        message = localize {
          type = "variable",
          key = "a_chips",
          vars = { card.ability.extra.chips },
        },
        chip_mod = card.ability.extra.chips,
        colour = G.C.CHIPS,
      }
    end
  elseif ctx.before and ctx.cardarea == G.jokers and not ctx.blueprint then
    if bplus_is_blackjack(ctx.full_hand) then
      card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
      return {
        message = localize("k_upgrade_ex"),
        colour = G.C.CHIPS,
        card = card,
      }
    end
  end
end

return j
