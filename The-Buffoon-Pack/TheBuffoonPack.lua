--- STEAMODDED HEADER
--- MOD_NAME: The Buffoon Pack
--- MOD_ID: Me_TheBuffoonPack
--- MOD_AUTHOR: [Me, elbe]
--- MOD_DESCRIPTION: Adds 5 new jokers, a whole pack!
--- PREFIX: tbp
--- BADGE_COLOR: 47b28d
----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas({
    key = "calendar",
    atlas_table = "ASSET_ATLAS",
    path = "j_calendar.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "gladiator",
    atlas_table = "ASSET_ATLAS",
    path = "j_gladiator.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "mansion",
    atlas_table = "ASSET_ATLAS",
    path = "j_mansion.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "microscope",
    atlas_table = "ASSET_ATLAS",
    path = "j_microscope.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "tungsten",
    atlas_table = "ASSET_ATLAS",
    path = "j_tungsten.png",
    px = 71,
    py = 95
})

local calendar = SMODS.Joker{
	name = "Calendar Joker",
	key = "calendar",
    config = { handsavailiable = 5 },
    pos = { x = 0, y = 0 },
	loc_txt = {
        name = "Calendar Joker",
        text = {'Played {C:attention}7{}s have a {C:green}#2# in 7{} chance to give an additional hand', '(#1# Hands left this round)'}
	},
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = false,
	blueprint_compat = false,
	perishable_compat = true,
	atlas = "calendar",
	loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.handsavailiable,''..(G.GAME and G.GAME.probabilities.normal or 1) } }
	end,
	calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 7 then
                if pseudorandom('calendar') < G.GAME.probabilities.normal/7 then
                    if card.ability.handsavailiable ~= 0 then
                        ease_hands_played(1)
                        card.ability.handsavailiable = card.ability.handsavailiable - 1
                        return {
                            extra = {focus = card, message = '+1 Hand', colour = G.C.CHIPS},
                            card = card
                        }
                    end
                end
            end
        elseif context.first_hand_drawn then
            card.ability.handsavailiable = 5
        end
	end,
}
local gladiator = SMODS.Joker{
	name = "Gladiator Joker",
	key = "gladiator",
    config = { safe = true },
    pos = { x = 0, y = 0 },
	loc_txt = {
        name = "Gladiator Joker",
        text = {
            'If the {C:attention}first hand{} of round',
            'has exactly {C:attention}3{} cards,' ,
            'destroy 2 of them at random.',
            '{C:inactive}(If on first hand.',
            '{C:inactive}discard is used, or a hand is played that does not trigger this',
            '{C:inactive}this is destroyed)'}
	},
    rarity = 3,
    cost = 7,
    unlocked = true,
    discovered = false,
	blueprint_compat = false,
	perishable_compat = true,
	atlas = "gladiator",
	loc_vars = function(self, info_queue, center)
        return { vars = {  } }
	end,
	calculate = function(self, card, context)
        if context.first_hand_drawn then
            local eval = function() return G.GAME.current_round.hands_played == 0 and G.GAME.current_round.discards_used == 0 end
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "PRESENT THE CHALLENGERS!"})
            juice_card_until(card, eval, true)
            card.ability.safe = false
        end
        if context.after and context.full_hand and #context.full_hand == 3 and G.GAME.current_round.hands_played == 0 and G.GAME.current_round.discards_used == 0 then
            card.ability.safe = true
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 1,
                func = function()
                    local loser1 = pseudorandom_element(context.full_hand)
                    local loser2 = pseudorandom_element(context.full_hand)
                    sendInfoMessage("Played hand with gladiator", "TheBuffoonPack")
                    sendInfoMessage(#context.full_hand, "TheBuffoonPack")
                    if #context.full_hand < 3 then return true end
                    sendInfoMessage("Hand is proper with gladiator", "TheBuffoonPack")
                    if loser1 == loser2 then
                        while loser1 == loser2 do
                            loser2 = pseudorandom_element(context.full_hand)
                        end
                        
                    end
                    sendInfoMessage("Got past loop", "TheBuffoonPack")
                    if loser1.removed == nil and loser1 ~= nil then loser1:start_dissolve(nil,nil,3) end
                    if loser2.removed == nil and loser2 ~= nil then loser2:start_dissolve(nil,nil,3) end
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 2,
            }))
            
        elseif context.after and not card.ability.safe then
            card:start_dissolve(nil,nil,3)
        elseif context.discard and not card.ability.safe then
            card:start_dissolve(nil,nil,3)
        end
	end,
}
local rich_joker = SMODS.Joker{
	name = 'Rich Joker',
	key = "rich_joker",
    config = {},
    pos = { x = 0, y = 0 },
	loc_txt = {
        name= 'Rich Joker',
        text= {'If played poker hand contains a {C:attention}Full House{}, ', 'give a card a random {C:attention}Edition{} and, ', ' lose ${C:money}3{}'}
	},
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = false,
	blueprint_compat = true,
	perishable_compat = true,
	atlas = "mansion",
	loc_vars = function(self, info_queue, center)
        return { vars = {  } }
	end,
	calculate = function(self, card, context)
        if context.after and context.poker_hands and next(context.poker_hands['Full House']) then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 1,
                func = function()  
                    local winner1 = pseudorandom_element(context.full_hand)
                    local edition = poll_edition('mansion', nil, true, true)
                    winner1:set_edition(edition, true)
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = "-$3"})
                    ease_dollars(-3)
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 2,
            }))
        end
	end,
}
local temple = SMODS.Joker{
	name = 'Temple',
	key = "temple",
    config = {
        targettedsuit = "Spades",
        targettedrank = "Ace",
        targettedID = 14
    },
    pos = { x = 0, y = 0 },
	loc_txt = {
        name= 'Temple',
        text= {'{C:red}+#1#{} Mult', 'Played {C:attention}#2#{} of {C:attention}#3#{} give this +3 mult', '{C:inactive}(Card changes at the beginning of each round){}'}
	},
    rarity = 2,
    cost = 7,
    unlocked = true,
    discovered = false,
	blueprint_compat = true,
	perishable_compat = true,
	atlas = "microscope",
	loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.mult,center.ability.targettedrank, localize(center.ability.targettedsuit, "suits_plural") } }
	end,
	calculate = function(self, card, context)
        if context.individual and not context.blueprint and context.cardarea == G.play then
            if context.other_card:get_id() == card.ability.targettedID and context.other_card:is_suit(card.ability.targettedsuit) then
                card.ability.mult = card.ability.mult + 3
                return {
                    extra = {focus = card, message = '+3 Mult', colour = G.C.MULT},
                    card = card
                }
            end
        end
        if context.first_hand_drawn and not context.blueprint then
            card.ability.targettedrank = 'Ace'
            card.ability.targettedsuit = 'Spades'
            card.ability.targettedID = 14
            local valid_idol_cards = {}
            for k, v in ipairs(G.playing_cards) do
                if v.ability.effect ~= 'Stone Card' then
                    valid_idol_cards[#valid_idol_cards+1] = v
                end
            end
            if valid_idol_cards[1] then 
                local idol_card = pseudorandom_element(valid_idol_cards, pseudoseed('microscope'..G.GAME.round_resets.ante))
                card.ability.targettedrank = idol_card.base.value
                card.ability.targettedID = idol_card.base.id
                card.ability.targettedsuit = idol_card.base.suit
            end
        end
        if SMODS.end_calculate_context(context) then
            return {
                mult_mod = card.ability.mult,
                card = card,
                message = '+' .. card.ability.mult .. ' Mult'
            }
        end
	end,
}
local tungsten = SMODS.Joker{
	name = 'Tungsten Joker',
	key = "tungsten",
    config = {
        h_size = -1,
        roundsuntilsoul = 3,
        jobsdone = false
    },
    pos = { x = 0, y = 0 },
	loc_txt = {
        name='Tungsten Joker',
        text= {
            '{C:attention}#1#{} Hand size,',
            'breaks in {C:attention}three{} rounds to create {C:attention}The Soul{}',
            '{C:inactive}({C:attention}#2#{}{C:inactive}/3 rounds remain){}',
            '{C:inactive}(Must have room){}'}
	},
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = false,
	blueprint_compat = false,
	perishable_compat = true,
	atlas = "tungsten",
	loc_vars = function(self, info_queue, center)
        return { vars = { center.ability.h_size, center.ability.roundsuntilsoul } }
	end,
	calculate = function(self, card, context)
        if context.first_hand_drawn then
            card.ability.jobsdone = false
        end
        if context.end_of_round and not context.repetition and not card.ability.jobsdone then
            if card.ability.roundsuntilsoul ~= 0 then
                card.ability.roundsuntilsoul = card.ability.roundsuntilsoul - 1
                card.ability.jobsdone = true
                if card.ability.roundsuntilsoul == 0 then
                    if G.consumeables.cards ~= nil then
                        if #G.consumeables.cards < G.consumeables.config.card_limit then
                            local OurSoul = create_card("Spectral", G.consumables, nil, nil, nil, nil, "c_soul")
                            OurSoul:add_to_deck()
                            G.consumeables:emplace(OurSoul)
                        end
                        card:start_dissolve(nil,nil,3)
                    else
                        local OurSoul = create_card("Spectral", G.consumables, nil, nil, nil, nil, "c_soul")
                        OurSoul:add_to_deck()
                        G.consumeables:emplace(OurSoul)
                        card:start_dissolve(nil,nil,3)
                    end
                end
                sendInfoMessage("REDUCED SOUL COUNT", "TheBuffoonPack")
                return {
                    message = "Strength Up!",
                    colour = G.C.RED
                }
            end
            return {
                message = "MAXIMUM POWER!",
                colour = G.C.RED
            }
        end
	end,
}

if JokerDisplay then
    local jd_def = JokerDisplay.Definitions

    jd_def["j_tbp_temple"] = { -- Jokester
        text = {
            { text = "+" },
            { ref_table = "card.ability", ref_value = "mult" }
        },
        text_config = { colour = G.C.MULT },
    }
end