local s = {
  loc_txt = {
    name = "Blank",
    text = {
      "{C:green}#1# in #2#{} chance to",
      "create other {C:attention}Sigil{} card",
      "{s:0.8}chance is increasing",
      "{s:0.8}at the end of round",
    },
  },
  config = { extra = 6 },
  atlas = 1,
}

function s:loc_vars(_, card)
  return { vars = { probability("normal"), card.ability.extra } }
end

function s:can_use()
  return true
end

function s:use(card)
  if #G.consumeables.cards >= G.consumeables.config.card_limit then
    return
  end
  if pseudorandom("c_bplus_sigil_blank_create") > probability("normal") / card.ability.extra then
    return
  end

  play_sound("timpani")
  local area = G.consumeables
  local sig =
    create_card("sigil", G.pack_cards, nil, nil, nil, nil, nil, "c_bplus_sigil_blank_card")
  sig:add_to_deck()
  area:emplace(sig)
  card:juice_up(0.3, 0.5)
end

return s
