local t = {
  loc_txt = {
    name = "Bounty Tag",
    text = {
      "Earn {X:money,C:white}X#1#{} {C:money}dollars{} of the {C:attention}Blinds",
      "reward when defeated",
    },
  },
  config = { reward = 4, type = "eval" },
  atlas = 6,
}

function t:loc_vars()
  return { vars = { self.config.reward } }
end

function t:apply(tag, ctx)
  if ctx.type == "eval" then
    tag:yep("+", G.C.MONEY, function()
      return true
    end)
    tag.triggered = true
    return {
      dollars = G.GAME.blind.dollars * self.config.reward,
      condition = "Defeat the Blind",
      pos = tag.pos,
      tag = tag,
    }
  end
end

return t
