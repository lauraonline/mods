local t = {
  loc_txt = {
    name = "The Craftsman",
    text = {
      "Enhances {C:attention}#1#{}",
      "selected cards to",
      "{C:attention}#2#s",
    },
  },
  config = {
    mod_conv = "m_bplus_framed",
    max_highlighted = 2,
  },
  atlas = 2,
}

function t:loc_vars(infoq)
  infoq[#infoq + 1] = G.P_CENTERS[self.config.mod_conv]
  return {
    vars = {
      self.config.max_highlighted,
      localize { type = "name_text", set = "Enhanced", key = self.config.mod_conv },
    },
  }
end

return t
