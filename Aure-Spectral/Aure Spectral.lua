--- STEAMODDED HEADER
--- MOD_NAME: Aure Spectral
--- MOD_ID: aure_spectral
--- MOD_AUTHOR: [SDM_0, RattlingSnow353]
--- MOD_DESCRIPTION: Replaces the texture and name of the "Aura" spectral card to famous Steamodded developer "Aure". Code by SDM_0. Art by RattlingSnow353.
--- VERSION: 1.0.0
--- LOADER_VERSION_GEQ: 1.0.0 

----------------------------------------------
------------MOD CODE -------------------------

SMODS.Atlas{
    key = "aure",
    path = "aure.png",
    px = 71,
    py = 95
}

SMODS.Consumable:take_ownership('aura',
{pos = {x = 0, y = 0},
soul_pos = {x = 0, y = 1},
atlas = "aure"}, true)

function SMODS.current_mod.process_loc_text()
    G.localization.descriptions.Spectral.c_aura.name = "Aure"
end

----------------------------------------------
------------MOD CODE END----------------------