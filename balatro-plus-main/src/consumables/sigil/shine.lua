local s = {
  loc_txt = {
    name = "Shine",
    text = {
      "Add {C:dark_edition}#1#{} to",
      "selected card",
      "{s:0.8}changes every round",
      "{s:0.8}cannot be {C:dark_edition,s:0.8}negative",
    },
  },
  atlas = 14,
}

function BalatroPlus.round_vars.shine_sigil_edition(v, init)
  if init then
    return "polychrome"
  end

  return pseudorandom_element(
    bplus_get_editions(function(edition)
      return edition ~= "negative" and edition ~= v
    end),
    pseudoseed("c_bplus_sigil_shine_edition" .. G.GAME.round_resets.ante)
  )
end

function s:loc_vars(infoq)
  local edition = G.GAME.current_round.bplus_shine_sigil_edition
  infoq[#infoq + 1] = G.P_CENTERS["e_" .. edition]
  return { vars = { localize { type = "name_text", key = "e_" .. edition, set = "Edition" } } }
end

function s:can_use()
  return G.hand and #G.hand.highlighted == 1
end

function s:use(card)
  G.E_MANAGER:add_event(Event {
    trigger = "after",
    delay = 0.4,
    func = function()
      local edition = { [G.GAME.current_round.bplus_shine_sigil_edition] = true }
      G.hand.highlighted[1]:set_edition(edition, true)
      card:juice_up(0.3, 0.5)
      return true
    end,
  })
end

return s
