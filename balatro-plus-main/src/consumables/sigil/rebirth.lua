local s = {
  loc_txt = {
    name = "Rebirth",
    text = {
      "Destroy all non {C:dark_edition}negative{}",
      "Jokers to {C:attention}create{} Jokers",
      "with the same amount of",
      "{C:attention}destroyed{} Jokers with",
      "same {C:attention}Rarity",
    },
  },
  atlas = 3,
}

function s:loc_vars(infoq)
  infoq[#infoq + 1] = G.P_CENTERS.e_negative
end

function s:can_use(card)
  local compat = 0
  for _, joker in ipairs(G.jokers.cards) do
    if not joker.ability.eternal and not (joker.edition and joker.edition.negative) then
      compat = compat + 1
    end
  end
  return compat > 0
end

function s:use(card)
  local rarities = {}
  local destroyed_cards = {}
  play_sound("slice1", 0.96 + math.random() * 0.08)
  for _, joker in ipairs(G.jokers.cards) do
    if not joker.ability.eternal and not (joker.edition and joker.edition.negative) then
      rarities[#rarities + 1] = joker.config.center.rarity
      destroyed_cards[#destroyed_cards + 1] = joker
    end
  end

  bplus_joker_destroyed_trigger(destroyed_cards)
  G.E_MANAGER:add_event(Event {
    func = function()
      for _, joker in ipairs(destroyed_cards) do
        joker:start_dissolve()
      end
      return true
    end,
  })

  G.E_MANAGER:add_event(Event {
    trigger = "after",
    delay = 0.5,
    func = function()
      play_sound("timpani")
      for _, rarity in ipairs(rarities) do
        local joker =
          create_card("Joker", G.jokers, nil, nil, nil, nil, nil, "c_bplus_sigil_rebirth_joker", {
            forced_rarity = rarity,
          })
        joker:add_to_deck()
        G.jokers:emplace(joker)
        joker:start_materialize()
      end
      card:juice_up(0.3, 0.5)
      return true
    end,
  })
end

return s
