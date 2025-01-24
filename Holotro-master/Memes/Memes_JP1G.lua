----

SMODS.Atlas{
    key = "Fubuki_MFG",
    path = "Fubuki_MFG.png",
    px = 71,
    py = 95
}
SMODS.Joker{
    key = "Fubuki_MFG",
    talent = "Fubuki",
    loc_txt = {
        name = "Medical Fee Gamble",
        text = {
            'Every shop item has a',
            '{C:green}#1# in 6{} chance to be {C:attention}free{},',
            'otherwise the price',
            'would be {C:attention}doubled{}.',
            '{C:inactive,s:0.8}(Does not work on: reroll),'
        }
    },
    config = { extra = {} },
    rarity = 2,
    cost = 8,
    atlas = 'Fubuki_MFG',
    pos = { x = 0, y = 0 },
    loc_vars = function(self, info_queue, card)
        return { vars = { math.min(G.GAME.probabilities.normal * 2 , 6 ) , } }
    end,
    calculate = function(self, card, context)
        if context.buying_card or context.buying_booster_pack or context.buying_voucher then
            card:juice_up(0.5, 0.5)
            if pseudorandom('fubuki') < G.GAME.probabilities.normal / 3 then
                context.card.cost = 0
                return {
                    message = 'Free!',
                    colour = G.C.MONEY,
                    card = card
                }
            else
                context.card.cost = context.card.cost * 2
                return {
                    message = 'Doubled!',
                    colour = G.C.MONEY,
                    card = card
                }
            end
        end
    end
}

----