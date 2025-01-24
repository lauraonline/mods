local j = {
  loc_txt = {
    name = "Membership Card",
    text = {
      "Reduce {C:attention}Premium Card",
      "cost by {C:money}$#1#{}",
    },
  },
  config = { extra = 2 },
  rarity = 2,
  cost = 7,
  atlas = 32,

  blueprint_compat = true,
}

function j:loc_vars(infoq, card)
  infoq[#infoq + 1] = G.P_CENTERS.m_bplus_premium
  return { vars = { card.ability.extra } }
end

function j:calculate(card, ctx)
  if ctx.bplus_premium_card_dollars then
    return { value = card.ability.extra }
  end
end

return j
