return function(enchancement_dir, enhancements)
  SMODS.Atlas {
    key = "enhancements",
    px = 71,
    py = 95,
    path = "enhancements.png",
  }

  for k, e in pairs(enhancements) do
    if type(e) == "string" then
      if type(k) == "number" then
        k = e
      end
      e = BalatroPlus.load(enchancement_dir .. "/" .. e) or e
    end
    if type(e) == "table" then
      if type(e.atlas) == "number" then
        local n = e.atlas
        e.atlas = "enhancements"
        local x = n % 5
        if x == 0 then
          x = 5
        end
        e.pos = { x = x - 1, y = math.ceil(n / 5) - 1 }
      end

      e.key = k
      SMODS.Enhancement(e)
    end
  end
end
