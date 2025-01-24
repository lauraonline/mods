local d = {
  loc_txt = {
    name = "Purple Deck",
    text = {
      "Reroll also refresh {C:attention}Booster Pack{}",
      "reroll cost {C:money}$#1#{} more",
    },
  },
  config = { reroll_extra_cost = 2 },
  atlas = 1,
}

function d:loc_vars()
  return { vars = { d.config.reroll_extra_cost } }
end

function d:apply()
  G.GAME.starting_params.reroll_cost = G.GAME.starting_params.reroll_cost
    + self.config.reroll_extra_cost
end

return d
