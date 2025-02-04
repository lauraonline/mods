local internal_name = "ethereal_vault"
local display_name = "Ethereal Vault"

local deck = {
    name = internal_name,
    config = {},
    sprite_pos = {x = 4, y = 0},
    setup_functions = {}
}

deck.loc_txt = {
    name = display_name,
    text = {
        "Start with an",
        "{C:attention}Eternal {C:dark_edition}Negative{C:attention} Vault",
    }
}

deck.setup_functions.modify_base_cards = function(base_cards)
    return base_cards
end

local function deck_joker(name, edition, silent, eternal, modpack)
    return {
        name = name,
        edition = edition,
        silent = silent,
        eternal = eternal,
        modpack = modpack,
    }
end

deck.setup_functions.add_deck_jokers = function()
    return {
        deck_joker("vault", "negative", nil, true, true)
    }
end

return deck