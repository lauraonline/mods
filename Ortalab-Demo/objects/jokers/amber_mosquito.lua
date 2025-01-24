SMODS.Joker({
	key = "amber_mosquito",
	atlas = "jokers",
	pos = {x = 3, y = 7},
	rarity = 2,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {xmult = 1.4, suit = 'Hearts', chance = 1, denom = 2}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.xmult, localize(card.ability.extra.suit, 'suits_singular'), math.max(G.GAME.probabilities.normal, 1) * card.ability.extra.chance, card.ability.extra.denom / math.min(G.GAME.probabilities.normal, 1), colours = {G.C.SUITS[card.ability.extra.suit]}}}
    end,
    calculate = function(self, card, context)
        if not context.end_of_round and context.individual and context.cardarea == G.hand and context.other_card:is_suit(card.ability.extra.suit) then
			if pseudoseed('ortalab_mosquito') > (G.GAME.probabilities.normal * card.ability.extra.chance) / card.ability.extra.denom then
				return {
					card = card,
					x_mult = card.ability.extra.xmult
				}
			end
        end
    end
})