local j = {
  loc_txt = {
    name = "Calculator",
    text = {
      "If all played cards is",
      "{C:attention}numbered{} card {C:inactive}(2 to 10){}",
      "add the sum of all played",
      "cards to the {C:mult}Mult{}",
    },
  },
  rarity = 1,
  cost = 5,
  atlas = 3,

  blueprint_compat = true,
}

function j:calculate(_, ctx)
  if ctx.joker_main then
    local is_numbered = true
    local total = 0
    for _, c in ipairs(ctx.full_hand) do
      if not c.debuff and not c:is_face() then
        local id = c:get_id()
        if id < 2 or id > 10 then
          is_numbered = false
          break
        end
        total = total + id
      end
    end

    if not is_numbered then
      return
    end

    return {
      message = localize {
        type = "variable",
        key = "a_mult",
        vars = { total },
      },
      mult_mod = total,
    }
  end
end

return j
