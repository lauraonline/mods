local e = {
  loc_txt = {
    name = "Framed Card",
    text = {
      "Gains {C:chips}+#1#{} Chips",
      "each {C:attention}triggered",
    },
  },
  config = { extra = 2 },
  atlas = 2,
}

function e:loc_vars()
  return { vars = { self.config.extra } }
end

function e:calculate(card, ctx)
  if ctx.cardarea == G.play and ctx.main_scoring and not ctx.repetition then
    card.ability.perma_bonus = card.ability.perma_bonus + card.ability.extra
  end
end

return e
