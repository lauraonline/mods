local d = {
  loc_txt = {
    name = "Illusion Deck",
    text = {
      "Playing cards has more {C:chips}Chips",
      "start run with {C:attention}#1#{}",
      "random cards destroyed",
    },
  },
  config = { card_nominal_mult = 3, destroyed_cards = 26 },
  atlas = 3,
}

function d:loc_vars()
  return { vars = { self.config.destroyed_cards } }
end

return d
