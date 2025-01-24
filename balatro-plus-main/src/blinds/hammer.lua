local b = {
  loc_txt = {
    name = "The Hammer",
    text = {
      "Destroy 1 random card",
      "every hand drawn",
    },
  },
  boss = { min = 2 },
  boss_colour = HEX("a15c2f"),
  atlas = 4,
}

function b:drawn_to_hand()
  if G.GAME.blind.disabled then
    return
  end

  local card = pseudorandom_element(G.hand.cards, pseudoseed("bl_bplus_hammer_choosen"))
  G.E_MANAGER:add_event(Event {
    trigger = "after",
    delay = 0.5,
    func = function()
      if card.ability.name == G.P_CENTERS.m_glass.name then
        card:shatter()
      else
        card:start_dissolve()
      end
      G.GAME.blind:wiggle()
      draw_card(G.deck, G.hand, nil, "up", true)
      return true
    end,
  })
end

return b
