return function(booster_dir, boosters)
  SMODS.Atlas {
    key = "boosters",
    px = 71,
    py = 95,
    path = "boosters.png",
  }

  for k, p in pairs(boosters) do
    if type(p) == "string" then
      if type(k) == "number" then
        k = p
      end
      p = BalatroPlus.load(booster_dir .. "/" .. p) or p
    end
    if type(p) == "table" then
      if type(p.atlas) == "number" then
        local n = p.atlas
        p.atlas = "boosters"
        local x = n % 4
        if x == 0 then
          x = 4
        end
        p.pos = { x = x - 1, y = math.ceil(n / 4) - 1 }
      end

      p.key = k
      p.discovered = false
      SMODS.Booster(p)
    end
  end
end
