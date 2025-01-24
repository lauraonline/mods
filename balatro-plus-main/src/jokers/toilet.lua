local j = {
  loc_txt = {
    name = "Toilet",
    text = {
      "Gain {C:chips}Chips{} from half {C:chips}Chips{}",
      "value of {C:attention}Flush{} poker hand",
      "when {C:attention}Flush{} is discarded",
      "{s:0.8}only work once each round{}",
      "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)",
    },
  },
  config = { extra = { flushed = false, chips = 0 } },
  rarity = 2,
  cost = 6,
  atlas = 11,

  perishable_compat = false,
  blueprint_compat = true,
}

function j:loc_vars(infoq, card)
  return { vars = { card.ability.extra.chips } }
end

function j:calculate(card, ctx)
  if
    ctx.discard
    and not ctx.blueprint
    and not card.ability.extra.flushed
    and ctx.other_card == ctx.full_hand[#ctx.full_hand]
    and G.FUNCS.get_poker_hand_info(ctx.full_hand) == "Flush"
  then
    card.ability.extra.chips = card.ability.extra.chips + (G.GAME.hands.Flush.chips / 2)
    card.ability.extra.flushed = true

    return {
      message = localize("k_upgrade_ex"),
      card = card,
      colour = G.C.CHIPS,
    }
  elseif ctx.joker_main and card.ability.extra.chips > 0 then
    return {
      message = localize { type = "variable", key = "a_chips", vars = { card.ability.extra.chips } },
      chip_mod = card.ability.extra.chips,
      colour = G.C.CHIPS,
    }
  elseif ctx.end_of_round and not ctx.blueprint then
    card.ability.extra.flushed = false
  end
end

return j
