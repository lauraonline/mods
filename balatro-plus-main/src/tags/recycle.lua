local t = {
  loc_txt = {
    name = "Recycle Tag",
    text = {
      "Create last added tag",
      "{s:0.8,C:green}Recycle Tag {s:0.8}excluded",
    },
  },
  atlas = 11,
  config = { type = "immediate" },
}

function t:loc_vars(infoq)
  local last_tag = G.P_TAGS[G.GAME.bplus_recycle_tag_last_tag]
  local last_tag_name = last_tag
      and localize { type = "name_text", key = last_tag.key, set = "Tag" }
    or localize("k_none")
  local colour = last_tag and G.C.GREEN or G.C.RED

  if last_tag then
    infoq[#infoq + 1] =
      { key = last_tag.key, set = "Tag", specific_vars = bplus_tag_loc_vars(last_tag, infoq) }
  end

  return {
    main_end = {
      {
        n = G.UIT.C,
        config = { align = "bm", padding = 0.02 },
        nodes = {
          {
            n = G.UIT.C,
            config = { align = "m", colour = colour, r = 0.05, padding = 0.05 },
            nodes = {
              {
                n = G.UIT.T,
                config = {
                  text = " " .. last_tag_name .. " ",
                  colour = G.C.UI.TEXT_LIGHT,
                  scale = 0.3,
                  shadow = true,
                },
              },
            },
          },
        },
      },
    },
  }
end

function t:apply(tag, ctx)
  if ctx.type == "immediate" then
    tag:yep("+", G.C.GREEN, function()
      return true
    end)
    local last_tag = G.GAME.bplus_recycle_tag_last_tag
    if last_tag then
      local tag = Tag(last_tag)
      add_tag(tag)
      tag:apply_to_run { type = "immediate" }
    end
    tag.triggered = true
  end
end

return t
