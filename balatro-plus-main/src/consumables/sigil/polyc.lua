local s = {
  loc_txt = {
    name = "Polyc",
    text = {
      "Destroy {C:attention}1{} random Joker",
      "to add {C:dark_edition}Polychrome{} to",
      "selected Joker",
    },
  },
  atlas = 2,
}

function s:loc_vars(infoq)
  infoq[#infoq + 1] = G.P_CENTERS.e_polychrome
end

function s:can_use(card)
  local cond = G.jokers and G.jokers.config.card_limit > 1
  cond = cond and (#G.jokers.highlighted == 1) and not G.jokers.highlighted[1].edition

  if cond then
    local compat = 0
    for _, joker in ipairs(G.jokers.cards) do
      if joker ~= G.jokers.highlighted[1] and not joker.ability.eternal then
        compat = compat + 1
      end
    end
    cond = compat > 0
  end

  return cond
end

function s:use(card, area, copier)
  local cards = {}
  for i, joker in ipairs(G.jokers.cards) do
    if joker ~= G.jokers.highlighted[1] and not joker.ability.eternal then
      cards[#cards + 1] = i
    end
  end
  local destroyed = pseudorandom_element(cards, pseudoseed("c_bplus_sigil_polyc_destroy"))

  bplus_joker_destroyed_trigger { destroyed }
  G.E_MANAGER:add_event(Event {
    trigger = "after",
    delay = 0.2,
    func = function()
      G.jokers.highlighted[1]:set_edition({ polychrome = true }, true)
      play_sound("polychrome1", 1.2, 0.7)
      card:juice_up(0.3, 0.5)
      return true
    end,
  })
  G.E_MANAGER:add_event(Event {
    trigger = "after",
    delay = 0.2,
    func = function()
      G.jokers.cards[destroyed]:start_dissolve()
      return true
    end,
  })
end

return s
