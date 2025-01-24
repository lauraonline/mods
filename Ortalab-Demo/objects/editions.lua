SMODS.Shader({key = 'greyscale', path = "greyscale.fs"})
SMODS.Shader({key = 'fluorescent', path = "fluorescent.fs"})
SMODS.Shader({key = 'anaglyphic', path = "anaglyphic.fs"})
SMODS.Shader({key = 'overexposed', path = "overexposed.fs"})

SMODS.Edition({
    key = "anaglyphic",
    discovered = false,
    unlocked = true,
    shader = 'anaglyphic',
    config = { chips = 20, mult = 6 },
    in_shop = true,
    weight = 20,
    extra_cost = 4,
    apply_to_float = true,
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits and (card or Ortalab.config.full_credits) then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'eremel', title = 'Shader'} end
        return { vars = {self.config.chips, self.config.mult}}
    end,
    calculate = function(self, card, context)
        if context.pre_joker or (context.main_scoring and context.cardarea == G.play) then
            return {
                chips = card.edition.chips,
                mult = card.edition.mult
            }     
        end
    end
})

SMODS.Edition({
    key = "fluorescent",
    discovered = false,
    unlocked = true,
    shader = 'fluorescent',
    config = { p_dollars = 4 },
    in_shop = true,
    weight = 12,
    extra_cost = 4,
    apply_to_float = true,
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits and (card or Ortalab.config.full_credits) then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'eremel', title = 'Shader'} end
        return { vars = {self.config.p_dollars}, key = card and card.config and card.config.center.set == 'Joker' and 'e_ortalab_fluorescent_joker'}
    end,
    calculate = function(self, card, context)
        if (context.cardarea == G.jokers and context.end_of_round) or (context.main_scoring and context.cardarea == G.play) then
            return {
                dollars = card.edition.p_dollars
            }     
        end
    end
})

SMODS.Edition({
    key = "greyscale",
    shader = "greyscale",
    discovered = false,
    unlocked = true,
    config = {swap = true},
    in_shop = true,
    weight = 8,
    extra_cost = 6,
    badge_colour = HEX("858585"),
    apply_to_float = true,
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits and (card or Ortalab.config.full_credits) then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'eremel', title = 'Shader'} end
        return { vars = { self.config.chips, self.config.mult, self.config.x_mult } }
    end,
    calculate = function(self, card, context)
        if context.pre_joker or (context.main_scoring and context.cardarea == G.play) then
            return {
                swap = true,
                message = localize('ortalab_swap'),
                colour = G.C.PURPLE
            }     
        end
    end
})

-- Awaiting retrigger API
SMODS.Edition({
    key = "overexposed",
    discovered = false,
    unlocked = true,
    shader = 'overexposed',
    config = { extra = {retriggers = 1 }},
    in_shop = true,
    weight = 3,
    extra_cost = 4,
    apply_to_float = true,
    loc_vars = function(self, info_queue, card)
        if Ortalab.config.artist_credits and (card or Ortalab.config.full_credits) then info_queue[#info_queue+1] = {generate_ui = ortalab_artist_tooltip, key = 'eremel', title = 'Shader'} end
        return { vars = { self.config.extra.retriggers } }
    end,
    calculate = function(self, card, context)
        if context.repetition_only or (context.retrigger_joker_check and context.other_card == card) then
            return {
                repetitions = card.edition.extra.retriggers,
                card = card,
                colour = G.C.GREEN,
                message = localize('k_again_ex')
            }     
        end
    end
})