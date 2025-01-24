local c = {
  primary_colour = HEX("8e32db"),
  secondary_colour = HEX("5524b0"),
  loc_txt = {
    name = "Sigil",
    collection = "Sigil Cards",
    undiscovered = {
      name = "Not Dicovered",
      text = {
        "Purchase or use",
        "this card in an",
        "unseeded run to",
        "learn what it does",
      },
    },
  },
  default = "c_bplus_sigil_blank",
  atlas = "consumables/sigils.png",
  collection_rows = { 3, 4 },
  cards = {
    "blank",
    "polyc",
    "rebirth",
    "dupe",
    "curse",
    "astra",
    "beast",

    "aye",
    "bann",
    "froze",
    "sacre",
    "rewind",
    "klone",
    "shine",
  },
}

return c
