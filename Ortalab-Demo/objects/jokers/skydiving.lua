SMODS.Joker({
	key = "skydiving",
	atlas = "jokers",
	pos = {x=0,y=3},
	rarity = 2,
	cost = 6,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	config = {extra = {curr_xmult = 1, xmult_add = 0.3, level_loss = 1}},
    loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'alex'} end
        return {vars = {card.ability.extra.xmult_add, card.ability.extra.curr_xmult, card.ability.extra.level_loss}}
    end,
	calculate = function(self, card, context)
		if not context.blueprint and context.cardarea == G.jokers and context.before and G.GAME.hands[context.scoring_name].level ~= 1 then
			if G.GAME.hands[context.scoring_name].level > 1 then
				card.ability.extra.curr_xmult = card.ability.extra.curr_xmult + card.ability.extra.xmult_add
				return {
					message = localize('ortalab_joker_miles'),
					card = card,
					colour = G.C.RED,
					level_up = -card.ability.extra.level_loss,
				}
			end
		end
		if context.joker_main and card.ability.extra.curr_xmult > 1 then
			return {
				xmult = card.ability.extra.curr_xmult
			}
		end
	end
})
