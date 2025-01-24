local j = {
  loc_txt = {
    name = "Golden Cheese",
    text = {
      "Earn {C:money}$#1#{} at the end",
      "of round, loss {C:money}$#2#",
      "each blind is {C:attention}skipped",
    },
  },
  config = { extra = { money = 6, loss = 2 } },
  rarity = 1,
  cost = 5,
  atlas = 16,

  blueprint_compat = false,
  eternal_compat = false,
  bplus_food_joker = true,
}

function j:loc_vars(_, card)
  return { vars = { card.ability.extra.money, card.ability.extra.loss } }
end

function j:calc_dollar_bonus(card)
  return card.ability.extra.money
end

function j:calculate(card, ctx)
  if ctx.skip_blind then
    card.ability.extra.money = card.ability.extra.money - card.ability.extra.loss
    if card.ability.extra.money <= 0 then
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

      card_eval_status_text(card, "jokers", nil, nil, nil, {
        message = localize("k_eaten_ex"),
        colour = G.C.ORANGE,
      })
    else
      card_eval_status_text(card, "jokers", nil, nil, nil, {
        message = localize("$") .. "-" .. card.ability.extra.loss,
        colour = G.C.MONEY,
      })
    end
  end
end

return j
