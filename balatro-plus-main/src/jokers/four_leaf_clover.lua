local j = {
  loc_txt = {
    name = "4 Leaf Clover",
    text = {
      "{X:green,C:white} X4 {} all {C:green,E:1,s:1.1}probabilities{} after",
      "playing hand that is contain",
      "exactly {C:attention}4{} {C:clubs}Clubs{}, inactive",
      "after {C:attention}Boss Blind{} is defeated",
    },
  },
  config = { extra = false },
  rarity = 2,
  cost = 6,
  atlas = 10,

  blueprint_compat = false,
}

function j:loc_vars(_, card)
  local main_end = {
    {
      n = G.UIT.C,
      config = { align = "bm", minh = 0.4 },
      nodes = {
        {
          n = G.UIT.C,
          config = {
            align = "m",
            colour = card.ability.extra and G.C.GREEN or G.C.RED,
            r = 0.05,
            padding = 0.06,
          },
          nodes = {
            { n = G.UIT.B, config = { w = 0.1, h = 0.1 } },
            {
              n = G.UIT.T,
              config = {
                text = card.ability.extra and "active" or "inactive",
                colour = G.C.UI.TEXT_LIGHT,
                scale = 0.32 * 0.8,
              },
            },
            { n = G.UIT.B, config = { w = 0.1, h = 0.1 } },
          },
        },
      },
    },
  }
  return { main_end = main_end }
end

function j:calculate(card, ctx)
  if ctx.before and not card.ability.extra then
    local clubs = 0
    for _, c in ipairs(ctx.full_hand) do
      if c:is_suit("Clubs") then
        clubs = clubs + 1
      end
    end
    if clubs == 4 then
      for k, v in pairs(G.GAME.probabilities) do
        G.GAME.probabilities[k] = v * 4
      end

      card.ability.extra = true
      return {
        message = localize("k_active_ex"),
        colour = G.C.GREEN,
      }
    end
  elseif ctx.end_of_round and G.GAME.blind.boss and card.ability.extra then
    for k, v in pairs(G.GAME.probabilities) do
      G.GAME.probabilities[k] = v / 4
    end

    card.ability.extra = false
    return {
      message = localize("k_bplus_inactive_ex"),
      colour = G.C.RED,
    }
  end
end

return j
