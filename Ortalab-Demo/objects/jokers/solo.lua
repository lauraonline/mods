SMODS.Joker({
    key = "solo",
    atlas = "jokers",
	pos = {x = 1, y = 8},
	rarity = 3,
	cost = 8,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
    config = {extra = {x_mult = 4, type = 'High Card'}},
	loc_vars = function(self, info_queue, card)
        if card and Ortalab.config.artist_credits then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'flowwey'} end
        return {vars = {card.ability.extra.x_mult, localize(card.ability.extra.type, 'poker_hands')}}
    end,
    calculate = function(self, card, context) --The Solo Logic
        if context.joker_main then
            if context.scoring_name == 'High Card' then
                return {
                    xmult = card.ability.extra.x_mult
                }
            end
        end
    end
})