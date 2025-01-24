local s = {
  loc_txt = {
    name = "Froze",
    text = {
      "{C:red}Debuff{} selected joker for",
      "{C:attention}#1#{} rounds, become {C:dark_edition}negative{}",
      "after {C:red}debuff{} end",
    },
  },
  config = { extra = 5 },
  atlas = 10,
}

function s:loc_vars(infoq, card)
  infoq[#infoq + 1] = G.P_CENTERS.e_negative
  return { vars = { card.ability.extra } }
end

function s:can_use()
  local joker = G.jokers.highlighted[1]
  return joker
    and not joker.edition
    and not joker.ability.perishable
    and not joker.ability.bplus_debuffed_by_sigil_froze
end

function s:use(card)
  local joker = G.jokers.highlighted[1]
  joker.ability.bplus_debuffed_by_sigil_froze = card.ability.extra

  G.E_MANAGER:add_event(Event {
    trigger = "after",
    delay = 0.2,
    func = function()
      joker:juice_up(0.3, 0.3)
      joker:set_debuff(true)
      card:juice_up(0.3, 0.5)
      play_sound("tarot1")
      return true
    end,
  })
end

return s
