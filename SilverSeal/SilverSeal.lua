--- STEAMODDED HEADER
--- MOD_NAME: Silver Seal
--- MOD_ID: SilverSeal
--- MOD_AUTHOR: [mwithington, AxBolduc]
--- MOD_DESCRIPTION: Adds a Silver Seal to the game
--- PREFIX: silver

----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas {
    key = "silver_seal",
    path = "silver_seal.png",
    px = 71,
    py = 95
}
local seal = SMODS.Seal {
    name = "silver_seal",
    key = "silver_seal",
    badge_colour = HEX("a0a5ad"),
    loc_txt = {
        label = 'Silver Seal',
        name = 'Silver Seal',
        text = {
            "When played",
            "apply a random {C:attention}enhancment."
        }
    },
    atlas = "silver_seal",
    pos = {x=0, y=0},
    calculate = function(self, card, context)
        if context.cardarea == G.play then
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                delay = 0.2,
                func = (function()
                        local edition = poll_edition('silver_seal', nil, true, true)
                        card:set_edition(edition, true)
                        card:juice_up(0.3, 0.5)
                    return true
                end)
            }))
        end
    end
}

SMODS.Atlas {
    key = "clone",
    path = "c_clone.png",
    px = 71,
    py = 95
}
SMODS.Consumable {
    set = 'Spectral',
    key = 'clone',
    loc_txt = {
        name = "Clone",
        text = {
            "Add a {C:gray}Silver Seal{}",
            "to {C:attention}1{} selected",
            "card in your hand"
        }
    },
    atlas = 'clone',
    pos = { x = 0, y = 0 },
    config = {max_highlighted = 1, extra = seal.key,},
    cost = 4,
    use = function(self, card, area, copier)
        local conv_card = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('tarot1')
                local spectral = copier or card
                spectral:juice_up(0.3, 0.5)
                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                conv_card:set_seal(card.ability.extra, nil, true)
                return true
            end
        }))
        delay(0.5)
    end,
    can_use = function(self, card)
        if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK then
            if #G.hand.highlighted >= 1 and #G.hand.highlighted <= card.ability.max_highlighted then
                for i=1, #G.hand.highlighted do
                    if G.hand.highlighted[i].ability.effect == "Stone Card" then
                        return false
                    end
                end
                return true
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = "silver_seal_seal", set = 'Other' }
        return { vars = { }}
    end
}

----------------------------------------------
------------MOD CODE END----------------------
