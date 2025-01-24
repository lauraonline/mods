local jd = JokerDisplay.Definitions

--Vanilla Override Jokers
if unstb_global.config.joker.vanilla then

jd["j_fibonacci"].calc_function = function(card)
		local mult = 0
		local text, _, scoring_hand = JokerDisplay.evaluate_hand()
		if text ~= 'Unknown' then
			for _, scoring_card in pairs(scoring_hand) do
				if not scoring_card.config.center.no_rank and (unstb_global.fibo[scoring_card.base.nominal] or scoring_card.base.value == 'Ace') then
					mult = mult +
						card.ability.extra.mult *
						JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
				end
			end
		end
		card.joker_display_values.mult = mult
		
		if getPoolRankFlagEnable('unstb_0') or getPoolRankFlagEnable('unstb_1') or getPoolRankFlagEnable('unstb_13') or getPoolRankFlagEnable('unstb_21') then
			card.joker_display_values.localized_text = "(0,1," .. localize("Ace", "ranks") .. ",2,3,5,8,13,21)"
		else
			card.joker_display_values.localized_text = "(" .. localize("Ace", "ranks") .. ",2,3,5,8)"
		end
		
		
	end
	
jd["j_even_steven"].reminder_text = {
		{ ref_table = "card.joker_display_values", ref_value = "localized_text" },
}
jd["j_even_steven"].calc_function = function(card)
		local mult = 0
		local text, _, scoring_hand = JokerDisplay.evaluate_hand()
		if text ~= 'Unknown' then
			for _, scoring_card in pairs(scoring_hand) do
				if unstb_global.modulo_check(scoring_card, 2, 0) then
					mult = mult +
						card.ability.extra.mult *
						JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
				end
			end
		end
		card.joker_display_values.mult = mult
		
		if getPoolRankFlagEnable('unstb_0') or getPoolRankFlagEnable('unstb_12') then
			card.joker_display_values.localized_text = "(12,10,8,6,4,2,0)"
		else
			card.joker_display_values.localized_text = "(10,8,6,4,2)"
		end
end	

jd["j_odd_todd"].reminder_text = {
		{ ref_table = "card.joker_display_values", ref_value = "localized_text" },
}
jd["j_odd_todd"].calc_function = function(card)
		local chips = 0
		local text, _, scoring_hand = JokerDisplay.evaluate_hand()
		if text ~= 'Unknown' then
			for _, scoring_card in pairs(scoring_hand) do
				if unstb_global.modulo_check(scoring_card, 2, 1) then
					chips = chips +
						card.ability.extra.chips *
						JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
				end
			end
		end
		card.joker_display_values.chips = chips
		
		if getPoolRankFlagEnable('unstb_1') or getPoolRankFlagEnable('unstb_11') or getPoolRankFlagEnable('unstb_13') or getPoolRankFlagEnable('unstb_21') or getPoolRankFlagEnable('unstb_25') or getPoolRankFlagEnable('unstb_161')then
			card.joker_display_values.localized_text = "(161,25,21,13,11," .. localize("Ace", "ranks") .. ",9,7,5,3,1)"
		else
			card.joker_display_values.localized_text = "(" .. localize("Ace", "ranks") .. ",9,7,5,3)"
		end
end	

--Completely redefine Hack
jd["j_hack"] = {
	reminder_text = {
		{ ref_table = "card.joker_display_values", ref_value = "eligible_ranks" },
	},
	calc_function = function(card)
		if getPoolRankFlagEnable('unstb_0') or getPoolRankFlagEnable('unstb_1') then
			card.joker_display_values.eligible_ranks = "(0,1,2,3,4,5)"
		else
			card.joker_display_values.eligible_ranks = "(2,3,4,5)"
		end
	end,
	retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
		if held_in_hand then return 0 end
		return (not playing_card.config.center.no_rank and unstb_global.hack[playing_card.base.value]) and
			joker_card.ability.extra * JokerDisplay.calculate_joker_triggers(joker_card) or 0
	end
}

end