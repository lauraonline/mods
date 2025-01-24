SMODS.Joker({
	key = "royal_gala",
	atlas = "jokers",
	pos = {x = 0,y = 4},
	rarity = 1,
	cost = 4,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	yes_pool_flag = 'taliaferro_extinct',
	config = {extra = {chips = 300, odds = 1000}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flowwey'} end
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'grassy'} end
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'salad'} end
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {card.ability.extra.chips, math.max(G.GAME.probabilities.normal, 1), card.ability.extra.odds / math.min(G.GAME.probabilities.normal, 1)}}
    end,
    calculate = function(self, card, context) --Royal Gala Logic
        if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            if pseudorandom('royalgala') < G.GAME.probabilities.normal/card.ability.extra.odds then
                Ortalab.remove_joker(card)
                return {
                    message = localize('k_extinct_ex')
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
})
