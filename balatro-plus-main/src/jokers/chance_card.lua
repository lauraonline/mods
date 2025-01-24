local j = {
  loc_txt = {
    name = "Chance Card",
    text = {
      "{C:green}#1# in #2#{} chance to",
      "{C:attention}retrigger{} played card",
    },
  },
  config = { extra = 4 },
  rarity = 1,
  cost = 4,
  atlas = 36,

  blueprint_compat = true,
}

function j:loc_vars(_, card)
  return { vars = { probability("normal"), card.ability.extra } }
end

function j:calculate(card, ctx)
  if
    ctx.repetition
    and ctx.cardarea == G.play
    and pseudorandom("j_bplus_chance_chance") <= probability("normal") / card.ability.extra
  then
    return {
      message = localize("k_again_ex"),
      repetitions = 1,
      card = card,
    }
  end
end

return j
