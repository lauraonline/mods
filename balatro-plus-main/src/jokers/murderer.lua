local j = {
  loc_txt = {
    name = "Murderer",
    text = {
      "Gain {X:mult,C:white} X#1# {} Mult when",
      "Joker is destroyed",
      "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
    },
  },
  config = { extra = 1, Xmult = 1 },
  rarity = 3,
  cost = 9,
  atlas = 40,

  blueprint_compat = true,
  perishable_compat = false,
}

function j:loc_vars(_, card)
  return { vars = { card.ability.extra, card.ability.x_mult } }
end

function j:calculate(card, ctx)
  if ctx.joker_destroyed and not ctx.blueprint and not bplus_is_getting_destroyed(card) then
    local cards = #ctx.destroyed_cards
    G.E_MANAGER:add_event(Event {
      func = function()
        local xmult = card.ability.x_mult + (cards * card.ability.extra)
        card.ability.x_mult = xmult
        card_eval_status_text(card, "extra", nil, nil, nil, {
          message = localize { type = "variable", key = "a_xmult", vars = { xmult } },
        })
        return true
      end,
    })
  end
end

return j
