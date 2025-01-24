local t = {
  loc_txt = {
    name = "Symbolic Tag",
    text = {
      "Earn {C:money}$#1#{} for every",
      "{V:1}#2#{} cards you have",
      "{C:inactive}(Currently {C:money}$#3#{C:inactive})",
      "{C:inactive}(Max of {C:money}$#4#{C:inactive})",
    },
  },
  config = { dollars = 1, max = 30, type = "immediate" },
  atlas = 10,
}

local function calculate_dollars(self, tag)
  local dollars = 0
  local suit = tag.ability.bplus_symbolic_tag_suit
  for _, card in ipairs(G.playing_cards) do
    if card:is_suit(suit) then
      dollars = dollars + self.config.dollars
    end
  end
  return math.min(dollars, self.config.max)
end

function t:loc_vars(_, tag)
  local suit = tag and tag.ability.bplus_symbolic_tag_suit
  local dollars = 0

  if G.playing_cards then
    dollars = tag and calculate_dollars(self, tag) or 0
  end

  return {
    vars = {
      self.config.dollars,
      suit and localize(suit, "suits_plural") or "[" .. localize("k_suit") .. "]",
      dollars,
      self.config.max,
      colours = {
        suit and G.C.SUITS[suit] or G.C.ORANGE,
      },
    },
  }
end

function t:set_ability(tag)
  tag.ability.bplus_symbolic_tag_suit = "Spades"
  local valid_cards = {}
  for _, card in ipairs(G.playing_cards) do
    if not SMODS.has_no_suit(card) then
      valid_cards[#valid_cards + 1] = card
    end
  end
  if next(valid_cards) then
    tag.ability.bplus_symbolic_tag_suit = pseudorandom_element(
      valid_cards,
      pseudoseed("tag_bplus_symbolic_card" .. G.GAME.round_resets.ante)
    ).base.suit
  end
end

function t:apply(tag, ctx)
  if ctx.type == "immediate" then
    tag:yep("+", G.C.MONEY, function()
      return true
    end)
    ease_dollars(calculate_dollars(self, tag))
    tag.triggered = true
  end
end

return t
