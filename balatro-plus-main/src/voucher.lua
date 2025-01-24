return function(voucher_dir, vouchers)
  SMODS.Atlas {
    key = "vouchers",
    px = 71,
    py = 95,
    path = "vouchers.png",
  }

  for k, v in pairs(vouchers) do
    if type(v) == "string" then
      if type(k) == "number" then
        k = v
      end
      v = BalatroPlus.load(voucher_dir .. "/" .. v) or v
    end
    if type(v) == "table" then
      if type(v.atlas) == "number" then
        local n = v.atlas
        v.atlas = "vouchers"
        local x = n % 4
        if x == 0 then
          x = 4
        end
        v.pos = { x = x - 1, y = math.ceil(n / 4) - 1 }
      end

      v.key = k
      if type(v.unlocked) ~= "boolean" then
        v.unlocked = true
      end
      v.discovered = false
      SMODS.Voucher(v)
    end
  end
end
