local d = {
  loc_txt = {
    name = "Jokered Deck",
    text = {
      "Start with {C:money}$#1#{},",
      "{C:attention,T:p_buffoon_jumbo_1}Jumbo Buffoon Pack{}",
      "and {C:attention,T:v_hone}Hone{} voucher",
    },
  },
  config = { voucher = "v_hone", booster_pack = "p_buffoon_jumbo_1", start_dollars = 0 },
  atlas = 2,
}

function d:loc_vars()
  return { vars = { self.config.start_dollars } }
end

function d:apply()
  G.GAME.starting_params.dollars = self.config.start_dollars
  G.GAME.selected_back.effect.open_pack = true
end

return d
