SMODS.Joker({
	key = "business",
	atlas = "jokers",
	pos = {x=9,y=1},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {reroll_gain = 2}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'alex'} end
		return {vars = {card.ability.extra.reroll_gain}}
	end,
	calculate = function(self, card, context)
		if context.reroll_shop then
			return {
				dollars = card.ability.extra.reroll_gain
			}
		end
	end
})