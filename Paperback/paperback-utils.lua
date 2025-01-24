PB_UTIL = {}

-- Creates the flags
local BackApply_to_run_ref = Back.apply_to_run
function Back.apply_to_run(arg_56_0)
  BackApply_to_run_ref(arg_56_0)
  G.GAME.pool_flags.quick_fix_can_spawn = true
  G.GAME.pool_flags.soft_taco_can_spawn = false
  G.GAME.pool_flags.ghost_cola_can_spawn = false
  G.GAME.pool_flags.dreamsicle_can_spawn = true
  G.GAME.pool_flags.cakepop_can_spawn = true
  G.GAME.pool_flags.caramel_apple_can_spawn = true
  G.GAME.pool_flags.charred_marshmallow_can_spawn = true
  G.GAME.pool_flags.sticks_can_spawn = false

  G.P_CENTERS['j_diet_cola']['no_pool_flag'] = 'ghost_cola_can_spawn'
end

-- set_cost hook for zeroing out a sell value
local set_cost_ref = Card.set_cost
function Card.set_cost(self)
  if G.STAGE == G.STAGES.RUN and self.added_to_deck then
    -- If this card is Union Card, set sell cost to 0
    if self.config.center.key == "j_paperback_union_card" then
      self.sell_cost = 0
      return
    end

    if next(SMODS.find_card("j_paperback_union_card")) then
      self.sell_cost = 0
      return
    end
  end

  -- Don't calculate the original sell_cost calculation if a custom sell_cost increase has been indicated
  if self.custom_sell_cost then
    self.sell_cost = self.sell_cost + (self.custom_sell_cost_increase or 1)
    self.custom_sell_cost_increase = nil
  else
    set_cost_ref(self)
  end

  -- if trying to set the sell cost to zero, set it to zero
  if self.zero_sell_cost then
    self.sell_cost = 0
    self.custom_sell_cost = true
    self.zero_sell_cost = nil
  end
end

-- Add new context for destroying cards of any type (Used for Sacrificial Lamb)
local start_dissolve_ref = Card.start_dissolve
function Card:start_dissolve(dissolve_colours, silent, dissolve_time_fac, no_juice)
  if self.getting_sliced then
    for i = 1, #G.jokers.cards do
      G.jokers.cards[i]:calculate_joker({ destroying_cards = true, destroyed_card = self })
    end
  end

  start_dissolve_ref(self, dissolve_colours, silent, dissolve_time_fac, no_juice)
end

-- Add new context that happens before triggering tags
local yep_ref = Tag.yep
function Tag.yep(self, message, _colour, func)
  for k, v in ipairs(G.jokers.cards) do
    v:calculate_joker({
      paperback_using_tag = true,
      paperback_tag = self
    })
  end

  return yep_ref(self, message, _colour, func)
end

local remove_ref = Card.remove
function Card.remove(self)
  -- Check that the card being removed is a joker that's in the player's deck and that it's not being sold
  if self.added_to_deck and self.ability.set == 'Joker' and not G.CONTROLLER.locks.selling_card then
    for k, v in ipairs(G.jokers.cards) do
      -- Make sure the joker that triggers due to this card's removal is not being removed itself
      if not v.removed and not v.getting_sliced then
        if v.config.center_key == 'j_paperback_sacrificial_lamb' then
          v.ability.extra.mult = v.ability.extra.mult + v.ability.extra.mult_mod

          SMODS.eval_this(v, {
            message = localize {
              type = 'variable',
              key = 'a_mult',
              vars = { v.ability.extra.mult_mod }
            }
          })
        elseif v.config.center_key == 'j_paperback_unholy_alliance' then
          v.ability.extra.xMult = v.ability.extra.xMult + v.ability.extra.xMult_gain

          SMODS.eval_this(v, {
            message = localize {
              type = 'variable',
              key = 'a_xmult',
              vars = { v.ability.extra.xMult_gain }
            }
          })
        end
      end
    end
  end

  return remove_ref(self)
end

function PB_UTIL.calculate_stick_xMult(card)
  local xMult = card.ability.extra.xMult

  -- Only calculate the xMult if the G.jokers cardarea exists
  if G.jokers and G.jokers.cards then
    for k, current_card in pairs(G.jokers.cards) do
      if current_card ~= card and string.match(string.lower(current_card.ability.name), "%f[%w]stick%f[%W]") then
        xMult = xMult + card.ability.extra.xMult
      end
    end
  end

  return xMult
end

PB_UTIL.base_poker_hands = {
  "Straight Flush",
  "Four of a Kind",
  "Full House",
  "Flush",
  "Straight",
  "Three of a Kind",
  "Two Pair",
  "Pair",
  "High Card"
}

-- Gets the number of unique suits in a scoring hand
function PB_UTIL.get_unique_suits(scoring_hand)
  -- Initialize the suits table
  local suits = {}

  for k, v in pairs(SMODS.Suits) do
    suits[k] = 0
  end

  -- Check for unique suits in scoring_hand
  for i = 1, #scoring_hand do
    local scoring_card = scoring_hand[i]

    for scoring_suit, _ in pairs(suits) do
      if suits[scoring_suit] == 0 and scoring_card:is_suit(scoring_suit, true) then
        suits[scoring_suit] = 1

        -- Stop checking other suits if it's a Wild Card
        if scoring_card.ability.name == 'Wild Card' then
          break
        end
      end
    end
  end

  local unique_suits = 0

  for _, v in pairs(suits) do
    unique_suits = unique_suits + v
  end

  return unique_suits
end

function PB_UTIL.is_in_your_collection(card)
  if not G.your_collection then return false end
  for i = 1, 3 do
    if (G.your_collection[i] and card.area == G.your_collection[i]) then return true end
  end
  return false
end

function PB_UTIL.xChips(amt, card)
  hand_chips = mod_chips(hand_chips * (amt or 1))
  update_hand_text(
    { delay = 0 },
    { chips = hand_chips }
  )

  SMODS.calculate_effect({
    message = localize {
      type = 'variable',
      key = 'paperback_a_xchips',
      vars = { (amt or 1) }
    },
    colour = G.C.CHIPS,
    sound = 'chips1'
  }, card)
end

-- Gets a pseudorandom tag from the Tag pool
function PB_UTIL.poll_tag(seed)
  -- This part is basically a copy of how the base game does it
  -- Look at get_next_tag_key in common_events.lua
  local pool = get_current_pool('Tag')
  local tag_key = pseudorandom_element(pool, pseudoseed(seed))

  while tag_key == 'UNAVAILABLE' do
    tag_key = pseudorandom_element(pool, pseudoseed(seed))
  end

  local tag = Tag(tag_key)

  -- The way the hand for an orbital tag in the base game is selected could cause issues
  -- with mods that modify blinds, so we randomly pick one from all visible hands
  if tag_key == "tag_orbital" then
    local available_hands = {}

    for k, hand in pairs(G.GAME.hands) do
      if hand.visible then
        available_hands[#available_hands + 1] = k
      end
    end

    tag.ability.orbital_hand = pseudorandom_element(available_hands, pseudoseed(seed .. '_orbital'))
  end

  return tag
end

-- Gets a psuedorandom consumable from the Consumables pool (Soul and Black Hole included)
function PB_UTIL.poll_consumable(seed, soulable)
  local types = {}

  for k, v in pairs(SMODS.ConsumableTypes) do
    types[#types + 1] = k
  end

  return SMODS.create_card {
    set = pseudorandom_element(types, pseudoseed(seed)),
    area = G.consumables,
    soulable = soulable,
    key_append = seed,
  }
end

function PB_UTIL.destroy_joker(card, after)
  G.E_MANAGER:add_event(Event({
    func = function()
      play_sound('tarot1')
      card.T.r = -0.2
      card:juice_up(0.3, 0.4)
      card.states.drag.is = true
      card.children.center.pinch.x = true
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.3,
        blockable = false,
        func = function()
          G.jokers:remove_card(card)
          card:remove()

          if after and type(after) == "function" then
            after()
          end

          return true
        end
      }))
      return true
    end
  }))
end

-- If Cryptid is also loaded, add food jokers to pool for ://SPAGHETTI
if (SMODS.Mods["Cryptid"] or {}).can_load then
  table.insert(Cryptid.food, "j_paperback_cakepop")
  table.insert(Cryptid.food, "j_paperback_caramel_apple")
  table.insert(Cryptid.food, "j_paperback_charred_marshmallow")
  table.insert(Cryptid.food, "j_paperback_crispy_taco")
  table.insert(Cryptid.food, "j_paperback_dreamsicle")
  table.insert(Cryptid.food, "j_paperback_ghost_cola")
  table.insert(Cryptid.food, "j_paperback_joker_cookie")
  table.insert(Cryptid.food, "j_paperback_nachos")
  table.insert(Cryptid.food, "j_paperback_soft_taco")
  table.insert(Cryptid.food, "j_paperback_complete_breakfast")
  table.insert(Cryptid.food, "j_paperback_coffee")
  table.insert(Cryptid.food, "j_paperback_cream_liqueur")
end

return PB_UTIL
