local t = {
  loc_txt = {
    name = "Dish Tag",
    text = {
      "Create random",
      "{C:attention}Food Joker",
      "{C:inactive}(Must have room)",
    },
  },
  atlas = 5,
  config = { type = "immediate" },
}

function t:loc_vars(infoq)
  infoq[#infoq + 1] = { set = "Other", key = "bplus_food_jokers" }
end

function t:apply(tag, ctx)
  if ctx.type == "immediate" then
    tag:yep("+", G.C.ORANGE, function()
      if G.jokers and #G.jokers.cards < G.jokers.config.card_limit then
        local card = bplus_create_food_joker("tag_bplus_dish_joker")
        card:add_to_deck()
        G.jokers:emplace(card)
      end
      return true
    end)
    tag.triggered = true
    return true
  end
end

return t
