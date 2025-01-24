local j = {
  loc_txt = {
    name = "Seller",
    text = {
      "Earn {C:attention}sell value{} of",
      "Joker to the {C:attention}right{} at",
      "the end of round",
    },
  },
  rarity = 1,
  cost = 4,
  atlas = 35,

  blueprint_compat = false,
}

function j:calc_dollar_bonus(card)
  local joker
  for i, jkr in ipairs(G.jokers.cards) do
    if jkr == card then
      joker = G.jokers.cards[i + 1]
      break
    end
  end

  if joker and joker.sell_cost > 0 then
    return joker.sell_cost
  end
end

return j
