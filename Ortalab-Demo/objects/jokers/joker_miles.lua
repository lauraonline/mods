SMODS.Joker({
	key = "joker_miles",
	atlas = "jokers",
	pos = {x = 4, y = 1},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	config = {extra = {chips = 0, chip_gain = 50, chance = 6}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'logan'} end
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flare'} end
        return {vars = {card.ability.extra.chip_gain, card.ability.extra.chips, math.max(1, G.GAME.probabilities.normal), card.ability.extra.chance / math.min(G.GAME.probabilities.normal, 1)}}
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if pseudorandom(pseudoseed('ortalab_joker_miles')) < G.GAME.probabilities.normal / card.ability.extra.chance then
                card.ability.extra.chips = 0
                return {
                    message = localize('ortalab_joker_miles_reset'),
                    colour = G.C.BLUE
                }
            end
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
            return {
                message = localize('ortalab_joker_miles'),
                colour = G.C.BLUE
            }
        end
        if context.joker_main and card.ability.extra.chips > 0 then
            return {
                chips = card.ability.extra.chips,
            }
        end
    end
})