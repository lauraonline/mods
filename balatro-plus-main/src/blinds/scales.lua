local b = {
  loc_txt = {
    name = "The Scales",
    text = {
      "Loss $1 for each",
      "cards held in hend",
    },
  },
  boss = { min = 2 },
  boss_colour = HEX("51461a"),
  atlas = 8,
}

function b:press_play()
  if G.GAME.blind.disabled then
    return
  end

  G.GAME.blind.triggered = true
  G.E_MANAGER:add_event(Event {
    trigger = "after",
    delay = 0.2,
    func = function()
      for _, card in ipairs(G.hand.cards) do
        G.E_MANAGER:add_event(Event {
          func = function()
            card:juice_up()
            return true
          end,
        })
        ease_dollars(-1)
        delay(0.23)
      end
      return true
    end,
  })
end

return b
