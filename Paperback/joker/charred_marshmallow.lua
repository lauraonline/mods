SMODS.Joker {
  key = "charred_marshmallow",
  config = {
    extra = {
      mult = 5,
      odds = 6
    }
  },
  rarity = 2,
  pos = { x = 4, y = 3 },
  atlas = 'jokers_atlas',
  cost = 7,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = false,
  soul_pos = nil,
  yes_pool_flag = "charred_marshmallow_can_spawn",

  loc_vars = function(self, info_queue, card)
    return {
      vars = {
        card.ability.extra.mult,
        G.GAME.probabilities.normal,
        card.ability.extra.odds
      }
    }
  end,

  calculate = function(self, card, context)
    -- Give the mult during play if card is a Spade
    if context.individual and context.cardarea == G.play then
      if context.other_card:is_suit("Spades") then
        return {
          mult = card.ability.extra.mult,
          card = card
        }
      end
    end

    -- Check if the Joker needs to be eaten
    if context.end_of_round and not context.blueprint and not (context.individual or context.repetition) then
      if pseudorandom("Charred Marshmallow") < G.GAME.probabilities.normal / card.ability.extra.odds then
        PB_UTIL.destroy_joker(card, function()
          -- Remove Charred Marshmallow from the pool
          G.GAME.pool_flags.charred_marshmallow_can_spawn = false

          -- Create Popsicle Stick
          if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
            local jokers_to_create = math.min(1,
              G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
            G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create

            G.E_MANAGER:add_event(Event({
              func = function()
                local card = create_card('Joker', G.jokers, nil, 0, nil, nil,
                  'j_paperback_sticky_stick', nil)
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
          message = localize('k_eaten_ex'),
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
