local j = {
  loc_txt = {
    name = "Fragile",
    text = {
      "{C:attention}Glass Card{} is",
      "destroyed when",
      "{C:red}discarded{}",
    },
  },
  rarity = 1,
  cost = 5,
  atlas = 27,

  blueprint_compat = false,
}

function j:loc_vars(infoq)
  infoq[#infoq + 1] = G.P_CENTERS.m_glass
end

function j:calculate(_, ctx)
  if ctx.discard and ctx.other_card.ability.name == G.P_CENTERS.m_glass.name then
    return {
      silent = true,
      remove = true,
    }
  end
end

return j
