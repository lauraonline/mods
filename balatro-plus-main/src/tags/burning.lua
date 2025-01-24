local t = {
  loc_txt = {
    name = "Burning Tag",
    text = {
      "{C:red}+#1#{} Discards",
      "next round",
    },
  },
  config = { discard = 5, type = "setting_blind" },
  atlas = 9,
}

function t:loc_vars()
  return { vars = { self.config.discard } }
end

function t:apply(tag, ctx)
  if ctx.type == "setting_blind" then
    tag:yep("+", G.C.RED, function()
      ease_discard(self.config.discard, true)
      return true
    end)
    tag.triggered = true
  end
end

return t
