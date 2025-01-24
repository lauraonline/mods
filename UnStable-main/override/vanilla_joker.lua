
--Rank

--Fibonacci
--Operates from a table, other mods can register more number in this table if needed
--Currently supports up to 144
unstb_global.fibo = {}

--Register more Fibonacci numbers, accepts a list of number
function unstb_global.register_fibonacci(number_list)
	for i = 1, #number_list do
		unstb_global.fibo[number_list[i]] = true
	end
end

unstb_global.register_fibonacci({0, 1, 2, 3, 5, 8, 13,	21,	34,	55,	89,	144})

--Fibonacci looks for a *nominal* chip of the rank (with special hardcoded case accounted for Ace)
SMODS.Joker:take_ownership('fibonacci', {

	config = { extra = { mult = 8} },
	loc_vars = function(self, info_queue, card)
		
		local key = self.key
		if getPoolRankFlagEnable('unstb_0') or getPoolRankFlagEnable('unstb_1') or getPoolRankFlagEnable('unstb_21') then
			key = self.key..'_ex'
		end
		
		return { key = key, vars = {card and card.ability.extra.mult or self.config.extra.mult} }
	end,
	
	calculate = function(self, card, context)
		
		if context.individual and context.cardarea == G.play then
			local nominal = context.other_card.base.nominal
			
			if not context.other_card.config.center.no_rank and (unstb_global.fibo[nominal] or context.other_card.base.value == 'Ace') then
				return {
				  mult = card.ability.extra.mult,
				  card = card
				}
				
			else
				--Failsafe for mod compat
				return {
					mult = 0
				}
			end
		end
		
    end
}, true)

--Odd Todd and Even Steven

--A special function written to specifically looking for rank's *nominal* + special case for ??? (Triggers everything)

--Table of a true 'face' rank (TODO: Might open it up to allow other mods to register more? Not sure yet)
unstb_global.face_rank = {Jack = true, Queen = true, King = true}

--Check for a modulo and remainder of the card's rank - used for both odd and even check
function unstb_global.modulo_check(card, mod, remainder)

	if card.config.center.no_rank then
		return false
	end
	
	local rank = card.base.value
	
	if rank == 'unstb_???' then -- ??? Card
		return true
	elseif unstb_global.face_rank[rank] then -- "True" Face Card (aka bypass Pareidolia)
		return false
	end
	
	return (card.base.nominal%mod == remainder)
end

SMODS.Joker:take_ownership('odd_todd', {

	config = { extra = { chips = 31} },
	loc_vars = function(self, info_queue, card)
		
		local key = self.key
		if getPoolRankFlagEnable('unstb_1') or getPoolRankFlagEnable('unstb_21') then
			key = self.key..'_ex'
		end
	
		return { key = key, vars = {card and card.ability.extra.chips or self.config.extra.chips} }
	end,
	
	calculate = function(self, card, context)
		
		if context.individual and context.cardarea == G.play then
			if unstb_global.modulo_check(context.other_card, 2, 1) then
				return {
				  chips = card.ability.extra.chips,
				  card = card
				}
				
			else
				--Failsafe for mod compat
				return {
					chips = 0
				}
			end
		end
		
    end
}, true)

SMODS.Joker:take_ownership('even_steven', {

	config = { extra = { mult = 4} },
	loc_vars = function(self, info_queue, card)
		
		local key = self.key
		if getPoolRankFlagEnable('unstb_0') then
			key = self.key..'_ex'
		end
	
		return { key = key, vars = {card and card.ability.extra.mult or self.config.extra.mult} }
	end,
	
	calculate = function(self, card, context)
		
		if context.individual and context.cardarea == G.play then
			if unstb_global.modulo_check(context.other_card, 2, 0) then
				return {
				  mult = card.ability.extra.mult,
				  card = card
				}
				
			else
				--Failsafe for mod compat
				return {
					mult = 0
				}
			end
		end
		
    end
}, true)

--Hack
--Operates from a table, other mods can register more number in this table if needed
unstb_global.hack = {}

--Register ranks that triggers Hack
function unstb_global.register_hack(rank_list)
	for i = 1, #rank_list do
		unstb_global.hack[rank_list[i]] = true
	end
end

unstb_global.register_hack({'unstb_0', 'unstb_1', '2', '3', '4', '5'})

SMODS.Joker:take_ownership('hack', {

	config = { extra = 1 },
	loc_vars = function(self, info_queue, card)
		
		local key = self.key
		if getPoolRankFlagEnable('unstb_0') or getPoolRankFlagEnable('unstb_1') then
			key = self.key..'_ex'
		end
	
		return { key = key, vars = {card and card.ability.extra or self.config.extra} }
	end,
	
	calculate = function(self, card, context)
		if context.cardarea == G.play and context.repetition and not context.repetition_only then
		  if not context.other_card.config.center.no_rank and unstb_global.hack[context.other_card.base.value] then
				return {
				  message = 'Again!',
				  repetitions = card.ability.extra,
				  card = context.blueprint_card or card
				}
		  end
		end
	end,
	
}, true)