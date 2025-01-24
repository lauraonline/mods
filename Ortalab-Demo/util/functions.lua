function table.contains(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end

function table.size(table)
    local size = 0
    for _,_ in pairs(table) do
        size = size + 1
    end
    return size
end

function Ortalab.rank_from_deck(seed)
	local ranks = {}
	local seed = seed or 'ortalab_rank_from_deck'
	for _, card in pairs(G.playing_cards) do
		ranks[card.base.value] = card.base.value
	end
	return pseudorandom_element(ranks, pseudoseed(seed))
end

function Ortalab.hand_contains_rank(hand, rank)
    for _, card in ipairs(hand) do
        if card.base.value == rank then return true end
    end
end

local igo = Game.init_game_object
function Game:init_game_object()
    local ret = igo(self)
    ret.ortalab = {
        temp_levels = 0,
		tree_of_life_count = 0,
        ya_te_veo_count = 0,
        jackalope_count = 0,
    }
	return ret
end

function modify_joker_slot_count(amount)
    G.CONTROLLER.locks.no_space = true
    G.jokers.config.card_limit = G.jokers.config.card_limit + amount
    attention_text({scale = 0.9, text = (amount>0 and '+' or '') .. amount .. localize((amount > 1 or amount < -1) and 'ortalab_joker_slots' or 'ortalab_joker_slot'), hold = 0.9, align = 'cm',
        cover = G.jokers, cover_padding = 0.1, cover_colour = adjust_alpha(G.C.BLACK, 0.2)})

    for i = 1, #G.jokers.cards do
        G.jokers.cards[i]:juice_up(0.15)
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.06*G.SETTINGS.GAMESPEED,
        blockable = false,
        blocking = false,
        func = function() play_sound('tarot2', 0.76, 0.4); return true end
    }))

    play_sound('tarot2', 1, 0.4)

    G.E_MANAGER:add_event(Event({
        trigger = 'after', 
        delay = 0.5*G.SETTINGS.GAMESPEED, 
        blockable = false, 
        blocking = false,
        func = function() G.CONTROLLER.locks.no_space = nil; return true end
    }))
end

to_big = to_big or function(x, y)
    return x
end