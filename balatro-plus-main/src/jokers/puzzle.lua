local j = {
  loc_txt = {
    name = "Puzzle",
    text = {
      "Gain {C:chips}+#1#{} Chips if",
      "{C:attention}scoring{} hand contains",
      "{C:attention}#2#{} of {V:1}#3#",
      "{s:0.8}Card changes after gain chips",
      "{C:inactive}(Currently {C:chips}+#4#{C:inactive} Chips)",
    },
  },
  config = { extra = { chips = 0, chip_mod = 10, rank = "Ace", suit = "Spades", id = 14 } },
  rarity = 1,
  atlas = 43,

  blueprint_compat = true,
}

local function set_piece(card)
  if G.playing_cards then
    local valid_cards = {}
    for _, c in ipairs(G.playing_cards) do
      if not SMODS.has_no_suit(c) and not SMODS.has_no_rank(c) then
        valid_cards[#valid_cards + 1] = c
      end
    end

    if next(valid_cards) then
      local c = pseudorandom_element(valid_cards, pseudoseed("j_bplus_puzzle_piece"))
      card.ability.extra.rank = c.base.value
      card.ability.extra.suit = c.base.suit
      card.ability.extra.id = c.base.id
    end
  end
end

function j:set_ability(card)
  set_piece(card)
end

function j:loc_vars(infoq, card)
  return {
    vars = {
      card.ability.extra.chip_mod,
      localize(card.ability.extra.rank, "ranks"),
      localize(card.ability.extra.suit, "suits_plural"),
      card.ability.extra.chips,
      colours = { G.C.SUITS[card.ability.extra.suit] },
    },
  }
end

function j:calculate(card, ctx)
  if ctx.before and not ctx.blueprint then
    for _, c in ipairs(ctx.scoring_hand) do
      if c:get_id() == card.ability.extra.id and c:is_suit(card.ability.extra.suit) then
        card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
        set_piece(card)
        return {
          message = localize("k_upgrade_ex"),
          colour = G.C.CHIPS,
          card = card,
        }
      end
    end
  elseif ctx.joker_main then
    return {
      message = localize {
        type = "variable",
        key = "a_chips",
        vars = { card.ability.extra.chips },
      },
      chip_mod = card.ability.extra.chips,
      colour = G.C.CHIPS,
    }
  end
end

return j
