local t = {
  loc_txt = {
    name = "Collector Tag",
    text = {
      "Earn {C:money}$#1#{} for each",
      "card above {C:attention}#2#{}",
      "in your full deck",
      "{C:inactive}(Max of {C:money}$#3#{C:inactive})",
      "{C:inactive}(Currently {C:money}$#4#{C:inactive})",
    },
  },
  config = { above = 50, max = 45, each = 3, type = "immediate" },
  atlas = 3,
}

local function calc_money(self)
  local total = self.config.each * (#(G.playing_cards or {}) - self.config.above)
  if total > self.config.max then
    total = self.config.max
  elseif total < 0 then
    total = 0
  end
  return total
end

function t:loc_vars()
  return {
    vars = {
      self.config.each,
      self.config.above,
      self.config.max,
      calc_money(self),
    },
  }
end

function t:apply(tag, ctx)
  if ctx.type == "immediate" then
    tag:yep("+", G.C.MONEY, function()
      ease_dollars(calc_money(self), true)
      return true
    end)
    tag.triggered = true
    return true
  end
end

return t
