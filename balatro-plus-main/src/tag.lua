return function(tag_dir, tags)
  SMODS.Atlas {
    key = "tags",
    px = 34,
    py = 34,
    path = "tags.png",
  }

  for k, t in pairs(tags) do
    if type(t) == "string" then
      if type(k) == "number" then
        k = t
      end
      t = BalatroPlus.load(tag_dir .. "/" .. t) or t
    end
    if type(t) == "table" then
      if type(t.atlas) == "number" then
        local n = t.atlas
        t.atlas = "tags"
        local x = n % 6
        if x == 0 then
          x = 6
        end
        t.pos = { x = x - 1, y = math.ceil(n / 6) - 1 }
      end

      t.key = k
      t.discovered = false
      SMODS.Tag(t)
    end
  end
end
