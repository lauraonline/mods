local t = {
  loc_txt = {
    name = "The Rich",
    text = {
      "Enhances {C:attention}#1#{} selected",
      "card into a",
      "{C:attention}#2#",
    },
  },
  config = {
    mod_conv = "m_bplus_premium",
    max_highlighted = 1,
  },
  atlas = 1,
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
