--- STEAMODDED HEADER
--- MOD_NAME: Fold Button
--- MOD_ID: FoldButton
--- MOD_AUTHOR: [happinyz]
--- MOD_DESCRIPTION: Quickly forfeit your runs with the 'Fold' button!
----------------------------------------------
------------MOD CODE -------------------------

function G.FUNCS.fold_button(e)
  G.STATE = G.STATES.GAME_OVER
  if not G.GAME.won and not G.GAME.seeded and not G.GAME.challenge then 
      G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
  end
  G:save_settings()
  G.FILE_HANDLER.force = true
  G.STATE_COMPLETE = false
  G.SETTINGS.paused = false
end


local createOptionsRef = create_UIBox_options
function create_UIBox_options()
  contents = createOptionsRef()

  if G.STATE ~= G.STATES.MENU then
    local fold_button = UIBox_button({
      minw = 5,
      button = "fold_button",
      label = {
        "Fold"
      },
      colour = HEX('E82C20')
    })
    table.insert(contents.nodes[1].nodes[1].nodes[1].nodes, #contents.nodes[1].nodes[1].nodes[1].nodes + 1, fold_button)
  end
  return contents
end



----------------------------------------------
------------MOD CODE END----------------------
