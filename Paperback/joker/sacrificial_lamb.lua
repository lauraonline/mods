SMODS.Joker {
  key = 'sacrificial_lamb',
  config = {
    extra = {
      mult_mod = 5,
      mult = 0
    }
  },
  rarity = 2,
  pos = { x = 5, y = 0 },
  atlas = 'jokers_atlas',
  cost = 6,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  soul_pos = nil,

  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.mult_mod,
        card.ability.extra.mult,
      }
    }
  end,

  calculate = function(self, card, context)
    -- Gains mult when playing cards are destroyed. Each card destroyed provides the specified mult_mod
    if not context.blueprint and context.remove_playing_cards and context.removed and #context.removed > 0 then
      card.ability.extra.mult = card.ability.extra.mult + (#context.removed * card.ability.extra.mult_mod)

      card_eval_status_text(card, 'extra', nil, nil, nil,
        { message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult_mod * #context.removed } } })
    end

    -- Gives the mult when scoring
    if context.joker_main then
      if card.ability.extra.mult > 0 then
        return {
          mult_mod = card.ability.extra.mult,
          card = card,
          message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
        }
      end
    end
  end,
}
