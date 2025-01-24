local b = {
  loc_txt = {
    name = "The Brake",
    text = {
      "Cannot play/discard",
      "consecutively",
    },
  },
  boss = { min = 2 },
  boss_colour = HEX("b3143e"),
  atlas = 6,
}

function b:get_loc_debuff_text()
  return G.GAME.blind.loc_debuff_text
    .. (G.GAME.current_round.bplus_the_brake_last_act and "[Must discard first]" or "")
end

function b:debuff_hand()
  if G.GAME.blind.disabled then
    return
  end

  local last_act = G.GAME.current_round.bplus_the_brake_last_act
  if last_act == "play" then
    G.GAME.blind.triggered = true
    return true
  end
end

function b:defeat()
  G.GAME.current_round.bplus_the_brake_last_act = nil
end

return b
