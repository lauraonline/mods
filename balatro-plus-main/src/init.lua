BalatroPlus = {
  mod = SMODS.current_mod,
  path = SMODS.current_mod.path:gsub("/$", ""),
  load_chace = {},
  G = {},
  round_vars = {},
  game_objects = {},
  config = SMODS.current_mod.config,
  config_ui = {
    { label = "Replace Splash Logo", type = "toggle", mod_config = "replace_splash_logo" },
  },
}

SMODS.Atlas {
  key = "balatro_plus",
  path = "balatro_plus.png",
  px = G.ASSET_ATLAS.balatro.px,
  py = G.ASSET_ATLAS.balatro.py,
}

SMODS.Atlas {
  key = "modicon",
  path = "modicon.png",
  px = 39,
  py = 39,
}

function bplus_update_splash_logo()
  local key = "balatro"
  if BalatroPlus.config.replace_splash_logo then
    key = "bplus_balatro_plus"
  end

  if G.SPLASH_LOGO then
    G.SPLASH_LOGO.atlas = G.ASSET_ATLAS[key]
  else
  end
end

function BalatroPlus.load(path)
  local module = BalatroPlus.load_chace[path]
  if not module then
    module = assert(SMODS.load_file("src/" .. path .. ".lua"))()
    BalatroPlus.load_chace[path] = module
  end
  return module
end

function BalatroPlus.loads(...)
  for _, path in ipairs { ... } do
    BalatroPlus.load(path)
  end
end

BalatroPlus.loads("uidef", "funcs", "override", "utils")

BalatroPlus.load("joker")("jokers", {
  -- Common
  "pickpocket",
  "archeologist",
  "memory_card",
  "golden_cheese",
  "zombie_hand",
  "ufo",
  "shopping_bill",
  "calculator",
  "boxer",
  "blackjack",
  "treasure_map",
  "wheel",
  "snowman",
  "fragile",
  "chef",
  "stone_skipping",
  "potato_chips",
  "seller",
  "chance_card",
  "meteor",
  "jumbo",
  "blured",
  "puzzle",
  "rgb",
  "newspaper",

  -- Uncommon
  "four_leaf_clover",
  "jim130",
  "santa_claus",
  "hungry",
  "magnifying_glass",
  "anonymous_mask",
  "toilet",
  "jackpot",
  "trash_can",
  "stone_carving",
  "membership_card",
  "art_exhibition",
  "wizard",
  "paper_shredder",
  "scorched",
  "not_found",

  -- Rare
  "crown",
  "space_invader",
  "blacksmith",
  "murderer",
})

BalatroPlus.load("deck")("decks", {
  "purple",
  "illusion",
  "jokered",
  "mysthical",
})

BalatroPlus.load("blind")("blinds", {
  "extra",
  "hammer",
  "loop",
  "low",
  "thunder",

  "brake",
  "lazy",
  "scales",
  "thirteen",
  "handcuffs",
})

BalatroPlus.load("tag")("tags", {
  "glow",
  "glove",
  "dish",
  "collector",
  "booster",
  "bounty",

  "enhanced",
  "mysthic",
  "burning",
  "symbolic",
  "recycle",
  "backpack",
})

BalatroPlus.load("consumable")("consumables", {
  "sigil",
})

BalatroPlus.load("tarot")("consumables/tarot", {
  "rich",
  "craftsman",
  "balance",
  "hell",
})

BalatroPlus.load("booster")("boosters", {
  -- Mysthic Pack for Sigil cards
  "mysthic_normal1",
  "mysthic_normal2",
  "mysthic_jumbo",
  "mysthic_mega",
})

BalatroPlus.load("voucher")("vouchers", {
  "refund",
  "big_pack",
})

BalatroPlus.load("enhancement")("enhancements", {
  "premium",
  "framed",
  "balanced",
  "burned",
})

function SMODS.current_mod.reset_game_globals()
  for key, value in pairs(BalatroPlus.round_vars) do
    G.GAME.current_round["bplus_" .. key] = value(G.GAME.current_round["bplus_" .. key])
  end
end
