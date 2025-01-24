local j = {
  loc_txt = {
    name = "Shopping Bill",
    text = {
      "All {C:attention}numbered{} cards held in",
      "hand at the end of round",
      "have {C:green}#1# in #2#{} chance to earn",
      "{C:attention}rank{} value of card {C:money}dollars{}",
    },
  },
  config = { extra = 4 },
  rarity = 1,
  cost = 5,
  atlas = 19,

  blueprint_compat = true,
}

function j:loc_vars(_, card)
  return { vars = { probability("normal"), card.ability.extra } }
end

function j:calculate(card, ctx)
  if ctx.end_of_round and ctx.individual and ctx.cardarea == G.hand then
    local id = ctx.other_card:get_id()
    if
      id > 1
      and id < 11
      and pseudorandom("j_bplus_shopping_bill_money")
        <= probability("normal") / card.ability.extra
    then
      if ctx.other_card.debuff then
        return {
          message = localize("k_debuffed"),
          colour = G.C.RED,
          card = card,
        }
      else
        G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + id
        G.E_MANAGER:add_event(Event {
          func = function()
            G.GAME.dollar_buffer = 0
            return true
          end,
        })
        return {
          dollars = id,
          card = card,
        }
      end
    end
  end
end

return j
