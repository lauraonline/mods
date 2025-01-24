local j = {
  loc_txt = {
    name = "Trash Can",
    text = {
      "Retrigger all card",
      "{C:red}discard{} ability",
    },
  },
  config = { extra = 1 },
  rarity = 2,
  cost = 6,
  atlas = 24,

  blueprint_compat = true,
}

function j:calculate(card, ctx)
  if ctx.discard_repetition then
    return {
      message = localize("k_again_ex"),
      repetitions = card.ability.extra,
      card = card,
    }
  end
end

return j
