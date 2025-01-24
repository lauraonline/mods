local t = {
  loc_txt = {
    name = "Glow Tag",
    text = {
      "Add random {C:dark_edition}edition{} to",
      "random Joker if any",
    },
  },
  min_ante = 3,
  atlas = 1,
  config = { type = "immediate" },
}

local function set_edition(tag, joker)
  local edition = pseudorandom_element(bplus_get_editions(), pseudoseed("tag_bplus_glow_edition"))
  joker._edition = edition
  tag:yep("+", G.C.DARK_EDITION, function()
    joker:set_edition({ [edition] = true }, true)
    joker._edition = nil
    return true
  end)
  tag.triggered = true
end

function t:apply(tag, ctx)
  if ctx.type == "immediate" then
    local jokers = {}
    for _, j in ipairs(G.jokers.cards) do
      if not j.edition then
        jokers[#jokers + 1] = j
      end
    end

    if next(jokers) then
      local joker = pseudorandom_element(jokers, pseudoseed("tag_bplus_glow_joker"))
      set_edition(tag, joker)
      return true
    end
  elseif ctx.type == "card_added" and ctx.cardarea == G.jokers then
    if not ctx.card.edition and not ctx.card._edition then
      set_edition(tag, ctx.card)
    end
  end
end

return t
