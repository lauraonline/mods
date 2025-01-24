local j = {
  loc_txt = {
    name = "Jackpot",
    text = {
      "Gain {C:mult}+#1#{} Mult every {C:attention}#2#{} {C:inactive}[#5#]",
      "times {C:attention}#3#{} is triggered",
      "{C:inactive}(Currently {C:mult}+#4#{C:inactive} Mult)",
    },
  },
  config = {
    extra = {
      scale = 2,
      rank = "7",
      every = 3,
      remaining = 3,
    },
  },
  rarity = 2,
  cost = 7,
  atlas = 22,

  perishable_compat = false,
  blueprint_compat = true,
}

function j:loc_vars(_, card)
  return {
    vars = {
      card.ability.extra.scale,
      card.ability.extra.every,
      card.ability.extra.rank,
      card.ability.mult,
      card.ability.extra.remaining,
    },
  }
end

function j:calculate(card, ctx)
  if ctx.joker_main and card.ability.mult > 0 then
    return {
      message = localize { type = "variable", key = "a_mult", vars = { card.ability.mult } },
      mult_mod = card.ability.mult,
      colour = G.C.MULT,
    }
  elseif
    not ctx.blueprint
    and ctx.individual
    and ctx.cardarea == G.play
    and ctx.other_card.base.value == card.ability.extra.rank
  then
    card.ability.extra.remaining = card.ability.extra.remaining - 1
    if card.ability.extra.remaining <= 0 then
      card.ability.extra.remaining = card.ability.extra.every
      card.ability.mult = card.ability.mult + card.ability.extra.scale
      return {
        extra = {
          message = localize("k_upgrade_ex"),
          focus = card,
          colour = G.C.MULT,
        },
        card = card,
      }
    end
  end
end

return j
