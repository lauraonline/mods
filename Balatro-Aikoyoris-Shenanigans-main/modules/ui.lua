
assert(SMODS.load_file("./modules/misc.lua"))() 

SMODS.current_mod.config_tab = function()
	return {n = G.UIT.ROOT, config = {
        align = "cm"
	}, nodes = {
        create_text_input({prompt_text = 'X of a Kind Limit', extended_corpus = true, ref_table = {
            aikoyori_mod_config,
        }, ref_value = 'x_of_a_kind_limit', text_scale = 0.7, w = 1, h = 0.6,
        onUpdate = function(val) 
            aikoyori_mod_config.x_of_a_kind_limit = val
          end}),
	}}
end