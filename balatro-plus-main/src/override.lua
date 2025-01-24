local center_overrides = {
  j_gros_michel = { bplus_food_joker = true },
  j_egg = { bplus_food_joker = true },
  j_ice_cream = { bplus_food_joker = true },
  j_cavendish = { bplus_food_joker = true },
  j_turtle_bean = { bplus_food_joker = true },
  j_popcorn = { bplus_food_joker = true },
  j_ramen = { bplus_food_joker = true },
}

for key, override in pairs(center_overrides) do
  for field, value in pairs(override) do
    G.P_CENTERS[key][field] = value
  end
end

local old_localize = localize
function localize(args, misc_cat)
  if type(args.key) == "table" and args.key.bplus_custom then
    return args.key.bplus_custom(args, misc_cat)
  end

  if args.key == "bplus_food_jokers" then
    if args.nodes then
      args.nodes[#args.nodes + 1] = bplus_food_jokers_tooltip()
      return
    else
      return "Food Jokers"
    end
  else
    return old_localize(args, misc_cat)
  end
end

local cardarea_emplace = CardArea.emplace
function CardArea:emplace(card, location, stay_flipped)
  if G.jokers then
    for _, j in ipairs(G.jokers.cards) do
      j:calculate_joker { card_added = true, other_card = card, cardarea = self }
    end
    for _, t in ipairs(G.GAME.tags) do
      t:apply_to_run { type = "card_added", card = card, cardarea = self }
    end
  end
  return cardarea_emplace(self, card, location, stay_flipped)
end

local cardarea_remove_card = CardArea.remove_card
function CardArea:remove_card(card, discarded_only)
  if G.jokers then
    for _, j in ipairs(G.jokers.cards) do
      j:calculate_joker { card_removed = true, other_card = card, cardarea = self }
    end
  end
  return cardarea_remove_card(self, card, discarded_only)
end

local g_funcs_reroll_shop = G.FUNCS.reroll_shop
function G.FUNCS.reroll_shop(e)
  g_funcs_reroll_shop(e)
end

local game_init_game_object = Game.init_game_object
function Game:init_game_object()
  local game = game_init_game_object(self)

  for key, value in pairs(BalatroPlus.round_vars) do
    game.current_round["bplus_" .. key] = value(nil, true)
  end

  for key, value in pairs(BalatroPlus.game_objects) do
    if type(value) == "function" then
      game["bplus_" .. key] = value()
    else
      game["bplus_" .. key] = copy_table(value)
    end
  end

  return game
end

function probability(key)
  if
    G.GAME
    and G.GAME.blind
    and G.GAME.blind.name == "bl_bplus_thirteen"
    and not G.GAME.blind.disabled
  then
    return 0
  end
  return G.GAME.probabilities[key]
end
