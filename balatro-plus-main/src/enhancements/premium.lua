local e = {
  loc_txt = {
    name = "Premium Card",
    text = {
      "{X:mult,C:white} X#1# {} Mult",
      "#3# {C:money}$#2#",
    },
  },
  config = { Xmult = 2 },
  atlas = 1,
}

BalatroPlus.premium_card_base_dollars = -3
function bplus_calculate_premium_card_dollars()
  local dollars = BalatroPlus.premium_card_base_dollars

  if G.jokers then
    for _, joker in ipairs(G.jokers.cards) do
      local ret = joker:calculate_joker { bplus_premium_card_dollars = true }
      if ret and ret.value then
        dollars = dollars + ret.value
      end
    end
  end

  return dollars
end

function bplus_premium_card_dollars()
  return G.bplus_premium_card_dollars or bplus_calculate_premium_card_dollars()
end

function e:loc_vars()
  local dollars = bplus_premium_card_dollars()
  return {
    vars = {
      self.config.Xmult,
      dollars < 0 and -dollars or dollars,
      dollars < 0 and "Loss" or "Earn",
    },
  }
end

function e:calculate(card, ctx)
  if ctx.cardarea == G.play and ctx.main_scoring and not ctx.repetition then
    return { p_dollars = bplus_premium_card_dollars() }
  end
end

return e
