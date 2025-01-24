local j = {
  loc_txt = {
    name = "Stone Skipping",
    text = {
      "Give {X:mult,C:white} X#1# {} Mult when {C:attention}Stone Card{}",
      "is triggered, increase {X:mult,C:white} X#2# {}",
      "per {C:attention}Stone Card{} triggered,",
      "reset after playing hand",
    },
  },
  config = { extra = { scale = 0.1, xmult = 1.1 } },
  rarity = 1,
  cost = 5,
  atlas = 28,

  blueprint_compat = true,
}

function j:loc_vars(infoq, card)
  return { vars = { card.ability.extra.xmult, card.ability.extra.scale } }
end

function j:calculate(card, ctx)
  if
    ctx.individual
    and ctx.cardarea == G.play
    and ctx.other_card.ability.name == G.P_CENTERS.m_stone.name
  then
    local xmult = card.ability.extra.xmult
    if not ctx.blueprint then
      card.ability.extra.xmult = xmult + card.ability.extra.scale
    end
    if xmult > 1 then
      return {
        x_mult = xmult,
        colour = G.C.MULT,
        card = card,
      }
    end
  elseif ctx.after and not ctx.blueprint then
    card.ability.extra.xmult = self.config.extra.xmult
  end
end

return j
