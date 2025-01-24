local j = {
  loc_txt = {
    name = "Magnifying Glass",
    text = {
      "Add {C:attention}triple{} of each",
      "played {C:attention}2{} and {C:attention}3{} Chips",
      "value to the {C:chips}Chips{}",
    },
  },
  rarity = 2,
  cost = 6,
  atlas = 7,

  blueprint_compat = true,
}

function j:calculate(card, ctx)
  if ctx.individual and ctx.cardarea == G.play then
    local id = ctx.other_card:get_id()
    if id == 2 or id == 3 then
      return {
        chips = (
          ctx.other_card:get_chip_bonus()
          + (ctx.other_card.edition and ctx.other_card.edition.chips or 0)
        ) * 3,
        card = card,
      }
    end
  end
end

return j
