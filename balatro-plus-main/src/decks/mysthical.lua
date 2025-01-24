local d = {
  loc_txt = {
    name = "Mysthical Deck",
    text = {
      "Create a random {C:bplus_sigil}Sigil{} card",
      "when blind is selected",
      "{C:inactive}(Must have room)",
      "Shop {C:attention}slot{} and Shop {C:attention}Booster",
      "{C:attention}Pack{} has {C:attention}1{} less slot",
    },
  },
  atlas = 4,
}

function d:apply()
  G.E_MANAGER:add_event(Event {
    func = function()
      change_shop_size(-1)
      return true
    end,
  })
end

function d:trigger_effect(args)
  if
    args.context == "setting_blind"
    and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
  then
    G.E_MANAGER:add_event(Event {
      trigger = "after",
      func = function()
        local card =
          create_card("sigil", G.consumeables, nil, nil, nil, nil, nil, "b_bplus_mysthical_sigil")
        card:add_to_deck()
        G.consumeables:emplace(card)
        play_sound("tarot1")
        G.GAME.consumeable_buffer = 0
        return true
      end,
    })
  end
end

return d
