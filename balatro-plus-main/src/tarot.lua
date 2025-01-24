return function(tarot_dir, tarots)
  SMODS.Atlas {
    key = "tarots",
    px = 71,
    py = 95,
    path = "consumables/tarots.png",
  }

  for k, t in pairs(tarots) do
    if type(t) == "string" then
      if type(k) == "number" then
        k = t
      end
      t = BalatroPlus.load(tarot_dir .. "/" .. t) or t
    end
    if type(t) == "table" then
      t.key = k
      t.set = "Tarot"
      t.cost = t.cost or 3

      if type(t.atlas) == "number" then
        local n = t.atlas
        t.atlas = "tarots"
        local x = n % 6
        if x == 0 then
          x = 6
        end
        t.pos = { x = x - 1, y = math.ceil(n / 6) - 1 }
      end

      t.discovered = false
      SMODS.Consumable(t)
    end
  end
end
