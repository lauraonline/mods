local s = {
  loc_txt = {
    name = "Curse",
    text = {
      "{C:green}#1# in #2#{} chance to add",
      "any {C:dark_edition}edition{} to random",
      "Joker if {C:red}failed{} add",
      "{C:eternal}Eternal{} and {C:rental}Rental",
    },
  },
  config = { extra = 3 },
  atlas = 5,
}

function s:loc_vars(infoq, card)
  infoq[#infoq + 1] = { key = "eternal", set = "Other" }
  infoq[#infoq + 1] = { key = "rental", set = "Other", vars = { G.GAME.rental_rate or 1 } }
  return { vars = { probability("normal"), card.ability.extra } }
end

function s:can_use(card)
  for _, joker in ipairs(G.jokers.cards) do
    if not joker.edition and not joker.ability.eternal then
      return true
    end
  end
  return false
end

function s:use(card)
  local _edition = pseudorandom("c_bplus_sigil_curse_chance")
    <= probability("normal") / card.ability.extra
  local compat_jokers = {}
  for _, joker in ipairs(G.jokers.cards) do
    if not joker.edition and not joker.ability.eternal then
      compat_jokers[#compat_jokers + 1] = joker
    end
  end

  local joker = pseudorandom_element(compat_jokers, pseudoseed("c_bplus_sigil_curse_joker"))
  if _edition then
    local edition = poll_edition("c_bplus_sigil_curse_edition", nil, false, true)
    joker:set_edition(edition, true)
  else
    joker:set_eternal(true)
    joker:set_rental(true)
  end
  card:juice_up(0.3, 0.5)
  joker:juice_up(0.2, 0.3)
end

return s
