local b = {
  loc_txt = {
    name = "The Extra",
    text = {
      "Each hand played add",
      "random normal card",
    },
  },
  boss = { min = 1 },
  boss_colour = HEX("2e9c10"),
  atlas = 2,
}

function b:press_play()
  if G.GAME.blind.disabled then
    return
  end

  G.E_MANAGER:add_event(Event {
    delay = 1,
    func = function()
      create_playing_card({
        front = pseudorandom_element(G.P_CARDS, pseudoseed("bl_bplus_extra_card")),
        center = G.P_CENTERS.c_base,
      }, G.hand)
      play_sound("card1", 1)
      G.hand:sort()
      return true
    end,
  })
  return true
end

return b
