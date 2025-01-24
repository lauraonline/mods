local j = {
  loc_txt = {
    name = "Hungry Joker",
    text = {
      "At the end of shop destroy all",
      "{C:attention}Food Jokers{} and gain {X:mult,C:white} X1 {} Mult",
      "for each destroyed joker",
      "{C:inactive}(Currently {X:mult,C:white} X#1# {}{C:inactive} Mult)",
    },
  },
  config = { extra = 1, Xmult = 1 },
  rarity = 2,
  cost = 7,
  atlas = 1,

  perishable_compat = false,
  blueprint_compat = true,
}

function j:loc_vars(infoq, card)
  infoq[#infoq + 1] = { set = "Other", key = "bplus_food_jokers" }
  return { vars = { card.ability.x_mult } }
end

function j:calculate(card, ctx)
  if ctx.ending_shop and not ctx.blueprint then
    local upgrade = false
    for _, joker in ipairs(G.jokers.cards) do
      if joker.config.center.bplus_food_joker then
        joker.getting_sliced = true
        upgrade = true
        G.E_MANAGER:add_event(Event {
          func = function()
            play_sound("tarot1")
            joker.T.r = -0.2
            joker:juice_up(0.3, 0.4)
            joker.states.drag.is = true
            joker.children.center.pinch.x = true
            card:juice_up(0.4, 0.5)

            G.E_MANAGER:add_event(Event {
              trigger = "after",
              delay = 0.3,
              blockable = false,
              func = function()
                G.jokers:remove_card(joker)
                joker:remove()
                joker = nil
                return true
              end,
            })
            return true
          end,
        })

        card_eval_status_text(joker, "jokers", nil, nil, nil, {
          message = localize("k_eaten_ex"),
        })

        card.ability.x_mult = card.ability.x_mult + card.ability.extra
      end
    end

    if upgrade then
      card_eval_status_text(card, "extra", nil, nil, nil, {
        message = localize { type = "variable", key = "a_xmult", vars = { card.ability.x_mult } },
      })
    end
  end
end

return j
