SMODS.Joker({
	key = "collatz",
	atlas = "jokers",
	pos = {x = 0, y = 2},
	rarity = 2,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {x_mult = 3, x_mult_reduction = 0.5}},
    loc_vars = function(self, info_queue, card)
		if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flowwey'} end
        return {vars = {card.ability.extra.x_mult, card.ability.extra.x_mult_reduction}}
    end,
    calculate = function(self, card, context) --Collatz Logic
        if context.joker_main then
			return {
				xmult = (hand_chips % 2 > to_big(0)) and card.ability.extra.x_mult or card.ability.extra.x_mult_reduction
			}
        end
    end
})