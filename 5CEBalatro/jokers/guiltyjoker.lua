local jokerInfo = {
	name = 'Guilty Joker',
	config = {},
	text = {
		'{C:mult}+1{} Mult per $',
		'Capped at {C:mult}+40{}',
		'{C:attention}Costs all $ to sell{}',
		'{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)'
	},
	rarity = 2,
	cost = 4,
	canBlueprint = true,
	canEternal = true
}


function jokerInfo.locDef(self)
	return {math.min(40,G.GAME.dollars)}
end

local function updateSellCost(self)
	self.sell_cost = -1 * G.GAME.dollars
	sell_cost_label = -1 * G.GAME.dollars
end

function jokerInfo.init(self)
	updateSellCost(self)
end

function jokerInfo.update(self,dt)
	updateSellCost(self)
end

function jokerInfo.calculate(self, context)
	updateSellCost(self)
	if SMODS.end_calculate_context(context) then
		return {
			message = localize { type = 'variable', key = 'a_mult', vars = { math.min(40,G.GAME.dollars) } },
			mult_mod = math.min(40,G.GAME.dollars),
		}
	end
end



return jokerInfo
	