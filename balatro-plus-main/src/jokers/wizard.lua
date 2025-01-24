local j = {
  loc_txt = {
    name = "Wizard",
    text = {
      "After {C:attention}#1#{} {C:inactive}[#2#]{} cards destroyed",
      "create a random {C:bplus_sigil}Sigil{} card",
      "when blind is selected",
      "{C:inactive}(Must have room)",
    },
  },
  config = { extra = { every = 5, remaining = 5 } },
  rarity = 2,
  cost = 8,
  atlas = 34,

  blueprint_compat = true,
}

function j:loc_vars(_, card)
  local remaining = card.ability.extra.remaining
  return { vars = { card.ability.extra.every, remaining == 0 and "active" or remaining } }
end

function j:calculate(card, ctx)
  if ctx.remove_playing_cards and not ctx.blueprint then
    local remaining = card.ability.extra.remaining
    card.ability.extra.remaining = math.max(card.ability.extra.remaining - #ctx.removed, 0)
    if remaining ~= 0 then
      juice_card_until(card, function(c)
        return c.ability.extra.remaining == 0
      end)
    end
  elseif
    ctx.setting_blind
    and not (ctx.blueprint_card or card).getting_sliced
    and card.ability.extra.remaining == 0
    and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
  then
    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
    G.E_MANAGER:add_event(Event {
      func = function()
        local sigil =
          create_card("sigil", G.consumeables, nil, nil, nil, nil, nil, "j_bplus_wizard_sigil")
        sigil:add_to_deck()
        G.consumeables:emplace(sigil)
        G.GAME.consumeable_buffer = 0
        return true
      end,
    })

    card_eval_status_text(ctx.blueprint_card or card, "extra", nil, nil, nil, {
      message = localize { type = "variable", key = "k_bplus_plus_sigil_ex", vars = { 1 } },
      colour = G.C.SECONDARY_SET.sigil,
    })
  elseif ctx.post_setting_blind and not ctx.blueprint and card.ability.extra.remaining == 0 then
    card.ability.extra.created = nil
    card.ability.extra.remaining = card.ability.extra.every
  end
end

return j
