local t = {
  loc_txt = {
    name = "Booster Tag",
    text = {
      "Adds {C:attention}#1# Booster Pack",
      "to the next shop",
    },
  },
  config = { booster = 2, type = "shop_final_pass" },
  atlas = 4,
}

function t:loc_vars()
  return { vars = { self.config.booster } }
end

function t:apply(tag, ctx)
  if ctx.type == "shop_final_pass" then
    tag:yep("+", G.C.PURPLE, function()
      for i = #G.shop_booster.cards + 1, #G.shop_booster.cards + self.config.booster do
        G.GAME.current_round.used_packs = G.GAME.current_round.used_packs or {}
        if not G.GAME.current_round.used_packs[i] then
          G.GAME.current_round.used_packs[i] = get_pack("shop_pack").key
        end

        if G.GAME.current_round.used_packs[i] ~= "USED" then
          local card = Card(
            G.shop_booster.T.x + G.shop_booster.T.w / 2,
            G.shop_booster.T.y,
            G.CARD_W * 1.27,
            G.CARD_H * 1.27,
            G.P_CARDS.empty,
            G.P_CENTERS[G.GAME.current_round.used_packs[i]],
            { bypass_discovery_center = true, bypass_discovery_ui = true }
          )
          create_shop_card_ui(card, "Booster", G.shop_booster)
          card.ability.booster_pos = i
          card:start_materialize()
          G.shop_booster:emplace(card)
        end
      end
      return true
    end)
    tag.triggered = true
    return true
  end
end

return t
