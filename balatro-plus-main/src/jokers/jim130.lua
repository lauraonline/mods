local j = {
  loc_txt = {
    name = "Joker JIM130",
    text = {
      "Gain {X:mult,C:white} X#1# {} each",
      "triggered {C:attention}Steel Card",
      "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
    },
  },
  config = { extra = 0.1, Xmult = 1 },
  rarity = 2,
  cost = 6,
  atlas = 14,

  perishable_compat = false,
  blueprint_compat = true,
}

function j:loc_vars(_, card)
  return { vars = { card.ability.extra, card.ability.x_mult } }
end

function j:calculate(card, ctx)
  if
    not ctx.blueprint
    and ctx.individual
    and ctx.cardarea == G.play
    and ctx.other_card.ability.name == G.P_CENTERS.m_steel.name
  then
    card.ability.x_mult = card.ability.x_mult + card.ability.extra
    card_eval_status_text(card, "jokers", nil, nil, nil, {
      message = localize("k_upgrade_ex"),
      colour = G.C.MULT,
    })
  end
end

return j
