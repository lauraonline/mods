local p = {
  loc_txt = {
    name = "Mysthic Pack",
    text = {
      "Choose {C:attention}#1#{} of up to",
      "{C:attention}#2#{} {C:bplus_sigil}Sigil{} cards to",
      "be used immediately",
    },
  },
  weight = 0.4,
  cost = 6,
  config = { extra = 2, choose = 1 },
  draw_hand = true,
  kind = "sigil",
  group_key = "k_bplus_mysthic_pack",
  atlas = 1,
}

function p:loc_vars()
  return { vars = { self.config.choose, self.config.extra } }
end

function p:ease_background_colour()
  ease_background_colour { new_colour = darken(G.C.SECONDARY_SET.sigil, 0.2) }
end

function p:create_card()
  return create_card("sigil", G.pack_cards, nil, nil, true, true, nil, "p_mysthic_normal1_card")
end

return p
