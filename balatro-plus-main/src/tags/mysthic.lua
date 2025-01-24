local t = {
  loc_txt = {
    name = "Mysthic Tag",
    text = {
      "Gives a free",
      "{C:bplus_sigil}Mega Mysthic Pack",
    },
  },
  atlas = 8,
  config = { type = "immediate" },
}

function t:apply(tag, ctx)
  if ctx.type == "immediate" then
    tag:yep("+", G.C.SECONDARY_SET.sigil, function()
      bplus_open_pack("p_bplus_mysthic_mega", true)
      return true
    end)
    tag.triggered = true
  end
end

return t
