SMODS.Joker({
	key = "abstemious",
	atlas = "jokers",
	pos = {x = 4, y = 0},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {chips = 30, suit = 'Clubs'}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'golddisco'} end
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {card.ability.extra.chips, localize(card.ability.extra.suit, 'suits_singular')}}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_suit("Clubs") then
            return {
                chips = card.ability.extra.chips,
                card = card
            }
        end
    end
})