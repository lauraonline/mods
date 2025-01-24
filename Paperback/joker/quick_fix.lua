SMODS.Joker {
  key = 'quick_fix',
  config = {
    extra = {
      h_size = 2,
      odds = 4
    }
  },
  rarity = 1,
  pos = { x = 6, y = 0 },
  atlas = 'jokers_atlas',
  cost = 6,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = false,
  soul_pos = nil,
  yes_pool_flag = "quick_fix_can_spawn",

  set_ability = function(self, card, initial, delay_sprites)
    card.ability.h_size = card.ability.extra.h_size or 0
    card.ability.extra.odds = card.ability.extra.odds or 1
  end,

  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.h_size,
        G.GAME.probabilities.normal,
        card.ability.extra.odds
      }
    }
  end,

  calculate = function(self, card, context)
    if context.end_of_round and not context.blueprint and not (context.individual or context.repetition) then
      if pseudorandom("Quick Fix") < G.GAME.probabilities.normal / card.ability.extra.odds then
        -- Destroy Quick Fix
        PB_UTIL.destroy_joker(card, function()
          -- Remove Quick Fix from the Joker pool
          G.GAME.pool_flags.quick_fix_can_spawn = false

          -- Create Half Joker if possible
          if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
            local jokers_to_create = math.min(1,
              G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
            G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create

            G.E_MANAGER:add_event(Event({
              func = function()
                local card = create_card('Joker', G.jokers, nil, 0, nil, nil, 'j_half', nil)
                card:add_to_deck()
                G.jokers:emplace(card)
                card:start_materialize()
                G.GAME.joker_buffer = 0
                return true
              end
            }))
          end
        end)

        return {
          message = localize('paperback_broken_ex'),
          colour = G.C.MULT,
          card = card
        }
      else
        return {
          message = localize('k_safe_ex'),
          colour = G.C.CHIPS,
          card = card
        }
      end
    end
  end
}
