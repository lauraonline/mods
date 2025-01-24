assert(SMODS.load_file("./func/numbers.lua"))()
assert(SMODS.load_file("./func/words/words.lua"))()
assert(SMODS.load_file("./func/word_utils.lua"))()
assert(SMODS.load_file("./modules/misc.lua"))()

local pickableSuit = { "S", "H", "C", "D" }
local pickableRank = { "2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A" }
local rankToNumber = { ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5, ["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9, ["T"] = 10,
    ["J"] = 11, ["Q"] = 12, ["K"] = 13, ["A"] = 14 }
local function concat_table(t1, t2)
    for i = 1, #t2 do
        t1[#t1 + 1] = t2[i]
    end
    return t1
end

local function randomCard()
    local suit = aiko_pickRandomInTable(pickableSuit)
    local rank = aiko_pickRandomInTable(pickableRank)
    return suit .. "_" .. rank
end

local function randomSameRank(cardCode)
    local suit = string.sub(cardCode, 1, 1)
    local rank = string.sub(cardCode, 3, 3)
    local newSuit = aiko_pickRandomInTable(pickableSuit)
    while newSuit == suit do
        newSuit = aiko_pickRandomInTable(pickableSuit)
    end
    return newSuit .. "_" .. rank
end

local function randomSameSuit(cardCode)
    local suit = string.sub(cardCode, 1, 1)
    local rank = string.sub(cardCode, 3, 3)
    local newRank = aiko_pickRandomInTable(pickableRank)
    while newRank == rank do
        newRank = pickableRank[math.random(1, 13)]
    end
    return suit .. "_" .. newRank
end

local function randomConsecutiveRank(cardCode, up, randomSuit)
    local suit = string.sub(cardCode, 1, 1)
    local rank = string.sub(cardCode, 3, 3)
    local newRank = rank
    newRank = pickableRank[math.fmod(rankToNumber[rank] - 1, #pickableRank) + 1]
    if randomSuit then
        local newSuit = aiko_pickRandomInTable(pickableSuit)
        while newSuit == suit do
            newSuit = aiko_pickRandomInTable(pickableSuit)
        end
        return newSuit .. "_" .. newRank
    else
        return suit .. "_" .. newRank
    end
end

local example_words = {
    "cry",
    "card",
    "jimbo",
    "thrash",
    "sticker",
    "foreword",
    "mainframe",
    "mainlander",
    "hyperactive",
    "skeletonised",
    "neanderthaler",
    "televisionally",
    "demographically",
    "tropostereoscope",
    "erythroneocytosis",
    "heteroscedasticity",
    "unmisunderstandable",
    "adrenocorticosteroid",
    "poluphloisboiotatotic",
    "polioencephalomyelitis",
    "overintellectualization",
    "formaldehydesulphoxylate",
    "demethylchlortetracycline",
    "##########################",
    "electroencephalographically",
    "antidisestablishmentarianism",
    "cyclotrimethylenetrinitramine",
    "##############################",
    "dichlorodiphenyltrichloroethane",
}
local function replace_char(pos, str, r)
    return str:sub(1, pos-1) .. r .. str:sub(pos+1)
end
function check_word(str_arr_in, length)
    local wild_count = 0
    local word_composite = ""
    for _, val in ipairs(str_arr_in) do
        if val == "#" then
            wild_count = wild_count + 1
        end
        word_composite = word_composite..val
    end
    --print("CHECKING "..word_composite.." WITH "..wild_count)
    if wild_count == 0 then
        if words[word_composite] and #str_arr_in == length then
            return { valid = true, word = word_composite }
        else
            return { valid = false, word = nil }
        end
    end
    for i, v in ipairs(str_arr_in) do
        if v == "#" then
            for k, v2 in ipairs(aiko_alphabets_no_wilds)do
                local new_arr = {}
                for m, v3 in ipairs(str_arr_in) do
                    if i == m then
                        table.insert(new_arr,v2)
                    else
                        table.insert(new_arr,v3)
                    end
                end
                local chk = check_word(new_arr,length)
                if chk.valid then
                    return {word = chk.word, valid = true}
                end
            end 
        end 
    end
    return { valid = false, word = nil }
    
end
for i = 3, 31 do
    local exampler = {}
    for j = 1, #example_words[i-2] do
        local c = example_words[i-2]:sub(j,j)
        table.insert(exampler,{
            randomCard(),
            true,
            c
        })
    end
        

    SMODS.PokerHand {
        key = i.."-letter Word",
        visible = false,
        example = exampler,
        loc_txt = {
            ["en-us"]={
                name =  i.."-letter Word",
                description = { 'Create a valid '..i..'-letter English word', 'with Exact Amount of Character' },
            },
            ["th_TH"]={
                name =  "คำยาว "..i.." ตัวอักษร",
                description = { 'สร้างคำภาษาอังกฤษที่มี '..i..'ตัวอักษร', 'โดยที่ตัวอักษรไม่ขาดไม่เกิน' },
            },
        },
        evaluate = function(parts, hand)
            if not G.GAME.letters_enabled then return {} end
            local hand_count = 0
            for _,v in pairs(G.hand.cards) do
                if v.highlighted then
                    hand_count = hand_count + 1
                end
            end
            local word_hand = {}
            table.sort(hand, function(a,b) return a.T.x < b.T.x end)
            for _, v in pairs(hand) do
                
                table.insert(word_hand, v.ability.aikoyori_letters_stickers)
                    
            end
            if #word_hand ~= i then
                return {}
            end
            local wordData = check_word(word_hand, i)
            if wordData.valid then
                if (G.STATE == G.STATES.HAND_PLAYED)then  
                    attention_text({
                        scale = 1.5, text = string.upper(wordData.word), hold = 2, align = 'tm',
                        major = G.play, offset = {x = 0, y = -1}
                    })
                end
                return {hand}
            else 
                return {}
            end
        end,
        chips = 8 * i + (i-1.22) ^ (1 + i * 0.17),
        mult = ((i - 2) ^ 1.07) + 0.75 * i,
        l_chips = 5*i,
        l_mult = 2*i,
    }
end