local t = {
  loc_txt = {
    name = "Glove Tag",
    text = {
      "{C:blue}+#1#{} Hands",
      "next round",
    },
  },
  config = { hand = 5, type = "setting_blind" },
  atlas = 2,
}

function t:loc_vars()
  return { vars = { self.config.hand } }
end

function t:apply(tag, ctx)
  if ctx.type == "setting_blind" then
    tag:yep("+", G.C.BLUE, function()
      ease_hands_played(self.config.hand, true)
      return true
    end)
    tag.triggered = true
  end
end

return t
