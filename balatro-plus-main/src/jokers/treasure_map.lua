local j = {
  loc_txt = {
    name = "Treasure Map",
    text = {
      "Earn {C:money}$#1#{} up to {C:money}$#2#{}",
      "every {C:attention}#3#{} trigger",
      "{C:inactive}(#4#){}",
    },
  },
  rarity = 1,
  cost = 4,
  config = {
    extra = {
      min = 6,
      max = 12,
      remaining = 4,
      every = 5,
    },
  },
  atlas = 6,

  blueprint_compat = true,
}

function j:loc_vars(_, card)
  return {
    vars = {
      card.ability.extra.min,
      card.ability.extra.max,
      card.config.center.config.extra.every,
      localize {
        type = "variable",
        key = card.ability.extra.remaining == 0 and "loyalty_active" or "loyalty_inactive",
        vars = { card.ability.extra.remaining },
      },
    },
  }
end

function j:calculate(card, ctx)
  if ctx.joker_main then
    if card.ability.extra.remaining == 0 then
      local money =
        pseudorandom("bplus_treasure_map", card.ability.extra.min, card.ability.extra.max)
      ease_dollars(money)
      G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + money
      G.E_MANAGER:add_event(Event {
        func = function()
          G.GAME.dollar_buffer = 0
          return true
        end,
      })

      return {
        message = localize("$") .. money,
        dollars = money,
        colour = G.C.MONEY,
      }
    end
  elseif ctx.after and not ctx.blueprint then
    if card.ability.extra.remaining == 0 then
      card.ability.extra.remaining = card.config.center.config.extra.every
    end

    card.ability.extra.remaining = card.ability.extra.remaining - 1

    if card.ability.extra.remaining == 0 then
      juice_card_until(card, function(c)
        return c.ability.extra.remaining == 0
      end, true)
    end
  end
end

return j
