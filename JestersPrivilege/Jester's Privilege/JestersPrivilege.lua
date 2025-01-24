--- STEAMODDED HEADER
--- MOD_NAME: Jester's Privilege
--- MOD_ID: JestersPrivilege
--- MOD_AUTHOR: [unethikeele]
--- MOD_DESCRIPTION: Adds some joker ideas I had that hopefully fit in the Vanilla theme.
--- DEPENDENCIES: [Steamodded>=1.0.0~ALPHA-0812d]
--- PREFIX: mvan
----------------------------------------------
------------MOD CODE -------------------------

--Creates an atlas for cards to use
SMODS.Atlas {
  key = "JestersPrivilegeAtlas",
  path = "JPAtlas.png",
  px = 71,
  py = 95
}


SMODS.Joker {
  key = 'Microtransaction',
  loc_txt = {
    name = 'Microtransaction',
    text = {
      "Every item purchased", "from the shop adds", "{X:mult,C:white}X#2#{} to this card", "{C:inactive}Currently {X:mult,C:white}X#1#{} {C:inactive}Mult"
    }
  },
  config = { extra = { x_mult = 1, x_mult_gain = 0.1 } },
  rarity = 2,
  atlas = 'JestersPrivilegeAtlas',
  pos = { x = 1, y = 0 },
  cost = 6,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,


  loc_vars = function(self, info_queue, card)
    return { vars = {card.ability.extra.x_mult, card.ability.extra.x_mult_gain } }
  end,

  calculate = function(self, card, context)
    if context.buying_card or context.open_booster and not context.blueprint and not (context.card == card) then
        card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
            G.E_MANAGER:add_event(Event({
                    func = function()
                        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')}); return true
                        end
                }))
                end
            if context.cardarea == G.jokers and not context.before and not context.after then
                return {
                    message = localize {type = 'variable', key = 'a_xmult', vars = {card.ability.extra.x_mult} },
                    Xmult_mod = card.ability.extra.x_mult
                }
            end
    end
}


SMODS.Joker {
  key = 'buzzerbeater',
  loc_txt = {
    name = 'Buzzer Beater',
    text = {
      "Defeating the ante", "on the last hand", "increases by {X:mult,C:white}X#2#{}", "{C:inactive}Currently {X:mult,C:white}X#1#{} {C:inactive}Mult"
    }
  },
  config = { extra = { x_mult = 1, x_mult_gain = 0.5 } },
  rarity = 2,
  atlas = 'JestersPrivilegeAtlas',
  pos = { x = 0, y = 0 },
  cost = 6,
  unlocked = true,
  discovered = false,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,


  loc_vars = function(self, info_queue, card)
    return { vars = {card.ability.extra.x_mult, card.ability.extra.x_mult_gain } }
  end,

  calculate = function(self, card, context)
    if context.joker_main and context.cardarea == G.jokers then
        if G.GAME.blind.boss and G.GAME.current_round.hands_left == 0 then
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
            G.E_MANAGER:add_event(Event({
                func = function()
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')}); return true
                    end
            }))
            end
            return {
                message = localize {type = 'variable', key = 'a_xmult', vars = {card.ability.extra.x_mult} },
                Xmult_mod = card.ability.extra.x_mult
        }
     end
  end
}

SMODS.Joker {
  key = 'Dredd',
  loc_txt = {
    name = 'Judge Jury and Executioner',
    text = {
      "When {C:attention}Blind{} is selected", "{C:green}#1# in #2#{} chance to create", "a {C:tarot}Judgement{}, {C:tarot}Justice{}", "or {C:tarot}Hanged Man{}", "{C:inactive}(Must have room)"
    }
  },
  config = { extra = {odds = 4} },
  rarity = 2,
  atlas = 'JestersPrivilegeAtlas',
  pos = { x = 2, y = 0 },
  cost = 4,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  eternal_compat = true,
  perishable_compat = true,
   loc_vars = function(self, info_queue, card)
    return {
      vars = {G.GAME.probabilities.normal, card.ability.extra.odds,}
    }
  end,

  calculate = function(self, card, context)
    if context.setting_blind then
            if pseudorandom('DREDD') < G.GAME.probabilities.normal / card.ability.extra.odds then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
              trigger = 'before',
              delay = 0.0,
              func = (function()
                  local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, 'c_judgement', 'sup')
                  card:add_to_deck()
                  G.consumeables:emplace(card)
                  G.GAME.consumeable_buffer = 0
                return true
              end)}))
        elseif pseudorandom('DREDD') < G.GAME.probabilities.normal / card.ability.extra.odds then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
              trigger = 'before',
              delay = 0.0,
              func = (function()
                  local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, 'c_justice', 'sup')
                  card:add_to_deck()
                  G.consumeables:emplace(card)
                  G.GAME.consumeable_buffer = 0
                return true
              end)}))
        elseif pseudorandom('DREDD') < G.GAME.probabilities.normal / card.ability.extra.odds then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
              trigger = 'before',
              delay = 0.0,
              func = (function()
                  local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, 'c_hanged_man', 'sup')
                  card:add_to_deck()
                  G.consumeables:emplace(card)
                  G.GAME.consumeable_buffer = 0
                return true
              end)}))
        end
    end
  end
}