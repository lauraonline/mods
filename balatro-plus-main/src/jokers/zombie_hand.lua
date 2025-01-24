local j = {
  loc_txt = {
    name = "Zombie Hand",
    text = {
      "Level up played {C:attention}poker hand{}",
      "by {C:attention}#1#{} level on final hand",
    },
  },
  config = { extra = 1 },
  rarity = 1,
  cost = 4,
  atlas = 21,

  blueprint_compat = true,
}

function j:loc_vars(_, card)
  return { vars = { card.ability.extra } }
end

function j:calculate(card, ctx)
  if ctx.before and G.GAME.current_round.hands_left == 0 then
    return {
      message = localize("k_level_up_ex"),
      level_up = card.ability.extra,
    }
  end
end

return j
