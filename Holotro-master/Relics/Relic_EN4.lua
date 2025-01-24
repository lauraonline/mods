----
SMODS.Atlas{
    key = "Relic_Justice",
    path = "Relic_Justice.png",
    px = 71,
    py = 95
}

SMODS.Joker{
    key = "Relic_Gigi",
    talent = "Gigi",
    loc_txt = {
        name = "Gauntlet of Da Fister",
        text = {
            'All played cards get {C:attention}fisted{}',
            'and become {C:attention}Glass{} when scored.',
            'Gain {X:mult,C:white} X#1# {} Mult every time a card',
            'is already a {C:attention}Glass Card{} before getting {C:attention}fisted{}.',
            '(Currently {X:mult,C:white} X#2# {} Mult)'
        }
    },
    config = { extra = { Xmult = 4, Xmult_mod = 0.25 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_glass
        return { vars = { card.ability.extra.Xmult_mod, card.ability.extra.Xmult} }
    end,
    rarity = "hololive_Relic",
    cost = 20,

    atlas = 'Relic_Justice',
    pos = { x = 1, y = 0 },
    soul_pos = { x = 1 , y = 1 },

    upgrade = function(self, card)
        card:juice_up(0.5, 0.5)
        self.config.extra.Xmult = self.config.extra.Xmult + self.config.extra.Xmult_mod
        return {
            message = "Upgrade!",
            colour = G.C.XMULT,
            card = card
        }
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers then
            if context.before and context.scoring_hand then
                for i = 1, #context.scoring_hand do
                    if SMODS.has_enhancement(context.scoring_hand[i], "m_glass") and not context.blueprint then
                        self:upgrade(card)
                    else
                        context.scoring_hand[i]:set_ability(G.P_CENTERS.m_glass, nil, true)
                    end
                    return {
                        message = "Fisted!",
                        colour = G.C.GREY,
                        card = context.other_card
                    }
                end
            elseif context.joker_main then
                card:juice_up(0.5, 0.5)
                return {
                    Xmult_mod = card.ability.extra.Xmult
                }
            end
        end
    end
}

SMODS.Joker{
    key = "Relic_Ceci",
    talent = "Ceci",
    loc_txt = {
        name = "Violance of the Automaton",
        text = {
            'All {C:attention}Glass Cards{} become {C:attention}very durable{}.',
            'Gain {X:mult,C:white} X#1# {} Mult every time a {C:attention}Glass Card{}',
            'is prevented from shattering.',
            '(Currently {X:mult,C:white} X#2# {} Mult)'
        }
    },
    config = { extra = { Xmult = 4, Xmult_mod = 1 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_glass
        return { vars = { card.ability.extra.Xmult_mod, card.ability.extra.Xmult} }
    end,
    rarity = "hololive_Relic",
    cost = 20,

    atlas = 'Relic_Justice',
    pos = { x = 2, y = 0 },
    soul_pos = { x = 2, y = 1 },

    upgrade = function(self, card)
        card:juice_up(0.5, 0.5)
        card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_mod
        return {
            message = "Upgrade!",
            colour = G.C.XMULT,
            card = card
        }
    end,
    calculate = function(self, card, context)
        if context.about_to_shatter and not context.blueprint then
            self:upgrade(card)
            return {very_durable = true}
        end
        if context.cardarea == G.jokers and context.scoring_hand then
            if context.joker_main then
                card:juice_up(0.5, 0.5)
                return {
                    x_mult = card.ability.extra.Xmult
                }
            end
        end
    end
}

----