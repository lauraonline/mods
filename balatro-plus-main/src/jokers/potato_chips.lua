local j = {
  loc_txt = {
    name = "Potato Chips",
    text = {
      "{C:chips}+#1#{} Chips",
      "{C:chips}-#2#{} Chips for",
      "every card trigger",
    },
  },
  config = { extra = { chips = 150, chip_mod = 3 } },
  rarity = 1,
  cost = 4,
  atlas = 31,

  blueprint_compat = true,
  eternal_compat = false,
  bplus_food_joker = true,
}

function j:loc_vars(_, card)
  return { vars = { card.ability.extra.chips, card.ability.extra.chip_mod } }
end

function j:calculate(card, ctx)
  if ctx.joker_main and card.ability.extra.chips > 0 then
    return {
      message = localize { type = "variable", key = "a_chips", vars = { card.ability.extra.chips } },
      chip_mod = card.ability.extra.chips,
      colour = G.C.CHIPS,
    }
  elseif ctx.individual and ctx.cardarea == G.play then
    if card.ability.extra.chips - card.ability.extra.chip_mod <= 0 then
      G.E_MANAGER:add_event(Event {
        func = function()
          play_sound("tarot1")
          card.T.r = -0.2
          card:juice_up(0.3, 0.4)
          card.states.drag.is = true
          card.children.center.pinch.x = true
          G.E_MANAGER:add_event(Event {
            trigger = "after",
            delay = 0.3,
            blockable = false,
            func = function()
              G.jokers:remove_card(card)
              card:remove()
              card = nil
              return true
            end,
          })
          return true
        end,
      })
      return {
        message = localize("k_melted_ex"),
        colour = G.C.CHIPS,
      }
    else
      card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chip_mod
      return {
        extra = {
          message = localize {
            type = "variable",
            key = "a_chips_minus",
            vars = { card.ability.extra.chip_mod },
          },
          colour = G.C.CHIPS,
          focus = card,
        },
        card = card,
      }
    end
  end
end

return j
