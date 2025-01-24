--- STEAMODDED HEADER
--- MOD_NAME: Match Box
--- MOD_ID: Matchbox
--- PREFIX: mbox
--- MOD_AUTHOR: [Nrio, elbe]
--- MOD_DESCRIPTION: Adds Slimy Card and The Rebirth. It is based on JellyTarots from Jellymods but not compatible
--- BADGE_COLOUR: 377a42

----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas {
    key = 'rebirth',
    path = 'c_rebirth_tarot.png',
    px = 71,
    py = 95
}
SMODS.Atlas {
    key = 'existenz',
    path = 'c_existenz_tarot.png',
    px = 71,
    py = 95
}
SMODS.Atlas {
    key = 'healing',
    path = 'c_healing_tarot.png',
    px = 71,
    py = 95
}
SMODS.Atlas {
    key = 'enhancements',
    path = 'Some Cards.png',
    px = 71,
    py = 95
}

SMODS.Consumable {
	key = 'rebirth',
	config = { mod_conv = 'm_mbox_slimy', max_highlighted = 1},
	set = 'Tarot',
	loc_txt = {
        name = "The Rebirth",
        text = {
            "Enhances {C:attention}#1#{} selected",
            "card into a",
            "{C:attention}#2#"
        }
    },
	pos = { x = 0, y = 0 },
	cost = 3,
	unlocked = true,
	discovered = false,
	atlas = 'rebirth',
    loc_vars = function(self, info_queue)
        info_queue[#info_queue+1] = G.P_CENTERS[self.config.mod_conv]
        return { vars = {self.config.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = self.config.mod_conv}}}
    end,
}
SMODS.Consumable {
	key = 'existenz',
	config = { mod_conv = 'm_mbox_geo', max_highlighted = 1},
	set = 'Tarot',
	loc_txt = {
        name = "The Existenz",
        text = {
            "Enhances {C:attention}#1#{}",
            "selected cards to",
            "{C:attention}#2#s"
        }
    },
	pos = { x = 0, y = 0 },
	cost = 3,
	unlocked = true,
	discovered = false,
	atlas = 'existenz',
    loc_vars = function(self, info_queue)
        info_queue[#info_queue+1] = G.P_CENTERS[self.config.mod_conv]
        return { vars = {self.config.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = self.config.mod_conv}}}
    end,
}
SMODS.Consumable {
	key = 'healing',
	config = { mod_conv = 'm_mbox_med', max_highlighted = 1},
	set = 'Tarot',
	loc_txt = {
        name = "The Healing",
        text = {
           "Enhances {C:attention}#1#{} selected",
            "card into a",
            "{C:attention}#2#"
        }
    },
	pos = { x = 0, y = 0 },
	cost = 3,
	unlocked = true,
	discovered = false,
	atlas = 'healing',
    loc_vars = function(self, info_queue)
        info_queue[#info_queue+1] = G.P_CENTERS[self.config.mod_conv]
        return { vars = {self.config.max_highlighted, localize{type = 'name_text', set = 'Enhanced', key = self.config.mod_conv}}}
    end,
}

SMODS.Enhancement {
	key = 'med',
	config = {},
	pos = { x = 0, y = 1 },
	loc_txt = {
        name = "Medical Card",
        text = {
            "Add copy without enhancement if this",
            "card is held in hand at end of round",
        },
    },
	unlocked = true,
	discovered = true,
	atlas = 'enhancements',
    label = 'Medical Card',
    calculate = function(self, card, context)
		if context.cardarea == G.hand and context.end_of_round then
            local _card = copy_card(card, nil, nil, G.playing_card)
            _card:add_to_deck()
            G.deck.config.card_limit = G.deck.config.card_limit + 1
            table.insert(G.playing_cards, _card)
            G.hand:emplace(_card)
            _card:set_ability(G.P_CENTERS['c_base'])
        end
	end
}
SMODS.Enhancement {
	key = 'slimy',
	config = {extra = 4},
	pos = { x = 0, y = 0 },
	loc_txt = {
        name = "Slimy Card",
            text = {
               "{C:green}#1# in #2#{} chance",
                "for {C:red}+#3#{} discard",
        },
    },
	unlocked = true,
	discovered = true,
	atlas = 'enhancements',
    label = 'Slimy Card',
    loc_vars = function(self, info_queue, center)
        return {vars = {G.GAME.probabilities.normal, self.config.extra, 1}}
    end,
    calculate = function(self, card, context)
		if context.cardarea == G.play and not context.repetition_only then
            if pseudorandom('sample') < G.GAME.probabilities.normal / card.ability.extra then
                ease_discard(1)
            end
        end
	end
}
SMODS.Enhancement {
	key = 'geo',
	config = {},
	pos = { x = 1, y = 0 },
	loc_txt = {
        name = "Geo Card",
            text = {
               "Change suit and rank",
               "of card when {C:attention}discarded",
        },
   },
	unlocked = true,
	discovered = true,
	atlas = 'enhancements',
    label = 'Geo Card',
    calculate = function(self, card, context)
		if context.discard and (G.discard) then
            G.E_MANAGER:add_event(Event({trigger = 'before',delay = 1,
                func = function()
                    local suit_prefix_list = {'S','H','D','C'}
                    if SMODS.findModByID("Bunco") then
                        table.insert(suit_prefix_list, 'bunc_FLEURON')
                        table.insert(suit_prefix_list, 'bunc_HALBERD')
                    end
                    if SMODS.findModByID("SixSuits") then
                        table.insert(suit_prefix_list, 'six_MOON')
                        table.insert(suit_prefix_list, 'six_STAR')
                    end
                    if SMODS.findModByID("InkAndColor") then
                        table.insert(suit_prefix_list, 'ink_Ccolor')
                        table.insert(suit_prefix_list, 'ink_Cink')
                    end
                    local suit_prefix = pseudorandom_element(suit_prefix_list)
                    local rank_suffix = pseudorandom_element({'2','3','4','5','6','7','8','9','T','J','Q','K','A'})
                    card:set_base(G.P_CARDS[suit_prefix..'_'..rank_suffix])
                    return true
                end
            }))
        end
	end
}

if SMODS.findModByID("Cryptid") then
    SMODS.Back {
        name = "Globe Deck",
        key = "globe",
        config = { cry_force_enhancement = "m_mbox_geo" },
        pos = { x = 1, y = 0 },
        atlas = "enhancements",
        loc_txt = {
            name = "Globe Deck",
            text = {
                "All {C:attention}playing cards{}",
                "are {C:attention,T:m_mbox_geo}Geo Cards{}",
                "Cards cannot change enhancements",
                "{s:0.8,C:inactive}",
            },
        },
    }
end

SMODS.Challenge {
    key = 'globe',
    jokers = {},
    deck = {
        type = 'Challenge Deck',
        cards = {
            {s='D',r='2',e='m_geo',},
            {s='D',r='3',e='m_geo',},
            {s='D',r='4',e='m_geo',},
            {s='D',r='5',e='m_geo',},
            {s='D',r='6',e='m_geo',},
            {s='D',r='7',e='m_geo',},
            {s='D',r='8',e='m_geo',},
            {s='D',r='9',e='m_geo',},
            {s='D',r='T',e='m_geo',},
            {s='D',r='J',e='m_geo',},
            {s='D',r='Q',e='m_geo',},
            {s='D',r='K',e='m_geo',},
            {s='D',r='A',e='m_geo',},
            {s='C',r='2',e='m_geo',},
            {s='C',r='3',e='m_geo',},
            {s='C',r='4',e='m_geo',},
            {s='C',r='5',e='m_geo',},
            {s='C',r='6',e='m_geo',},
            {s='C',r='7',e='m_geo',},
            {s='C',r='8',e='m_geo',},
            {s='C',r='9',e='m_geo',},
            {s='C',r='T',e='m_geo',},
            {s='C',r='J',e='m_geo',},
            {s='C',r='Q',e='m_geo',},
            {s='C',r='K',e='m_geo',},
            {s='C',r='A',e='m_geo',},
            {s='H',r='2',e='m_geo',},
            {s='H',r='3',e='m_geo',},
            {s='H',r='4',e='m_geo',},
            {s='H',r='5',e='m_geo',},
            {s='H',r='6',e='m_geo',},
            {s='H',r='7',e='m_geo',},
            {s='H',r='8',e='m_geo',},
            {s='H',r='9',e='m_geo',},
            {s='H',r='T',e='m_geo',},
            {s='H',r='J',e='m_geo',},
            {s='H',r='Q',e='m_geo',},
            {s='H',r='K',e='m_geo',},
            {s='H',r='A',e='m_geo',},
            {s='S',r='2',e='m_geo',},
            {s='S',r='3',e='m_geo',},
            {s='S',r='4',e='m_geo',},
            {s='S',r='5',e='m_geo',},
            {s='S',r='6',e='m_geo',},
            {s='S',r='7',e='m_geo',},
            {s='S',r='8',e='m_geo',},
            {s='S',r='9',e='m_geo',},
            {s='S',r='T',e='m_geo',},
            {s='S',r='J',e='m_geo',},
            {s='S',r='Q',e='m_geo',},
            {s='S',r='K',e='m_geo',},
            {s='S',r='A',e='m_geo',},
        }
    },
    restrictions = {
        banned_cards = {
            {id = 'c_magician'},
            {id = 'c_empress'},
            {id = 'c_heirophant'},
            {id = 'c_chariot'},
            {id = 'c_devil'},
            {id = 'c_tower'},
            {id = 'c_lovers'},
            {id = 'c_justice'},
            {id = 'c_rebirth_tarot'},
            {id = 'c_healing_tarot'},
            {id = 'c_incantation'},
            {id = 'c_grim'},
            {id = 'c_familiar'},
            {id = 'p_standard_normal_1', ids = {
                'p_standard_normal_1','p_standard_normal_2','p_standard_normal_3','p_standard_normal_4','p_standard_jumbo_1','p_standard_jumbo_2','p_standard_mega_1','p_standard_mega_2',
            }},
            {id = 'j_marble'},
            {id = 'j_vampire'},
            {id = 'j_midas_mask'},
            {id = 'j_certificate'},
            {id = 'v_magic_trick'},
            {id = 'v_illusion'},
        },
        banned_tags = {
            {id = 'tag_standard'},
        },
        banned_other = {
        }
    }
}
----------------------------------------------
------------MOD CODE END----------------------
