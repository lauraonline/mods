local j = {
  loc_txt = {
    name = "Crown",
    text = {
      "Gain {X:mult,C:white} X#1# {} Mult when",
      "playing {C:attention}Royal Flush{}",
      "{C:inactive}(Currently {X:mult,C:white} X#2# {}{C:inactive} Mult)",
    },
  },
  config = { extra = 1, Xmult = 1 },
  rarity = 3,
  cost = 10,
  atlas = 8,

  perishable_compat = false,
  blueprint_compat = true,
}

function j:loc_vars(_, card)
  return { vars = { card.ability.extra, card.ability.x_mult } }
end

function j:calculate(card, ctx)
  if ctx.before and not ctx.blueprint then
    local _, _, _, _, name = G.FUNCS.get_poker_hand_info(G.play.cards)
    if name == "Royal Flush" then
      card.ability.x_mult = card.ability.x_mult + self.config.extra
      return {
        message = localize { type = "variable", key = "a_xmult", vars = { card.ability.x_mult } },
        colour = G.C.ORANGE,
        card = card,
      }
    end
  end
end

return j
