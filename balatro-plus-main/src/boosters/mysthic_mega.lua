local p = {
  loc_txt = {
    name = "Mega Mysthic Pack",
    text = {
      "Choose {C:attention}#1#{} of up to",
      "{C:attention}#2#{} {C:bplus_sigil}Sigil{} cards to",
      "be used immediately",
    },
  },
  weight = 0.2,
  cost = 10,
  config = { extra = 4, choose = 2 },
  draw_hand = true,
  kind = "sigil",
  group_key = "k_bplus_mysthic_pack",
  atlas = 4,
}

function p:loc_vars()
  return { vars = { self.config.choose, self.config.extra } }
end

function p:ease_background_colour()
  ease_background_colour { new_colour = darken(G.C.SECONDARY_SET.sigil, 0.2) }
end

function p:create_card()
  return create_card("sigil", G.pack_cards, nil, nil, true, true, nil, "p_mysthic_mega_card")
end

return p
