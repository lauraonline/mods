SMODS.Joker({
	key = "shelter",
	atlas = "jokers",
	pos = {x = 1, y = 9},
	rarity = 3,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {x_mult = 4, type = 'Full House'}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'gappie'} end
        return {vars = {card.ability.extra.x_mult, localize(card.ability.extra.type, 'poker_hands')}}
    end,
    calculate = function(self, card, context) --The Mysterium Logic
        if context.joker_main then
            if next(context.poker_hands[card.ability.extra.type]) then
                return {
                    xmult = card.ability.extra.x_mult
                }
            end
        end
    end
})