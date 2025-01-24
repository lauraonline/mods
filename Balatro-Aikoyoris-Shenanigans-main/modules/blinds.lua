assert(SMODS.load_file("./modules/atlasses.lua"))()
assert(SMODS.load_file("./modules/misc.lua"))()
assert(SMODS.load_file("./func/words/puzzle_words.lua"))()

SMODS.Blind{
    key = "the_thought",
    dollars = 5,
    mult = 2,
    boss_colour =HEX('95df3e'),
    atlas = 'aikoyoriBlindsChips', 
    boss = {min = 1, max = 10},
    pos = { x = 0, y = 0 },
    debuff = {},
    vars = {},
    set_blind = function(self)
        G.GAME.aiko_puzzle_win = false
        G.GAME.word_todo = aiko_pickRandomInTable(puzzle_words)
        print ("Word is "..G.GAME.word_todo)
        G.E_MANAGER:add_event(
            Event({
                delay = 1,
                func = function()
                    ease_background_colour{new_colour = HEX('95df3e'), special_colour = HEX('ffd856'), tertiary_colour = G.C.BLACK, contrast = 3}
                    return true
                end
            })
        )
    end,
    in_pool = function(self)
        return G.GAME.letters_enabled or false
    end,
    disable = function(self)
        
    end,
    defeat = function(self)
    end,
    press_play = function(self)
                
        local word_hand = {}
        local word_composite = ""
        for _, v in pairs(G.hand.cards) do
            if v.highlighted then
                table.insert(word_hand,v)
            end
        end
        table.sort(word_hand, function(a,b) return a.T.x < b.T.x end)
        for _, v in pairs(word_hand) do
            word_composite = word_composite..v.ability.aikoyori_letters_stickers
        end
        attention_text({
            scale = 1.5, text = "PUZZLE GUESS "..string.upper(word_composite), hold = 2, align = 'tm',
            major = G.play, offset = {x = 0, y = -1}
        })
        print()
    end

}